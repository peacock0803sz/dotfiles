# slidevテンプレート

slidevはMarkdownでスライドを書き、HTML, PDF, pptxに書き出せる発表ツール。技術発表向けにgit管理とdiffレビューが効きやすい。公式は https://sli.dev 。

## 単一ファイル構成

`slides.md` という1ファイルにすべて書く。先頭にfrontmatter, 以降は`---`でスライドを区切る。

```markdown
---
theme: default
title: キャッシュ無効化はwrite側に寄せる
info: |
  ## 内容
  キャッシュ無効化の責務をwrite側に寄せると何が起きるか
class: text-base
fonts:
  sans: 'Inter, "Noto Sans JP", sans-serif'
  mono: 'JetBrains Mono'
---

# キャッシュ無効化はwrite側に寄せる

技術発表者の名前

<!--
speaker note。冒頭で名前と所属を口頭で伝える。
2-3秒で本題に入る。
-->

---

# 主題

無効化はwrite側に寄せると、read側の判定ロジックがゼロになる

<!--
この発表の到達点。最初に渡す。
ここを読み上げてから次のスライドへ。
-->

---
```

## speaker noteの記法

各スライドの本文の後ろに`<!-- ... -->`で書く。slidevはこれをspeaker noteとして専用画面に表示する。

```markdown
# 問題提起

- read側でTTLを管理すると、書き込み直後に古い値が見える
- read側の判定が複雑化する

<!--
ここでよくあるreadサイドの実装を口頭で挙げる。
TTL設定ミスで本番が壊れた例を1つ話す。
質問されたらstale-while-revalidateの話に逃げる。
-->
```

## 文字サイズの調整

slidevのデフォルトは本文がやや小さい。`class: text-base` をfrontmatterに入れるか、スライド単位で`class: 'text-xl'`を指定する。`tailwindcss`のクラス名がそのまま使える。

- `text-base` 16px
- `text-lg` 18px
- `text-xl` 20px
- `text-2xl` 24px (本文の下限の目安)
- `text-3xl` 30px (見出しの目安)

24〜28px相当の本文は`text-2xl`ベース、見出しは`text-3xl`〜`text-4xl`を使う。

## レイアウト指定

`layout:`をスライドのfrontmatterで指定するとレイアウトが切り替わる。

- `layout: default` 通常
- `layout: center` 中央寄せ。主題スライドに向く
- `layout: two-cols` 2カラム。コードと説明を並べる用途
- `layout: section` セクション扉

主題スライドは`layout: center`を推奨。

```markdown
---
layout: center
---

# 主題

無効化はwrite側に寄せる
```

## コード表示

slidevはshiki(VS Code互換)でシンタックスハイライトする。

```markdown
\`\`\`ts {2-4}
function get(key: string) {
  const cached = cache.get(key)
  if (cached && !cached.expired) return cached.value
  return fetchAndCache(key)
}
\`\`\`
```

`{2-4}`の行ハイライトで注目箇所を示す。コードを全部見せて口頭でどこを見ろと言うより、ハイライトで誘導する方が確実。

## 書き出し

`slidev build slides.md` でSPAとして書き出し。`slidev export slides.md` でPDF。Markdownのまま渡してもユーザーがビルドできる。

## 最小frontmatterテンプレート

困ったらこれをコピーする。

```yaml
---
theme: default
title: <発表タイトル>
class: text-2xl
---
```
