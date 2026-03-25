---
name: publish
description: 記事を本番公開するためのフローを案内します。「公開したい」「プルリク作りたい」「mainに上げたい」「記事を出したい」「デプロイしたい」などの意図が読み取れたら使用します。
---

記事を本番公開するための事前チェックとプルリクエスト作成フローを実行してください。

## ステップ1: 事前チェック

### 下書き記事の確認
`content/posts/` 内で `draft: true` のファイルがないかチェック:
```bash
grep -rl "draft: true" content/posts/
```
→ 意図せず下書きのままになっている記事がないか確認する。

### 画像チェック
`static/images/` の画像ファイルを確認:
- ファイルサイズ 25MB 超がないか
- 大文字拡張子（.JPG .PNG 等）がないか
- `.jpeg` 拡張子がないか

### ブランチ確認
```bash
git branch --show-current
```
→ `develop` ブランチにいることを確認。`main` や他のブランチにいる場合は警告する。

### 未コミットの変更確認
```bash
git status
```
→ コミットし忘れのファイルがないか確認する。

## ステップ2: 問題がなければ PR 作成を提案

すべてのチェックが通ったら、以下のコマンドで PR を作成するか提案する:

```bash
gh pr create --base main --head develop
```

PR のタイトルと本文はユーザーに確認してから実行する（または自動で `gh pr create` の対話モードに任せる）。

## ステップ3: PR 作成後の案内

PR を作成したら以下を伝える:

1. **Gemini CLI による自動レビュー**が約1〜2分で実行される
2. **CI チェック**が自動で走る:
   - `image-guard.yml`: 画像サイズ検証
   - `extension-check.yml`: 拡張子の小文字確認
3. レビューと CI が通ったら **main へマージ**する
4. マージすると **Cloudflare Pages に自動デプロイ**され、数分後に https://zipishi.com に反映される
5. 追加レビューが欲しい場合は PR コメントに `@gemini-cli /review` と書くと再レビューしてくれる
