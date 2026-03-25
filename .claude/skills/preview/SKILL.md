---
name: preview
description: Hugo のローカルプレビューサーバーを起動して、ブログの見え方を確認するときに使います。「プレビューしたい」「確認したい」「ローカルで見たい」「見え方確認したい」「書きながら確認したい」などの意図が読み取れたら使用します。
---

Hugo のローカルプレビューサーバーを起動してください。

## 手順

1. プロジェクトルート（`c:/Users/admin/Desktop/zipishi-blog`）で以下のコマンドをバックグラウンドで実行する:

```bash
hugo server -D -F
```

2. 起動後にユーザーへ以下を案内する:
   - **アクセス先**: http://localhost:1313
   - 記事を編集・保存するとブラウザが自動でリロードされる（ライブリロード）
   - `-D` オプションにより `draft: true` の記事も表示される
   - `-F` オプションにより未来の公開日の記事も表示される

3. **終了方法**: ターミナルで `Ctrl+C` を押す

## エラーが出た場合

- `port already in use` → すでにサーバーが起動している。既存のターミナルで `Ctrl+C` を押してから再実行
- `hugo: command not found` → Hugo がインストールされていない。`brew install hugo` でインストール
- サブモジュールエラー → `git submodule update --init --recursive` を実行してからリトライ