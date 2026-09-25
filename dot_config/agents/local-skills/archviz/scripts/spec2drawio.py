#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.13"
# dependencies = []
# ///
"""JSON のグラフ仕様から Graphviz でレイアウトを計算し、draw.io (.drawio) を出力する。

座標を手計算せずに、GUI で手直しできる draw.io ファイルを作るためのもの。
グループはコンテナとして入れ子にするので、draw.io 上でグループごと移動できる。

使い方:
    uv run spec2drawio.py spec.json out.drawio

dot が PATH に無ければ `nix shell nixpkgs#graphviz -c dot` を使う。
仕様フォーマットは references/drawio.md を参照。
"""

import json
import shutil
import subprocess
import sys
from xml.sax.saxutils import escape, quoteattr

# kind -> (draw.io style, 既定サイズ px)
NODE_STYLES = {
    "person": ("rounded=1;arcSize=40;fillColor=#f8cecc;strokeColor=#b85450;fontStyle=1;", (140, 60)),
    "client": ("rounded=1;fillColor=#e1d5e7;strokeColor=#9673a6;", (140, 60)),
    "service": ("rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;", (160, 60)),
    "component": ("rounded=0;fillColor=#ffffff;strokeColor=#333333;", (160, 50)),
    "database": ("shape=cylinder3;boundedLbl=1;size=10;fillColor=#d5e8d4;strokeColor=#82b366;", (130, 80)),
    "queue": ("shape=cylinder3;direction=south;boundedLbl=1;size=10;fillColor=#fff2cc;strokeColor=#d6b656;", (160, 60)),
    "storage": ("shape=folder;tabWidth=40;tabHeight=12;tabPosition=left;fillColor=#f5f5f5;strokeColor=#666666;", (140, 70)),
    "device": ("rounded=0;fillColor=#ffe6cc;strokeColor=#d79b00;", (140, 60)),
    "external": ("rounded=1;dashed=1;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;", (160, 60)),
}
NODE_LABELS = {
    "person": "人/アクター", "client": "クライアント", "service": "サービス/プロセス",
    "component": "コンポーネント", "database": "DB", "queue": "キュー/トピック",
    "storage": "ストレージ", "device": "デバイス", "external": "外部システム",
}
GROUP_STYLES = {
    "boundary": "rounded=1;dashed=1;fillColor=none;strokeColor=#666666;",
    "zone": "rounded=0;fillColor=#f7f7f7;strokeColor=#bbbbbb;",
    "deployment": "rounded=0;fillColor=none;strokeColor=#333333;strokeWidth=2;",
}
EDGE_STYLES = {
    "sync": "endArrow=block;endFill=1;",
    "async": "endArrow=open;dashed=1;",
    "data": "endArrow=block;endFill=1;dashed=1;dashPattern=1 3;",
}
EDGE_LABELS = {"sync": "同期呼び出し", "async": "非同期メッセージ", "data": "データの流れ"}

# whiteSpace=wrap を付けると html=0 でも foreignObject で書き出され、rsvg や Inkscape で文字が消える
COMMON_NODE = "html=0;fontSize=13;"
COMMON_GROUP = "container=1;collapsible=0;html=0;verticalAlign=top;align=left;spacingLeft=8;spacingTop=4;fontSize=14;fontStyle=1;"
COMMON_EDGE = "edgeStyle=orthogonalEdgeStyle;rounded=1;html=0;fontSize=11;labelBackgroundColor=#ffffff;strokeColor=#444444;"


def dot_cmd():
    if shutil.which("dot"):
        return ["dot"]
    return ["nix", "shell", "nixpkgs#graphviz", "-c", "dot"]


def q(s):
    return '"' + str(s).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def build_dot(spec):
    groups = {g["id"]: g for g in spec.get("groups", [])}
    children = {gid: [] for gid in groups}
    top_groups, top_nodes = [], []
    for g in groups.values():
        (children[g["parent"]] if g.get("parent") else top_groups).append(("g", g["id"]))
    for n in spec["nodes"]:
        (children[n["group"]] if n.get("group") else top_nodes).append(("n", n["id"]))

    lines = [
        "digraph G {",
        f'  graph [rankdir={spec.get("direction", "LR")}, nodesep=0.6, ranksep=1.0, compound=true, splines=ortho];',
        "  node [shape=box, fixedsize=true, fontsize=13];",
    ]
    nodes = {n["id"]: n for n in spec["nodes"]}

    def emit_node(nid, indent):
        n = nodes[nid]
        _, (w, h) = NODE_STYLES.get(n.get("kind", "service"), NODE_STYLES["service"])
        w, h = n.get("width", w), n.get("height", h)
        lines.append(f"{indent}{q(nid)} [label={q(n.get('label', nid))}, width={w / 72:.3f}, height={h / 72:.3f}];")

    def emit_group(gid, indent):
        g = groups[gid]
        lines.append(f"{indent}subgraph {q('cluster_' + gid)} {{")
        # ラベル分の余白を確保するため label を付ける
        lines.append(f"{indent}  label={q(g.get('label', gid))}; labeljust=l; margin=24; fontsize=14;")
        for kind, cid in children[gid]:
            (emit_group if kind == "g" else emit_node)(cid, indent + "  ")
        lines.append(f"{indent}}}")

    for _, gid in top_groups:
        emit_group(gid, "  ")
    for _, nid in top_nodes:
        emit_node(nid, "  ")
    for i, e in enumerate(spec.get("edges", [])):
        attrs = f", xlabel={q(e['label'])}" if e.get("label") else ""
        lines.append(f"  {q(e['from'])} -> {q(e['to'])} [id=e{i}{attrs}];")
    lines.append("}")
    return "\n".join(lines)


