---
name: nix-run
description: 未インストールのコマンドを `nix run nixpkgs#<package>` で実行する。Bashで `command not found` が発生した時、または未インストールCLIツールを使う必要が出た時に発火。「nix runで実行して」「インストールしてないけど使いたい」「command not found」「ripgrepで検索して(未インストール時)」等のフレーズでも起動。ユーザーにインストール依頼せず即座に実行することを優先する。
---

# nix-run - 未インストールコマンドを nix run で実行

ユーザーにインストール手順を踏ませず、`nix run nixpkgs#<pkg>` でエフェメラルに実行するワークフロー。

前提: ユーザー環境は Nix flakes 有効、nixpkgs registry は unstable を指している。

## 発火条件

- Bash実行で `command not found` 系のエラーが返った
- これから使うコマンドが未インストールだと事前に分かっている
- ユーザーが明示的に `nix run` 経由での実行を要求した

逆に発火しない場面:
- 対象コマンドが既にPATHにある (`command -v X` で確認可能)
- macOS固有のコマンド (`launchctl`, `defaults`, `pbcopy` 等)
- nixpkgsに無いパッケージ (npm専用CLIなど)

## Step 1: パッケージ名を解決する

コマンド名がそのまま nixpkgs の attribute path になるとは限らない。
判断に迷う場合は推測せず、`nixos` MCP で確認する:

```
nix {"action":"info","query":"<コマンド名 or 推測パッケージ名>"}
```

ヒットしなければ search で類似名を探す:

```
nix {"action":"search","query":"<コマンド名>","type":"packages"}
```

頻出のミスマッチ例 (確認をスキップしてよい既知パターン):

| コマンド | パッケージ |
|---------|-----------|
| rg | ripgrep |
| convert / mogrify | imagemagick |
| ag | silver-searcher |
| nvim | neovim |
| code | vscode |
| http | httpie |
| psql | postgresql |
| aws | awscli2 |

大半のコマンドは `nixpkgs#<コマンド名>` でそのまま動く (fd, bat, eza, jq, yq, tree, hexyl, dust, gh, kubectl 等)。

## Step 2: 実行する

```bash
nix run nixpkgs#<package> -- <args...>
```

- 引数の前に `--` を入れる (nix自身のオプションと区別するため)
- 引数が無い場合は `--` 省略可
- 初回はビルド/ダウンロードで数十秒かかる可能性がある (binary cacheヒットなら即座)
- 2回目以降はストアキャッシュからほぼ即時

複数バイナリを含むパッケージで別実行ファイルを呼びたい時は:

```bash
nix run nixpkgs#<pkg>.<binary-name> -- <args>
# または
nix shell nixpkgs#<pkg> -c <binary-name> <args>
```

## Step 3: 破壊的操作のみ確認を取る

実行前に確認すべき操作:

- ファイル/ディレクトリの削除・上書き (`rm`, `mv`, `dd`, `mkfs`, ファイル書込み系オプション)
- ネットワーク経由のwrite操作 (`curl -X POST/PUT/DELETE`, `gh` のwrite系, `terraform apply`)
- 外部サービスの状態変更
- リポジトリ外への書き込み

それ以外 (検索・読取・整形出力など: `rg`, `jq`, `fd`, `bat`, `tree`, `hexyl`, `dust` 等) は即実行する。

確認時の文面例:

> `nix run nixpkgs#imagemagick -- convert input.png output.jpg` を実行します。新規ファイル `output.jpg` を作成します。よろしいですか?

## 例

### 例1: 検索系 (即実行)

ユーザー: 「このリポジトリで `foobar` を rg で探して」

`rg` が無いことを確認 -> `ripgrep` パッケージと判明 -> 即実行:

```bash
nix run nixpkgs#ripgrep -- foobar
```

### 例2: 書込系 (確認後実行)

ユーザー: 「screenshot.png を JPEGに変換して」

`convert` が無い -> `imagemagick` パッケージと判明 -> 新規ファイル作成のためユーザー確認 -> 実行:

```bash
nix run nixpkgs#imagemagick -- convert screenshot.png screenshot.jpg
```

### 例3: パッケージ名不明 (MCP確認)

ユーザー: 「dust でディスク使用量を見たい」

`dust` が無い -> パッケージ名不明のため `nix {"action":"info","query":"dust"}` で確認 -> `du-dust` (binary名は `dust`) と判明 -> 実行:

```bash
nix run nixpkgs#du-dust -- ~/Downloads
```

## やらないこと

- home-manager / nix-darwin 設定への永続インストール提案 (ユーザーが明示要求した時のみ)
- 他パッケージマネージャー (brew/npm/uv等) でのインストール提案 (ユーザー操作制限)
- `nix profile install` の使用 (ユーザー判断の領域)
- nixpkgsに無いパッケージを無理に nix run で動かす試み (素直に「nixpkgsに無い」と報告する)
