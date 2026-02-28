---
name: post-speckit
description: spec-kitの成果物をnotizenにシンボリックリンクでアーカイブ。"specアーカイブ", "specsリンク", "spec-kitをnotizen連携"等で起動。
---

# spec-kit 成果物アーカイブ

## 実行コマンド

```bash
notizen specs <repo_path>
# リポジトリ名を上書きする場合
notizen specs <repo_path> --name <name>
```

## 処理内容

1. リポジトリ名を決定 (`--name` 指定 or git remote origin から自動検出)
2. `~/notizen/source/Agents/Specs/<repo_name>/` を実ディレクトリとして作成
3. `<repo_path>/specs` → `~/notizen/source/Agents/Specs/<repo_name>/` のシンボリックリンクを作成
   - spec-kit がリポジトリの `specs/` に書き込む = notizen に直接書き込まれる
4. `notizen_dir/index.md` を生成 (未存在時のみ、glob: `*/index`)
5. `notizen_dir/NNN-name/index.md` を生成 (未存在時のみ、glob: `*`)

## 使用例

```bash
notizen specs ~/ghq/github.com/peacock0803sz/vibra
# vibra: symlink created -> /Users/peacock/ghq/.../vibra/specs

notizen specs ~/ghq/github.com/peacock0803sz/darwin-mado --name darwin-mado
# darwin-mado: symlink created -> ...

# 再実行は安全 (冪等)
notizen specs ~/ghq/github.com/peacock0803sz/vibra
# vibra: already linked
```

## 注意事項

- `specs/` が既に正しいシンボリックリンクの場合はスキップ ("already linked")
- `specs/` が異なるターゲットのシンボリックリンクの場合は更新
- `specs/` が実ディレクトリとして存在する場合はエラー終了 (既存コンテンツ保護)
- `index.md` が既に存在する場合は上書きしない
