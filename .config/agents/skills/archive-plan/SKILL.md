---
name: archive-plan
description: 計画ファイルを notizen/Agents にアーカイブ。日付階層で整理し index.md を生成。
---

# 計画ファイルアーカイブ

計画モード終了後、以下のコマンドを実行して計画ファイルをアーカイブしてください:

```bash
python3 ~/.config/nix/home-manager/programs/claude-code/hooks/plan-timestamp.py --archive
```

## 処理内容

このスクリプトは以下を実行します:

1. `~/.claude/plans/` 内の全 `.md` ファイルを検出
2. 各ファイルを `~/Documents/notizen/source/Agents/YYYY/MM/DD/` に移動
   - ファイル名: `HHMMSS_元のファイル名.md`
   - H1 見出しの先頭に時刻 (HH:MM:SS) を追加
3. 各階層に index.md を生成/更新 (MyST toctree 形式)
4. 元ファイルを削除

## 重要: アーカイブ後のファイル参照

スクリプト実行後、出力に表示される**新しいパス**を確認してください。

例:
```
Archived: plan.md -> /Users/peacock/Documents/notizen/source/Agents/2025/01/22/143052_plan.md
```

以降、計画ファイルを参照する必要がある場合は、この**新しいパス**を使用してください。
元の `.claude/plans/` 内のファイルは削除されています。

## 注意事項

- 既に時刻が付与されているファイルはスキップされます
- 計画ファイル以外は処理されません
