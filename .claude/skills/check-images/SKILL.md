---
name: check-images
description: 画像ファイルのサイズや拡張子をチェックして、GitHub Actions の CI エラーを事前に防ぐときに使います。「画像確認したい」「CIエラー出そう」「画像サイズ確認」「push する前にチェック」などの意図が読み取れたら使用します。
---

`static/images/` 以下の全画像ファイルをチェックして、このリポジトリのポリシー違反を報告してください。

## チェック項目

### 1. ファイルサイズ（25MB 超は違反）
Bash ツールで確認:
```bash
find static/images -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.JPG" -o -name "*.JPEG" -o -name "*.PNG" -o -name "*.heic" -o -name "*.HEIC" \) -size +25M
```

### 2. 大文字拡張子（違反: `.JPG` `.JPEG` `.PNG` `.GIF` `.HEIC` など）
```bash
find static/images -type f | grep -E '\.(JPG|JPEG|PNG|GIF|HEIC|BMP|WEBP)$'
```

### 3. `.jpeg` 拡張子（`.jpg` のみ許可、`.jpeg` は違反）
```bash
find static/images -type f -name "*.jpeg"
```

## 結果の報告

- 違反ゼロ → 「すべての画像ファイルがポリシーに沿っています ✓」と報告
- 違反あり → ファイルパスと違反内容を一覧で報告し、修正方法を案内

## 修正方法の案内（違反があった場合）

**サイズが 25MB 超の場合（Mac）:**
1. 画像を Mac のプレビューで開く
2. 「ツール」→「サイズの調整」で幅を 1028px 程度に縮小
3. 「ファイル」→「書き出す」で保存

**大文字拡張子 / `.jpeg` の場合:**
- ファイル名を変更して小文字の `.jpg` または `.png` にする
- 記事ファイル内の画像パスも合わせて修正する