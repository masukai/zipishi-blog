# CLAUDE.md

このファイルは、このリポジトリで作業する際の Claude Code (claude.ai/code) へのガイダンスを提供します。

## プロジェクト概要

Hugo 静的サイトブログ「ぢぴ氏の育児奮闘記」。PaperMod テーマを使用し、Cloudflare Pages にデプロイ。コンテンツはすべて日本語。

## よく使うコマンド

```bash
# 下書き・未来記事も含めてローカルプレビュー
hugo server -D -F

# 本番ビルド
hugo

# 初期セットアップ（テーマサブモジュール）
git submodule update --init --recursive
```

package.json や Node.js ツールは存在しない — 純粋な Hugo プロジェクト。

## ブランチ運用

- 作業は `develop` ブランチのみ
- `main` への直接 push は禁止
- `develop` → `main` の PR を作成することで Cloudflare Pages へのデプロイが発動
- Gemini CLI が PR を日本語で自動レビュー。追加レビューは `@gemini-cli /review` で依頼可能

## コンテンツ構成

**新規記事**: `content/posts/YYMMDD-PostTitle.md`

**必須 Front Matter**:
```yaml
---
title: "タイトル"
cover:
  image: "/images/posts/YYMMDD-PostTitle/eyecatch.png"
  alt: "説明文"
  caption: ""
  relative: false
  hiddenInSingle: true
date: 2025-08-10T21:30:00+09:00
lastmod: 2025-08-10T21:30:00+09:00
tags: ["育児", "0歳"]
categories: ["日記"]
Author: "ぢぴ氏"
draft: false
---
```

**画像**: `static/images/posts/{PostName}/` 以下に配置 — 1 ファイル 25MB 未満、拡張子は必ず小文字（`.jpg` / `.png`。`.JPG` や `.jpeg` は不可）。

## カスタムショートコード

- `{{< age birth="2024-09-03" >}}` — ビルド時点の年齢を「X歳Yヶ月」形式で表示
- `{{< tweet 1234567890123456789 >}}` — X/Twitter 埋め込み
- `{{< instagram B7VI0ICpSDz >}}` — Instagram 埋め込み（`HUGO_INSTAGRAM_ACCESS_TOKEN` 環境変数が必要）

## アーキテクチャ

- **テーマ**: `themes/PaperMod/` に git サブモジュールとして配置された PaperMod
- **テーマのオーバーライド**: `layouts/`（テンプレート）と `assets/css/extended/`（CSS）
- **カラースキーム**: `assets/css/extended/custom.css` でピンク/レッド系テーマを定義
- **CI/CD**: `.github/workflows/` の GitHub Actions — 画像サイズ検証（`image-guard.yml`）、拡張子の小文字強制（`extension-check.yml`）、main マージ時の自動デプロイ

## カスタムスキル

以下のスキルが `.claude/skills/` に用意されている。ユーザーの発言から意図を読み取って積極的に提案・使用すること。

| スキル | 使いどき | トリガーワード例 |
|---|---|---|
| `/new-post` | 新規記事を作りたいとき | 「ブログ書きたい」「記事作りたい」「投稿したい」 |
| `/write-guide` | 書き方がわからないとき | 「どう書けばいい」「マークダウンどうやるの」 |
| `/preview` | ローカルで見え方を確認したいとき | 「プレビューしたい」「確認したい」「ローカルで見たい」 |
| `/check-images` | 画像の問題を事前チェックしたいとき | 「画像確認したい」「CIエラー出そう」 |
| `/publish` | 記事を公開・PR を作りたいとき | 「公開したい」「プルリク作りたい」「mainに上げたい」 |

## 重要な制約

1. `public/`（ビルド生成物）はコミットしない
2. 画像ファイル: 25MB 未満、小文字拡張子（`.jpg` / `.png` のみ。`.jpeg` や `.JPG` は不可）
3. `layouts/` や `config.toml` の変更は PaperMod を壊す可能性があるため、`hugo server -D` で必ず確認
4. コンテンツとドキュメントはすべて日本語
