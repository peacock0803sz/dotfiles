---
name: github-pr
description: GitHub Pull Request 作成ワークフロー
---

# GitHub Pull Request 作成ワークフロー

* このブランチの変更をPull Requestとして送信する
    * タイトルは簡潔な1つの英文とし、コミットメッセージと同じようにPrefixを付与する
    * Body (description) は以下のフォーマットで日本語の内容を記述する

```markdown
## What

- 変更内容の詳細
- 技術的な解説(など)

## Why

- 変更の背景
- 実装の意図 (など)
```

* **title, description案ができたら表示し、ユーザーに確認をすること**
    * 実行コマンド: `gh pr create --title $TITLE --body $BODY`
* **ブランチがPushされていない場合はユーザーにPushするよう促し、自身でPushしないこと**
