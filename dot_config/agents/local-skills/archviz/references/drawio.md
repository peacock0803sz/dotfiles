# draw.io 出力

draw.io の XML は座標を全部書く必要があり、手で書くと重なりや線の突き抜けが起きやすい。そこで、JSON の仕様を書いて `scripts/spec2drawio.py` に変換させる。このスクリプトは Graphviz でレイアウトと線の経路を計算し、グループを入れ子コンテナとして出力するので、GUI 上でもグループごと動かせる。

## 実行

スクリプトは shebang で `uv run --script` を呼ぶ。パスを直接指定して実行すること(`uv run` や `python` を前置すると許可設定で拒否される)。

```bash
~/.claude/skills/archviz/scripts/spec2drawio.py spec.json out.drawio
nix run nixpkgs#drawio -- -x -f svg -o out.svg out.drawio
nix run nixpkgs#drawio -- -x -f png --scale 1.5 -o <scratchpad>/check.png out.drawio
```

- drawio CLI が `sandbox_extension_issue_file failed ...` を出すが、無害なので無視してよい
- spec.json は作業用なので scratchpad に置き、納品物は `.drawio` と `.svg` にする。ユーザーが後から再生成したいなら、spec.json も納品物に加える

## 仕様フォーマット

```json
{
  "title": "注文システム コンテナ図",
  "direction": "LR",
  "legend": true,
  "groups": [
    {"id": "aws", "label": "AWS ap-northeast-1", "kind": "deployment"},
    {"id": "vpc", "label": "VPC", "kind": "boundary", "parent": "aws"}
  ],
  "nodes": [
    {"id": "user", "label": "購入者", "kind": "person"},
    {"id": "api", "label": "Order API\n(Go)", "kind": "service", "group": "vpc"},
    {"id": "db", "label": "orders DB\n(PostgreSQL)", "kind": "database", "group": "vpc"},
    {"id": "q", "label": "order-events\n(SQS)", "kind": "queue", "group": "aws"},
    {"id": "stripe", "label": "Stripe", "kind": "external"}
  ],
  "edges": [
    {"from": "user", "to": "api", "label": "HTTPS/JSON"},
    {"from": "api", "to": "db", "label": "SQL"},
    {"from": "api", "to": "q", "label": "publish OrderPlaced", "style": "async"},
    {"from": "api", "to": "stripe", "label": "REST"}
  ]
}
```

| フィールド | 値 |
|---|---|
| `direction` | `LR`(既定) / `TB` / `RL` / `BT` |
| `nodes[].kind` | `person` `client` `service`(既定) `component` `database` `queue` `storage` `device` `external` |
| `nodes[].width/height` | px。ラベルが長くてはみ出すときに指定する(既定は kind ごとに 130〜160 × 50〜80) |
| `groups[].kind` | `boundary`(破線、既定) `zone`(灰色の塗り) `deployment`(実線太) |
| `groups[].parent` | 入れ子にする親グループの id |
| `edges[].style` | `sync`(実線、既定) `async`(破線) `data`(点線) |
| `edges[].bidirectional` | `true` で両端に矢印 |
| `legend` | 既定 `true`。使った kind と線種だけで凡例を作る |
| `legend_labels` | 凡例の文言を上書きする(`{"device": "ロボット本体"}` など) |

- エッジの端はノードだけにする。グループには接続できない(スクリプトがエラーにする)
- ラベル内の改行は `\n` で書く。自動折り返しは無効にしてある。折り返しを有効にすると SVG が foreignObject で書き出され、rsvg や Inkscape、一部のビューアで文字が消えるためだ
- シーケンス図は対象外。D2 を使う

## 手直し

- 生成された見た目に小さな不満があるだけなら、spec の並び順(ノードやエッジの記述順)を変えて再生成するのが最も安い。Graphviz の配置は記述順の影響を受ける
- 色や形を個別に変えたいときは、`.drawio` の `style` 属性を直接編集してよい。ただし、再生成すると上書きされることをユーザーに伝える
- 仕様フォーマットで表せない要素(注記、アイコンなど)が必要なら、生成後の XML に `mxCell` を追記する。`parent` に `"1"`(ルート)か `g_<グループid>` を指定し、座標は親からの相対値で書く
