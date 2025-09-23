# Cloudflare Pages バッチビルドの実行手順

## 概要

このリポジトリには Cloudflare Pages のビルドを手動・定期実行するための GitHub Actions ワークフロー（`.github/workflows/cloudflare-pages-build.yml`）を追加しました。Cloudflare API を用いて Pages のデプロイをトリガーする仕組みになっているため、リポジトリから直接バッチ処理としてビルドを走らせることができます。

## 事前準備

1. Cloudflare Pages で対象プロジェクトが作成済みであること。
2. 以下の権限を持つ API トークンを Cloudflare で発行します。
   - `Account > Cloudflare Pages > Edit`
   - 必要に応じて他の権限（カスタムドメイン利用時など）も追加してください。
3. Cloudflare ダッシュボードから以下の情報を控えます。
   - アカウント ID（例: `023e105f4ecef8c1a6a5a34363a8c3c2`）
   - Pages プロジェクト名

## GitHub Secrets / Variables の設定

GitHub リポジトリの **Settings > Secrets and variables > Actions** で以下を設定してください。

### リポジトリ Secrets

| 名前 | 内容 |
| ---- | ---- |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare アカウント ID |
| `CLOUDFLARE_PROJECT_NAME` | Cloudflare Pages のプロジェクト名 |
| `CLOUDFLARE_API_TOKEN` | 上記手順で発行した API トークン |

### リポジトリ Variables（任意）

| 名前 | 内容 |
| ---- | ---- |
| `CLOUDFLARE_DEFAULT_BRANCH` | ビルドの対象とする既定ブランチ。未設定の場合は `main` が利用されます。 |
| `CLOUDFLARE_SCHEDULE_ENABLED` | 定期実行を有効化する場合に `true` を設定します。未設定またはその他の値の場合、スケジュールトリガーはスキップされます。 |

## ワークフローの動き

- Secrets が揃っているかを最初に検証します。
- Cloudflare Pages のデプロイ API に対して `deployment_trigger: manual` を送信し、指定ブランチのビルドを開始します。
- API レスポンスはログに JSON 形式で出力され、`deployment_id` と `deployment_url` がステップの出力として保存されます。
- エラーが発生した場合は GitHub Actions のジョブが失敗し、Cloudflare から返却されたメッセージがログに表示されます。

## 手動実行（オンデマンド実行）

1. GitHub 上部メニューから **Actions** を開きます。
2. 「Cloudflare Pages バッチビルド」ワークフローを選択し、`Run workflow` ボタンを押します。
3. `target_branch` にビルドしたいブランチ名を入力します（未入力の場合は上記の既定ブランチを利用）。
4. `Run workflow` を実行すると、Cloudflare Pages でビルドが開始され、数十秒後にデプロイ URL が表示されます。

## スケジュール実行を有効化する

- ワークフローには `schedule`（毎日 15:00 UTC = 日本時間では翌日 0:00）で起動するトリガーが設定されています。
- 実際にジョブを動かすには、前述のリポジトリ Variable `CLOUDFLARE_SCHEDULE_ENABLED` に `true` を設定してください。
- スケジュール実行のブランチは `CLOUDFLARE_DEFAULT_BRANCH`（未設定なら `main`）が利用されます。

スケジュールを変更したい場合は `.github/workflows/cloudflare-pages-build.yml` 内の `cron` 設定を編集してください。

## トラブルシューティング

- `::error::` で Secrets が不足していると表示された場合は、各 Secrets が正しく登録されているか確認してください。
- Cloudflare API から `Authentication error` が返る場合は、API トークンの権限と有効期限を確認してください。
- レスポンス内の `errors` フィールドに詳細が記載されるため、GitHub Actions のログで JSON 出力を確認すると原因を特定しやすくなります。
