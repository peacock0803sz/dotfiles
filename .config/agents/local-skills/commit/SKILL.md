---
name: commit
description: Git commitの作成。pre-commit検査遵守、意味のある最小単位でのコミット、Emoji Prefix対応。
---

# Git Commit ワークフロー

## 基本原則

- pre-commit設定時は検査が通る状態でコミット (バイパス禁止)
- 意味のある最小単位でコミット
- メッセージが複数の意味を示す時は分割
- レビュー対応を「レビュー修正」等で1コミットに纏めない。各修正を個別の意味単位でコミットする
- コマンド実行に `git -C` は使用しないこと
- Push操作はユーザーが実行するので実施しない

## コミットメッセージ規則

- 本文は大文字で始め、変更の理由を明確にする
- 個人リポジトリ (`$HOME/ghq/github.com/peacock0803sz/` 配下) ではEmoji Prefixを採用
    - ただしdotfiles, notizenリポジトリはEmoji Prefixを採用していない

### Emoji Prefix一覧

| Emoji | 用途 |
|-------|------|
| :tada: | 最初のコミット/新機能(大) |
| :sparkles: | 新機能(小) |
| :bug: | バグフィックス |
| :recycle: | リファクタリング |
| :books: / :bulb: | ドキュメント |
| :art: | フォーマット改善 |
| :zap: | アップデート |
| :fire: | コード/ファイル削除 |
| :white_check_mark: | テストコード追加 |
| :green_heart: | CI/CD関連修正 |
| :arrow_up: / :arrow_down: | 依存関係変更 |
| :wrench: | 設定ファイル関連 |
| :snowflake: | Nix関連 |
| :ambulance: | ホットフィックス |
| :construction: | WIP |

詳細は `$HOME/dotfiles/.config/git/commit-template` を参照。