def layout(spec):
    res = subprocess.run(dot_cmd() + ["-Tjson"], input=build_dot(spec), capture_output=True, text=True, check=True)
    data = json.loads(res.stdout)
    _, _, _, gh = map(float, data["bb"].split(","))
    boxes = {}
    for o in data.get("objects", []):
        name = o["name"]
        if name.startswith("cluster_"):
            x0, y0, x1, y1 = map(float, o["bb"].split(","))
            boxes[("g", name[len("cluster_"):])] = (x0, gh - y1, x1 - x0, y1 - y0)
        elif "pos" in o:
            x, y = map(float, o["pos"].split(","))
            w, h = float(o["width"]) * 72, float(o["height"]) * 72
            boxes[("n", name)] = (x - w / 2, gh - y - h / 2, w, h)
    # dot はエッジを入力順に出力しないので id で対応付ける。splines=ortho なので折れ点だけ抜き出す
    routes = [[] for _ in spec.get("edges", [])]
    for e in data.get("edges", []):
        pts = [p for op in e.get("_draw_", []) if op["op"] == "b" for p in op["points"]]
        routes[int(e["id"][1:])] = [(x, gh - y) for x, y in corners(pts)[1:-1]]
    return boxes, routes


def corners(pts):
    dedup = []
    for p in pts:
        if not dedup or abs(p[0] - dedup[-1][0]) > 0.5 or abs(p[1] - dedup[-1][1]) > 0.5:
            dedup.append(p)
    out = dedup[:1]
    for prev, cur, nxt in zip(dedup, dedup[1:], dedup[2:]):
        collinear = abs((cur[0] - prev[0]) * (nxt[1] - cur[1]) - (cur[1] - prev[1]) * (nxt[0] - cur[0])) < 1.0
        if not collinear:
            out.append(cur)
    return out + dedup[-1:] if len(dedup) > 1 else out


def cell(cid, value, style, parent, geom, vertex=True):
    x, y, w, h = geom
    kind = 'vertex="1"' if vertex else 'edge="1"'
    return (f'<mxCell id={quoteattr(cid)} value={quoteattr(value)} style={quoteattr(style)} {kind} parent={quoteattr(parent)}>'
            f'<mxGeometry x="{x:.0f}" y="{y:.0f}" width="{w:.0f}" height="{h:.0f}" as="geometry"/></mxCell>')


