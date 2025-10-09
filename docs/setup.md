# 初期設定

Macで以下を設定
(GitHubでのベースの設定が完了している前提)。

```bash
brew install hugo
hugo new site zipishi-blog
cd zipishi-blog
git submodule add https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod
touch config.toml
rm hugo.toml
```

```bash
hugo server -D
```

うまく表示されない場合、PaperModの初期化ができていないかもしれません。
以下のコマンドで解消します!

```bash
git submodule update --init --recursive
```
