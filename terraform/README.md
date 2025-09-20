# Cloudflare Workers による定期ビルド自動化 Terraform 構成

このディレクトリには、Cloudflare Workers を用いて1時間ごとにビルド用Webhookを呼び出すための Terraform 構成が含まれています。Worker は Cron Triggers を利用して毎時0分に起動され、指定したWebhookへ `POST` リクエストを送信します。Webhookからのレスポンスはログとして返却されるため、Cloudflare Workers ダッシュボードや Wrangler CLI から実行結果を確認できます。

## 前提条件

- Terraform 1.3.0 以上
- Cloudflare アカウントおよび Workers を利用できる有効なサブスクリプション
- Workers のデプロイと Cron Triggers を設定できる権限を持つ API トークン
- ビルドを実行するためのWebhook URL（例えばCIサービスのビルド用Webhook）

## ファイル構成

- `main.tf`: Cloudflare プロバイダー、Worker スクリプト、Cron Trigger の定義を行います。
- `variables.tf`: Worker 名や資格情報など、Terraform が利用する変数を宣言します。
- `credentials.tf.example`: 実際の資格情報を設定するためのサンプル値です。このファイルを `credentials.tf` にコピーして利用します（`credentials.tf` は Git で無視されます）。

## 変数の設定

Terraform 実行前に、以下の手順で資格情報を設定してください。

1. `terraform/credentials.tf.example` を `terraform/credentials.tf` にコピーします。
2. コピーした `credentials.tf` の各値を実環境の情報に置き換えます。

`credentials.tf` は `.gitignore` に含まれており、誤ってリポジトリへコミットされることはありません。Terraform Cloud などのマネージド環境を利用する場合は、このファイルを作成せずに `terraform.tfvars` や `TF_VAR_` 環境変数で同じ変数名を指定しても構いません。

設定が必要な値は次のとおりです。

```hcl
cloudflare_account_id = "cf-account-id"
cloudflare_api_token  = "cf-api-token"
# 任意: Worker 名を変更したい場合
# worker_name = "custom-worker-name"
# 任意: ビルド用WebhookのURLを設定
# build_webhook_url = "https://example.com/build"
```

`build_webhook_url` を設定すると、Worker が毎時このURLに `POST` リクエストを送信します。Terraform の状態ファイルにWebhook URLを平文で保持したくない場合は、`credentials.tf` を使用せずに Terraform Cloud/Enterprise の変数管理や `TF_VAR_build_webhook_url` として環境変数を利用してください。

## デプロイ手順

1. Terraform の初期化:
   ```bash
   terraform init
   ```
2. 適用前の差分確認:
   ```bash
   terraform plan -var-file=credentials.tf
   ```
3. リソースの作成:
   ```bash
   terraform apply -var-file=credentials.tf
   ```

適用後、Cloudflare ダッシュボードの Workers セクションに Worker が追加され、Cron Trigger が 1 時間ごとに実行されます。手動で動作確認したい場合は、Worker の「テスト」から `fetch` ハンドラーを実行すると同じ処理を確認できます。

## スケジュールの変更

`cloudflare_worker_cron_trigger.hourly` リソースの `schedules` を変更することで、実行タイミングを自由に調整できます。Cron 式は [Cloudflare Workers Cron Triggers の仕様](https://developers.cloudflare.com/workers/platform/triggers/cron-triggers/) に従います。

## クリーンアップ

作成したリソースを削除するには、以下を実行してください。

```bash
terraform destroy
```

これにより、Worker スクリプトと Cron Trigger が Cloudflare から削除されます。
