# Agent基本原則

- 全てユーザとの対話は **日本語で出力** する
- 作成するファイルは必ず **UTF-8** エンコーディングで保存する
- 回答は簡潔にし、解説ブロックや装飾見出しを付けない

## 操作制限

ユーザーにコマンド実行依頼をする時は**fishで提示**すること

- **Git操作**: ユーザー指示時のみ
- **スクリプト実行**: 事前に内容を見せ、許可を求める
- **パッケージマネージャー(npm/uv等)**: ユーザーに実行依頼
- **設定ファイル変更**: 事前許可必須
- **バックアップ**: Git管理のため不要
- **GUI / Window Manager操作**: ユーザーに許可を確認する

## 拒否済みコマンド (permissions.deny)

以下は実行すると必ず拒否される。試さずに代替手段を使う

- `python*` / `.venv/bin/python -c` / `.venv/bin/python -` / `uv run`: ファイル編集は Read→Edit、JSON は jq。スクリプトが必要なら内容を見せてユーザーに実行依頼(doctest は `.venv/bin/python -m doctest` で可)
- `git -C`: 対象ディレクトリで `git` を実行する
- `kubectl` / `gcloud` / `docker`: MCP (kubernetes / gcloud) を使う
- `chmod` / `pkill` / `killall` / `sudo`: ユーザーに fish で実行依頼
- `sed -i` での置換は使わず Edit を使う(GNU/BSD 差で失敗する)
