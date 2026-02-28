# Qiita Search

Qiita API v2 を使った記事検索 Flutter アプリ

## 技術スタック

| カテゴリ | 技術 |
|---------|------|
| 言語 | Dart |
| フレームワーク | Flutter |
| 環境変数 | flutter_dotenv |
| HTTP通信 | http |
| 記事表示 | webview_flutter |

## 主な機能

- キーワードによる Qiita 記事検索
- WebView での記事表示

## 対応プラットフォーム

Android / iOS / Web / macOS / Linux / Windows

## セットアップ

1. `.env` ファイルをプロジェクトルートに作成し、Qiita のアクセストークンを設定する

```
QIITA_ACCESS_TOKEN=your_token_here
```

2. アプリを起動する

```bash
flutter run
```
