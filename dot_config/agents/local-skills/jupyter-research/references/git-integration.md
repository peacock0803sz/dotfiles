# Git連携

`.git/` が存在する場合のみ適用する。

## プロジェクト初期化

- Nix環境: `nix flake init -t github:peacock0803sz/templa#notebook` でセットアップする
    - flake.nix に git-hooks.nix 経由で ruff-check / ruff-format / ty が pre-commit に設定済み
    - devShell に uv が含まれる
    - `uv sync` で JupyterLab 等の依存関係をインストールする
- 非Nix環境: 手動で pre-commit を設定する
    - `uv add --dev ruff pre-commit` でインストールする
    - `.pre-commit-config.yaml` に ruff check (`ruff check --fix`) を設定する
    - `pre-commit install` で有効化する

## Git運用ルール

- ノート追加ごとにコミットを推奨する
- コミットメッセージは `/commit` スキルに従う。プレフィックスは `{ID}: ` (例: `03: Add hyperparameter search`)
- .ipynb の差分が見づらい場合は nbstripout や jupytext の導入を検討する
- `data/raw/` は .gitignore に追加し、データ取得手順をドキュメント化する

## Git非管理時

- README.md の連番とメタデータが履歴を担保する
- 定期的なディレクトリバックアップを推奨する
