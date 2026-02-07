---
name: serena-workflow
description: Serena MCPを使った実装作業フロー。コード実装/修正タスク時に自動適用。メモリ管理とシンボルレベル操作を含む。
---

# Serena実装ワークフロー

## 実装前必須確認

1. `list_memories`でメモリ一覧取得
2. `read_memory`で関連メモリ確認
3. 記録されたパターン/規約を厳密に遵守

## メモリ命名規則

- `{project}-conventions` - プロジェクト全体の規約
- `{feature}-patterns` - 機能別実装パターン
- `{domain}-patterns` - ドメイン固有パターン
- `{layer}-conventions` - レイヤー固有の規約
- `architecture-{decision}` - アーキテクチャ決定事項
- `{service}-api-spec` - 外部サービスAPI仕様
- `{issue}-solution` - トラブルシューティング記録
- `refactoring-{target}` - リファクタリング方針

## メモリ管理原則

- 不要なメモリは`delete_memory`で削除
- 簡潔で検索しやすい名前を使用
- 更新頻度の高い情報は都度上書き

## コード操作ツール

**積極活用すべきツール**:

- `find_symbol` - シンボル検索
- `get_symbols_overview` - ファイル構造把握
- `find_referencing_symbols` - 依存関係確認
- `replace_symbol_body` - 関数/クラス全体の置換
- `insert_before_symbol` / `insert_after_symbol` - シンボル前後への挿入
- `search_for_pattern` - 横断的パターン検索

**原則**: ファイル全体読み込みより、シンボルレベル操作を優先

## 実装前確認事項

- **既存パターンの確認**: 実装前に必ず既存コード/ドキュメントを確認
- **ライブラリ最新情報**: Context7で最新仕様を確認
- **重複実装の防止**: 共通機能の独自実装前に既存コードを確認
- **メモリ確認**: `list_memories`で過去の実装パターン/決定事項を確認
