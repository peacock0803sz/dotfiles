# コードベースから図を起こす

目的は、コードに実在する構造を図に写すことだ。ファイルを網羅的に読む必要はない。図の種類ごとに構造が現れる場所は決まっているので、そこから当たる。

## まず全体像を掴む

1. ルートの README、`docs/`、既存の図(`*.drawio`, `*.d2`, `*.puml`, mermaid ブロック)を探す。既存の図があれば、それを出発点にして差分を取る
2. ビルド定義で言語とモジュール境界を掴む: `go.mod`, `package.json`(workspaces), `pyproject.toml`, `Cargo.toml`(workspace), `pom.xml`, `CMakeLists.txt`, `flake.nix`
3. エントリポイントを列挙する: `cmd/*/main.go`, `src/main.*`, `bin/`, `__main__.py`, `Dockerfile` の `CMD`/`ENTRYPOINT`, `Procfile`

## 図の種類ごとの情報源

### コンテナ図 / デプロイ図

実行単位と、それらの間の配線を探す。

| 情報源 | 読み取れるもの |
|---|---|
| `docker-compose*.yml` | サービス一覧、依存(`depends_on`)、ポート、ボリューム、ネットワーク |
| k8s マニフェスト、Helm chart、Kustomize | Deployment/StatefulSet/CronJob、Service、Ingress、ConfigMap にある接続先 |
| Terraform / Pulumi / CDK / CloudFormation | クラウドリソース、VPC/サブネット、IAM、マネージドサービス |
| `.env.example`、設定ファイル、ConfigMap | `*_URL`、`*_HOST`、`*_ENDPOINT`、`BROKER`、`DSN` は、そのまま接続先の一覧になる |
| CI/CD(`.github/workflows` 等) | デプロイ先、ビルド成果物、環境の種類 |
| systemd unit、supervisord、Yocto/Buildroot のレシピ | 組込みや単体ホストで常駐するプロセス |

### コンポーネント図(1つのコンテナの内部)

- ディレクトリ構成をレイヤやモジュールの候補とみなし、import 関係で裏付ける
- import グラフを機械的に取ると確実だ: `go list -deps -f '{{.ImportPath}} {{.Imports}}' ./...`、Python なら `pydeps` や `grep -rn '^from \|^import '`、TS なら `madge`(nix run で使えないものは grep で代用)
- DI コンテナの登録、ルーター定義、プラグイン登録は、コンポーネントの配線がまとまって見える場所だ

### シーケンス図

1. 起点を決める: HTTP ハンドラ(ルーター定義から辿る)、CLI サブコマンド、キューのコンシューマ、割り込みハンドラやイベントループなど
2. 起点の関数から呼び出しを追い、プロセス境界を越える呼び出しだけを拾う。HTTP/gRPC クライアント、DB クエリ、キューへの publish、ファイル、デバイスI/O がそれにあたる。プロセス内の関数呼び出しは、ユーザーが求めない限り描かない
3. エラー時の分岐、リトライ、タイムアウトは、図に載せる価値があるかを判断する

### データフロー図

- スキーマ定義(マイグレーション、ORM モデル、protobuf、Avro、JSON Schema)でデータの形を掴む
- producer/consumer(topic 名、キュー名、バケット名)を grep し、どこで生成され、どこで読まれるかを突き合わせる
- バッチ(cron, Airflow DAG, dbt モデル)の入出力テーブルを拾う

## 確度の扱い

コードから確かめられたことと、推測したことを分けて扱う。

- モデル表(SKILL.md の手順3)に、根拠(`deploy/k8s/api.yaml:12` など)の列を付ける
- 設定値が環境ごとに違い、接続先がコードだけで決まらないなら、そう注記する
- コードに現れない要素(外部の SaaS、人手の運用など)は、ユーザーに確認するか、図の上で「想定」と明示する
- 読んだ範囲(例: `services/` 配下のみ、`legacy/` は未調査)を報告に含める
