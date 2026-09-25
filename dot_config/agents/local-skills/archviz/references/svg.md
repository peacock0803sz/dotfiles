# SVG 手書き

要素が少なく配置に意図がある図(レイヤ図、スタック図、概念図、ハードウェアのブロック図など)は、自動レイアウトに任せるより座標を自分で決めた方が早く、きれいに仕上がる。目安は、ノード 12 個以下で、エッジが単純な図だ。

## 進め方

1. 紙の上で配置を決める要領で、グリッド(10px 単位)上に各要素の x, y, w, h を先に表にする。座標を決めてから SVG を書く
2. 下のテンプレートに当てはめる
3. rsvg-convert でレンダリングして確認し、座標表を直して再生成する

## テンプレート

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 480" width="800" height="480" font-family="'Hiragino Sans','Noto Sans CJK JP','Helvetica Neue',Arial,sans-serif">
  <title>ロボット制御ソフトウェアのレイヤ構成</title>
  <defs>
    <marker id="arrow" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0,0 L10,5 L0,10 z" fill="#444"/>
    </marker>
    <marker id="arrow-open" viewBox="0 0 10 10" refX="10" refY="5" markerWidth="8" markerHeight="8" orient="auto-start-reverse">
      <path d="M0,0 L10,5 L0,10" fill="none" stroke="#444" stroke-width="1.5"/>
    </marker>
    <style>
      .node   { stroke-width: 1.5; rx: 6; }
      .svc    { fill: #dae8fc; stroke: #6c8ebf; }
      .store  { fill: #d5e8d4; stroke: #82b366; }
      .ext    { fill: #f5f5f5; stroke: #666; stroke-dasharray: 5 3; }
      .group  { fill: none; stroke: #666; stroke-dasharray: 6 4; rx: 10; }
      .label  { font-size: 14px; fill: #111; text-anchor: middle; dominant-baseline: central; }
      .sub    { font-size: 11px; fill: #555; text-anchor: middle; dominant-baseline: central; }
      .glabel { font-size: 13px; font-weight: bold; fill: #333; }
      .edge   { stroke: #444; stroke-width: 1.5; fill: none; marker-end: url(#arrow); }
      .async  { stroke-dasharray: 6 4; marker-end: url(#arrow-open); }
      .elabel { font-size: 11px; fill: #333; text-anchor: middle; }
      .title  { font-size: 20px; font-weight: bold; fill: #111; }
    </style>
  </defs>
  <rect width="100%" height="100%" fill="#fff"/>
  <text class="title" x="20" y="36">ロボット制御ソフトウェアのレイヤ構成</text>

  <g id="board">
    <rect class="group" x="20" y="60" width="760" height="400"/>
    <text class="glabel" x="36" y="84">SoC (Linux)</text>
  </g>

  <g id="app">
    <rect class="node svc" x="60" y="110" width="200" height="60"/>
    <text class="label" x="160" y="132">行動制御</text>
    <text class="sub" x="160" y="152">(Python)</text>
  </g>

  <path class="edge" d="M260,140 H380"/>
  <text class="elabel" x="320" y="132">gRPC</text>
</svg>
```

## 注意点

- ルートに `viewBox` と `width`/`height` を必ず付ける。白の背景 `rect` も入れる。背景が透過だと、ダークモードの画面に貼ったとき黒い文字が読めなくなる
- 文字は `<text>` で書く。`foreignObject` は使わない(rsvg、Inkscape、PowerPoint などで表示されない)
- 文字幅は自動では測れないので、見積もって箱の幅を決める。日本語は 1文字 ≈ font-size、英数字は 1文字 ≈ 0.6 × font-size。左右に 16px ずつ余白を足す。例えば 14px で「認証サーバー」(6文字)なら、84 + 32 = 116px 以上にする
- 複数行は `<text>` を分けるか、`<tspan x="…" dy="1.3em">` で重ねる
- エッジは、箱の辺の中点から出して、辺の中点に入れる。直交の線は `H`/`V` コマンドで描くと座標の計算が楽だ
- 矢印の先端がノードの枠に食い込まないよう、終点を枠の座標ちょうどにする(marker の `refX=10` で先端が終点に合う)
- 要素ごとに `<g id="…">` でまとめ、意味のある id を付ける。後から Inkscape などで編集しやすくなる
- CSS の `rx` を rect に効かせるのは SVG2 の機能で、rsvg は対応しているが古いビューアでは効かない。確実に角を丸めたいなら属性 `rx="6"` を使う
