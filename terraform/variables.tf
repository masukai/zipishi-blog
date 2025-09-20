# Terraformで使用する変数を定義します。公開しても問題のない設定値と、資格情報を含む値をまとめて宣言しています。
# 実際の値は `credentials.tf` や `TF_VAR_` 環境変数などから与えてください。

variable "cloudflare_account_id" {
  type        = string
  description = "CloudflareのアカウントID。"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Workersをデプロイできる権限を持つCloudflareのAPIトークン。"
  sensitive   = true
}

variable "build_webhook_url" {
  type        = string
  description = "ビルド処理を起動するWebhookのURL。"
  sensitive   = true
  nullable    = false
}

variable "worker_name" {
  type        = string
  description = "作成するWorkerスクリプトの名前。"
  default     = "hourly-build-worker"
}
