# 新規参加者向けガイド

## プロジェクト構造の概要
- このブログは Hugo を用いた静的サイトで、テーマに PaperMod を採用しています。
- 主要ディレクトリ:
  - `archetypes/`: 新規コンテンツ作成時のデフォルト Front Matter
  - `content/`: 記事やページ本体。投稿は `content/posts/` 配下に追加します
  - `layouts/`: テンプレートと部分テンプレート。`layouts/_default/single.html` などで記事ページの構造を上書き
  - `layouts/shortcodes/`: カスタムショートコード（例: 誕生日から月齢を計算する `age`）
  - `assets/css/extended/`: テーマカスタマイズ用の CSS
  - `static/`: 公開用の画像・ファビコンなどの静的ファイル

## 重要事項
- **ブランチ運用**: 変更は `develop` ブランチで行い、PR を通して `main` に反映します
- **記事作成**:
  - `content/posts` に既存記事をコピーし、Front Matter（タイトル・日付・タグなど）を編集
    - 画像は `static/` 以下に配置します（例: `/static/images/posts/your-post-name/image.jpg`）。
      25MB 以下かつ拡張子は小文字で統一
    - 詳細な手順は [ブログ更新方法](./blog-posting.md) を参照してください
- **独自機能**: `age` ショートコードで誕生日からの月齢を自動表示できます

## 次に学ぶと良いこと
1. **ローカル環境のセットアップ**: `brew install hugo` → `hugo server -D` でローカルプレビューを行い、
   手元で確認しながら執筆・開発できるようにします。
2. **Hugo テンプレートと PaperMod テーマ**: `layouts/` や `assets/` を参照してテーマ拡張を学習し、
   デザインや構造を自由にカスタマイズする力を養います。
3. **CI/PR ワークフロー**: GitHub Actions と Gemini CLI による PR レビューの流れを把握し、
   自動チェックに沿った効率的なレビューを受けられるようにします。