def render(spec, boxes, routes):
    offset_y = 50 if spec.get("title") else 10
    offset_x = 10
    groups = {g["id"]: g for g in spec.get("groups", [])}
    out = []

    def absbox(key):
        x, y, w, h = boxes[key]
        return x + offset_x, y + offset_y, w, h

    def rel(key, parent_gid):
        x, y, w, h = absbox(key)
        if parent_gid:
            px, py, _, _ = absbox(("g", parent_gid))
            x, y = x - px, y - py
        return x, y, w, h

    if spec.get("title"):
        out.append(cell("title", spec["title"], "text;html=0;fontSize=20;fontStyle=1;align=left;verticalAlign=middle;", "1", (offset_x, 5, 600, 35)))

    # 親を先に出力する必要があるので深さ順に並べる
    def depth(gid):
        d = 0
        while groups[gid].get("parent"):
            gid, d = groups[gid]["parent"], d + 1
        return d

    for gid in sorted(groups, key=depth):
        g = groups[gid]
        style = GROUP_STYLES.get(g.get("kind", "boundary"), GROUP_STYLES["boundary"]) + COMMON_GROUP
        out.append(cell("g_" + gid, g.get("label", gid), style, "g_" + g["parent"] if g.get("parent") else "1", rel(("g", gid), g.get("parent"))))

    used_kinds = []
    for n in spec["nodes"]:
        kind = n.get("kind", "service")
        used_kinds.append(kind)
        style = NODE_STYLES.get(kind, NODE_STYLES["service"])[0] + COMMON_NODE
        parent = "g_" + n["group"] if n.get("group") else "1"
        out.append(cell("n_" + n["id"], n.get("label", n["id"]), style, parent, rel(("n", n["id"]), n.get("group"))))

    used_edges = []
    for i, e in enumerate(spec.get("edges", [])):
        est = e.get("style", "sync")
        used_edges.append(est)
        style = EDGE_STYLES.get(est, EDGE_STYLES["sync"]) + COMMON_EDGE
        if e.get("bidirectional"):
            style += "startArrow=block;startFill=1;"
        # Graphviz の折れ点を中継点にする。drawio 任せだと他ノードを突き抜けることがある
        pts = "".join(f'<mxPoint x="{x + offset_x:.0f}" y="{y + offset_y:.0f}"/>' for x, y in routes[i])
        waypoints = f'<Array as="points">{pts}</Array>' if pts else ""
        out.append(f'<mxCell id="e{i}" value={quoteattr(e.get("label", ""))} style={quoteattr(style)} edge="1" parent="1" '
                   f'source="n_{escape(e["from"])}" target="n_{escape(e["to"])}"><mxGeometry relative="1" as="geometry">{waypoints}</mxGeometry></mxCell>')

    if spec.get("legend", True):
        out.extend(legend(spec, boxes, offset_x, offset_y, used_kinds, used_edges))

    return ('<mxfile host="spec2drawio"><diagram name="Page-1"><mxGraphModel grid="1" gridSize="10" page="0">'
            '<root><mxCell id="0"/><mxCell id="1" parent="0"/>' + "".join(out) + "</root></mxGraphModel></diagram></mxfile>\n")


def legend(spec, boxes, ox, oy, kinds, edges):
    kinds = list(dict.fromkeys(kinds))
    edges = list(dict.fromkeys(edges))
    labels = {**NODE_LABELS, **spec.get("legend_labels", {})}
    elabels = {**EDGE_LABELS, **spec.get("legend_labels", {})}
    max_y = max(y + h for _, y, _, h in boxes.values()) + oy
    x0, y0 = ox, max_y + 30
    rows = len(kinds) + len(edges)
    out = [cell("legend", "凡例", "rounded=0;fillColor=#ffffff;strokeColor=#999999;verticalAlign=top;align=left;spacingLeft=8;fontStyle=1;html=0;container=1;collapsible=0;",
                "1", (x0, y0, 230, 36 + rows * 34))]
    y = 30
    for k in kinds:
        out.append(cell(f"lg_{k}", "", NODE_STYLES.get(k, NODE_STYLES["service"])[0] + "html=0;", "legend", (12, y, 50, 24)))
        out.append(cell(f"lgt_{k}", labels.get(k, k), "text;html=0;align=left;verticalAlign=middle;fontSize=12;", "legend", (72, y, 150, 24)))
        y += 34
    for est in edges:
        out.append(f'<mxCell id="lge_{est}" value="" style={quoteattr(EDGE_STYLES.get(est, EDGE_STYLES["sync"]) + "html=0;strokeColor=#444444;")} edge="1" parent="legend">'
                   f'<mxGeometry relative="1" as="geometry"><mxPoint x="12" y="{y + 12}" as="sourcePoint"/><mxPoint x="62" y="{y + 12}" as="targetPoint"/></mxGeometry></mxCell>')
        out.append(cell(f"lget_{est}", elabels.get(est, est), "text;html=0;align=left;verticalAlign=middle;fontSize=12;", "legend", (72, y, 150, 24)))
        y += 34
    return out


def validate(spec):
    ids = {n["id"] for n in spec["nodes"]}
    gids = {g["id"] for g in spec.get("groups", [])}
    errs = []
    for n in spec["nodes"]:
        if n.get("group") and n["group"] not in gids:
            errs.append(f"node {n['id']}: 未定義の group {n['group']}")
    for g in spec.get("groups", []):
        if g.get("parent") and g["parent"] not in gids:
            errs.append(f"group {g['id']}: 未定義の parent {g['parent']}")
    for e in spec.get("edges", []):
        for end in ("from", "to"):
            if e[end] not in ids:
                errs.append(f"edge {e['from']}->{e['to']}: 未定義のノード {e[end]} (グループへの接続は不可)")
    if errs:
        sys.exit("spec エラー:\n  " + "\n  ".join(errs))


def main():
    if len(sys.argv) != 3:
        sys.exit(__doc__)
    with open(sys.argv[1], encoding="utf-8") as f:
        spec = json.load(f)
    validate(spec)
    xml = render(spec, *layout(spec))
    with open(sys.argv[2], "w", encoding="utf-8") as f:
        f.write(xml)
    print(f"wrote {sys.argv[2]}")


if __name__ == "__main__":
    main()
