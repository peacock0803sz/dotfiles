# 計画ファイルアーカイブ

## 概要

計画モード完了後、計画ファイルを notizen/Agents に日付階層でアーカイブする。

## 実行コマンド

```bash
python3 ~/dotfiles/.config/agents/scripts/plan-timestamp.py --archive
```

## 処理内容

1. ~/.claude/plans/ 内の全 .md ファイルを検出
2. ~/Documents/notizen/source/Agents/YYYY/MM/DD/ に移動
   - ファイル名: HHMMSS_元のファイル名.md
   - H1 見出しの先頭に時刻 (HH:MM:SS) を追加
3. 各階層に index.md を生成/更新 (MyST toctree 形式)
4. 元ファイルを削除

## アーカイブ後のファイル参照

スクリプト出力で新しいパスを確認し、以降はそのパスを使用。

例:
```
Archived: plan.md -> /Users/peacock/Documents/notizen/source/Agents/2025/01/22/143052_plan.md
```

## 注意事項

- 既に時刻が付与されているファイルはスキップ
- 計画ファイル以外は処理されない
