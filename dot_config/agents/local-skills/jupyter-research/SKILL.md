---
name: jupyter-research
description: >-
  SAENMモデル (Sequential Append-Only Experiment Notebook Model) に基づくJupyter実験ノートの
  作成・管理・振り返りワークフロー。「SAENM」「実験ノート」「実験記録」「ノートブック管理」
  「研究ノート」等のキーワードで起動。新規実験の開始、既存実験の継続、実験系列の振り返りを支援する。
---

# SAENM Jupyter実験ワークフロー

[SAENMモデル (Sequential Append-Only Experiment Notebook Model)](https://lab.cmscom.jp/blog/2026/03/24/saenm-model-intro/) に基づく実験ノート管理スキル。
参考: [CMScomLab/saenm-notebook-template](https://github.com/CMScomLab/saenm-notebook-template)

## SAENMの3原則

- Sequential: 実験に単純な連番 (`01`, `02`, `03`...) を付与する。枝番は使わず、微細な更新でも次の番号を割り当てる。親子関係は README.md で管理し、どの検討の続きかを常に追跡可能にする
- Append-Only: 過去のノートを改変・削除しない。修正は新ノートか Corrections セクションへの追記で行う。README.md が履歴の一貫性を担保する
- Experiment Notebook: コード・結果に加え、目的・考察・環境情報・AI利用記録・次の方針を含む包括的な実験記録

## 適用条件の確認

スキルトリガー後、最初に以下を確認する。

1. 作業ディレクトリの確認 (新規 or 既存プロジェクト)
2. `notebooks/` ディレクトリの有無
3. `notebooks/README.md` の有無
4. Git管理の有無 (`.git/` の存在で判定)

確認結果に応じて後述のワークフローから適切なパスを選択する。

## 最小構成

SAENMの核は `notebooks/` と README.md だけで、Git がなくても完全に機能する。

```
project-root/
├── notebooks/
│   ├── README.md            # 実験索引 (必須・追記専用)
│   ├── 01_initial_exploration.ipynb
│   ├── 02_improved_method.ipynb
│   └── 03_parameter_tuning.ipynb
└── data/                   # (推奨) 入力データ
    └── raw/
```

以下は必要に応じて追加する。

- `src/` - 再利用コードモジュール
- `results/` - 出力結果
- `docs/` - 運用ルール
- `tests/` - テストコード
- `pyproject.toml` - Pythonプロジェクト設定

## README.md (実験索引)

Append-Onlyを構造的に担保する中核ファイル。テーブル形式とMermaid図で管理する。
テーブル構造・Mermaid記法・運用ルールの詳細は `references/readme-spec.md` を参照。

## ノート命名規則

形式: `{ID}_{snake_case_title}.ipynb`

- タイトルはsnake_caseとするが、複合語がある場合はkebab-caseを部分的に利用してもよい
- 常に単純連番 (`01`, `02`, `03`...)。枝番 (`02a` 等) は使わない
- 微細な更新・パラメータ変更でも次の番号を割り当てる。試行の粒度は小さくてよい
- ID採番規則
    - 基本的には `notebooks/` 内の既存最大番号+1
    - 実験のフェーズが大きく変わる場合は十の位を増やす
- 親子関係はIDの連続性ではなく README.md の「親」列で管理する

例:

```
01_data_collection.ipynb           # 親: なし
02_feature_extraction.ipynb        # 親: 01
03_model_training.ipynb            # 親: 02
04_hyperparameter_search.ipynb     # 親: 03 パラメータ変更だけでも新番号
05_alternative_model.ipynb         # 親: 03 同じ親から別方向の試行
06_scikit-learn_baseline.ipynb     # 親: 04 複合語 (scikit-learn) のみ kebab-case
07_evaluation.ipynb                # 親: 06
# ---- ここまで研究フェーズ / ここから本番データ適用フェーズ ----
10_production_dataset_prep.ipynb   # 親: 07 フェーズ切替のため 08, 09 を飛ばして 10 から開始
11_production_inference.ipynb      # 親: 10
12_monitoring_setup.ipynb          # 親: 11
```

## ノート内部構造テンプレート

ノート作成時は `references/notebook-template.md` のテンプレートに従う。
メタデータ・目的・手法・実行・結果・考察・AI利用記録・次のステップ・Corrections の各セクションを含める。

## 運用原則 (Append-Onlyルール)

### Do

- 新しい試行は新しいノートとして追加する
- 失敗した実験もそのまま残す。判断の変遷自体が知見になる
- README.md に新しい行を追記する
- 過去ノートの誤りは Corrections セクションに追記で記録する

### Don't

- 過去のノートのコード・結果を書き換えない
- 失敗したノートを削除しない
- README.md の既存行を削除しない

## ワークフロー (エージェント実行手順)

### ノート内容の確認方法

既存ノートの内容や出力を確認する際は、以下の順で利用する。

1. Read ツールで `.ipynb` を直接読み取る。セルの内容と出力が整形済みで得られるため、JSON パースは不要
2. 特定セルの出力だけ確認したい場合や構造的に把握したい場合は `nbdime nbshow {ノートパス}` を使う

`python -m json.tool` 等による JSON 整形は使わない。

### 新規プロジェクト開始

1. 作業ディレクトリを確認する
2. `notebooks/` ディレクトリを作成する
3. `notebooks/README.md` を空のテーブルヘッダーとMermaid図で作成する
4. ユーザーに最初の実験の目的をヒアリングする
5. `01_{タイトル}.ipynb` をテンプレートに基づいて作成する
6. README.md に最初の行とMermaidノードを追記する
7. Git管理時はコミットを提案する

### 新規実験追加

1. `notebooks/` 内の既存 `.ipynb` ファイルを走査する
2. README.md を読み取り、現在の系列関係を把握する
3. 親実験を特定する (ユーザーに確認)
4. 次のIDを決定: 既存最大番号+1。常に単純連番
    1. もし桁が増える場合は、先に既存ファイルの桁数を合わせること
5. 新しいノートをテンプレートで作成する。メタデータに親IDを記入
6. README.md に行とMermaidエッジを追記する

### 既存ノート修正の要求への応答

既存ノートの内容は原則として改変しない。要求の種類に応じて対応を分ける。

- typo/Markdown整形: 実験内容に影響しないため許容する
- 結果の訂正・コード修正: 既存ノートの Corrections セクションに追記するか、新しいノートとして作成することを提案する
- やり直しの要望: 次の連番で新しいノートとして作成を提案する

### 実験系列の振り返り

1. README.md を読み取り、系列関係を把握する
2. 各ノートの目的・考察・次のステップを読み取る
3. 時系列で実験の流れを要約する
   - 仮説の変遷
   - 判断の分岐点と理由
   - 各実験から得られた学び
4. 未着手の次のステップをリストアップする
5. 次に取り組むべき方向性を提案する

## Git連携 (オプション)

`.git/` が存在する場合のみ適用。初期化手順・運用ルールは `references/git-integration.md` を参照。
