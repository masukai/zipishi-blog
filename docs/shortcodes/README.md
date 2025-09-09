# SNS投稿の埋め込み

Hugo の標準ショートコードを利用すると、記事に X（旧 Twitter）や Instagram の投稿を簡単に埋め込めます。ここでは基本的な使い方と、必要な設定について説明します。

## X の投稿を埋め込む

投稿 ID を指定して `tweet` ショートコードを使います。

```markdown
{{< tweet 1234567890123456789 >}}
```

ユーザー名と ID を明示する書き方も可能です。

```markdown
{{< tweet user="TwitterDev" id="1234567890123456789" >}}
```

ID は投稿 URL `https://x.com/TwitterDev/status/1234567890123456789` の末尾にある数字部分です。追加の設定は不要です。

## Instagram の投稿を埋め込む

投稿 ID（URL の `/p/` 以降の文字列）を指定して `instagram` ショートコードを使います。

```markdown
{{< instagram B7VI0ICpSDz >}}
```

キャプションを非表示にしたい場合は `hidecaption` オプションを付けます。

```markdown
{{< instagram B7VI0ICpSDz hidecaption >}}
```

### アクセストークンの設定

2020 年 10 月以降、Instagram の oEmbed API を利用するには Facebook のアクセストークンが必要です。Hugo でショートコードを使う場合も、ビルド時に `HUGO_INSTAGRAM_ACCESS_TOKEN` 環境変数に有効なトークンを設定してください。

1. Facebook 開発者アカウントでアプリを登録し、Graph API から長期トークンを取得します。
2. ビルドやサーバー起動の前に環境変数を設定します。

```bash
export HUGO_INSTAGRAM_ACCESS_TOKEN="YOUR_TOKEN"
```

トークンを用意できない場合は、Instagram から取得した `<blockquote>` と `<script>` を記事に直接貼り付けて対応してください。

## ローカルでの確認

短コードを使用した記事は通常どおり `hugo server -D` でプレビュー、`hugo` でビルドできます。Instagram の埋め込みを含む場合は上記の環境変数が必要です。

```bash
hugo server -D
hugo
```

