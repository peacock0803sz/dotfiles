# slidev以外の形式の作法

ユーザーがslidev以外を指定した場合の取り扱い。本体のデザイン規律(色数, 文字サイズ, 1枚1メッセージ, 実在ページへのリンク)はすべて共通で適用する。形式ごとに違うのは、書き方の構文と納品の手順だけ。

## marp

marpはMarkdownで書きslidev同様にHTML, PDF, pptxに書き出せる。slidevより枯れていて、CLIだけで完結する。

### 単一ファイル構成

`slides.md` に書く。先頭にfrontmatter, スライド区切りは`---`。speaker noteは`<!-- ... -->`または`<!-- _backgroundColor: ... -->`の形でディレクティブも兼ねる。

```markdown
---
marp: true
theme: default
paginate: true
size: 16:9
style: |
  section { font-size: 28px; }
  h1 { font-size: 40px; }
---

# キャッシュ無効化はwrite側に寄せる

技術発表者の名前

<!--
冒頭で名前と所属を口頭で伝える。
-->

---

# 主題

無効化はwrite側に寄せると、read側の判定ロジックがゼロになる

<!--
この発表の到達点。
-->

---
```

### 書き出し

`marp slides.md -o slides.html` でHTML。`marp slides.md --pdf` でPDF。

## pptx (PowerPoint, Keynote含む)

Markdown形式で構造を先に書き、ユーザーがpptxへ転記する流れにする。スキルが.pptxバイナリを直接生成するのは現実的でない(レイアウト崩れが頻発する)。

### Markdown中間形式

```markdown
## Slide 1 タイトル

タイトル: キャッシュ無効化はwrite側に寄せる
サブタイトル: 技術発表者の名前
レイアウト: タイトルスライド

speaker note:
冒頭で名前と所属を口頭で伝える。

---

## Slide 2 主題

見出し: 主題
本文: 無効化はwrite側に寄せると、read側の判定ロジックがゼロになる
レイアウト: タイトルとコンテンツ(中央寄せ)

speaker note:
この発表の到達点。最初に渡す。

---
```

### 転記時の注意

- スライドマスターを1つ作り、全スライドに適用する。これで整列が崩れない。
- テンプレートのフォントサイズ初期値を本文28pt、見出し36ptに変更する。
- 色は黒と強調色1色だけ使う。テンプレート付属のカラフルなアクセントは消す。

## Google Slides

pptxとほぼ同じ扱い。Markdown中間形式を作り、ユーザーがGoogle Slidesへ転記する。

Google Slidesへのインポートは pptx 経由が確実。`.md` から直接インポートする一般的な手段は無いため、`marp slides.md --pptx` で pptx を生成しユーザーが Google Slides にアップロードする流れも案内できる。

### Google Slides固有の注意

- フォントは「Noto Sans JP」「Roboto」を選ぶ。標準フォントは和文の見た目が崩れることがある。
- 共有設定をユーザーに確認してから渡す。「リンクを知っている全員が閲覧」など公開範囲を間違えると意図せず外部公開される。

## 形式によらない共通の納品物

どの形式でも、合意した以下をスキルが生成する。

- フェーズ1のabstract(CFP応募の場合)
- フェーズ2のdescription, motivation(CFP応募の場合)、もしくはアウトラインメモ
- フェーズ3のスライド本体(slidev/marpはMarkdown、pptx/Google SlidesはMarkdown中間形式)
- speaker noteを含むスライドファイル

ファイル名はユーザーに確認する。指定がなければ `slides.md` をデフォルトとする。
