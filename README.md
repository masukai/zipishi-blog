# ぢぴ氏の育児奮闘記

## ブログ更新方法

### プロフィールページを作る

初期設定は以下(内容は書いていくこと)

```bash
hugo new about.md
```

### プライバシーポリシー・免責事項ページ

初期設定は以下(内容は適宜アップデートすること)

```bash
hugo new privacy.md
```

### 問い合わせページの作成

初期設定は以下(内容は適宜アップデートすること)

```bash
hugo new contact.md
```

### 投稿の追加

毎回mdファイルのタイトルを考えて、作成していくこと

```bash
hugo new posts/first-post.md
```

## 構成図

## 初期設定

Macで以下を設定

```bash
brew install hugo
hugo new site blog
cd blog
git init
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
touch config.toml
rm hugo.toml
```

```bash
hugo server -D
```
