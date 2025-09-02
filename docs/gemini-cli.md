# Gemini CLI による GitHub Actions の設定と PR レビュー

**Gemini より引用**

##  Gemini CLI GitHub Actionsを利用する
Googleが公式に提供しているGemini CLI GitHub Actionsを利用するのが最も手軽で強力な方法です。これは、リポジトリにセットアップするだけで、自動でPRレビューやIssueのトリアージを行ってくれるものです。

**特徴**
無料利用枠あり: Gemini APIには、1日あたり1,500リクエストまでの無料利用枠があります。個人のプロジェクトでPRレビューに利用する程度であれば、この無料枠に十分収まる可能性が高いです。

- PRレビューの自動化: 新しいPRが作成されると、Geminiが自動的にコードをレビューし、フィードバックや改善案をコメントしてくれます。
- オンデマンドのレビュー: `@gemini-cli /review` のようなコメントで、必要なときにレビューを依頼することもできます。

## セットアップ手順

1. Gemini APIキーの取得:
[Google AI Studio](https://aistudio.google.com/apikey)にアクセスして、APIキーを取得します。

2. GitHubリポジトリにAPIキーを登録:

GitHubのリポジトリの`Settings > Secrets and variables > Actions`に移動します。

New repository secretをクリックし、名前を**GEMINI_API_KEY**、値に取得したAPIキーを設定します。

3.  GitHub Actionsのワークフローを作成:
リポジトリのルートに .github/workflowsディレクトリを作成し、pr-review.ymlのような名前でファイルを作成します。

- [実際のworkflows](../.github/workflows/pr-review.yml)
- [参考にした公式ページ](https://github.com/google-gemini/gemini-cli-action/blob/main/examples/gemini-pr-review.yml)
