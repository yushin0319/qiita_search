# qiita_search

Qiita API で記事を検索する Flutter アプリ。GitHub description: 「Qiita漁るやつ(Flutter)」。

## スタック

- Flutter 3.41.x（Dart SDK ^3.7.2）
- HTTP: `http` ^1.6.0
- 環境変数: `flutter_dotenv` ^6.0.1（`.env` を assets に同梱）
- WebView: `webview_flutter` ^4.14.1
- 日時フォーマット: `intl` ^0.20.3（`DateFormat`）
- UI: Material Design
- Lint: `flutter_lints` ^6.0.0（`analysis_options.yaml`）

## 構成

```
lib/
  main.dart                       エントリ + テーマ
  screens/
    search_screen.dart            キーワード検索
    article_screen.dart           記事詳細（WebView）
  models/
    article.dart                  Article（タイトル / 著者 / いいね数 / タグ等）
    user.dart                     User
  widgets/
    article_container.dart        記事カード
test/
  models/ / widgets/              flutter test（Article / User / ArticleContainer）
android/ ios/ linux/ macos/       プラットフォーム固有コード
web/ windows/
```

## 機能

- キーワードで Qiita API を検索
- 検索結果リスト（タイトル / 著者 / いいね数 / タグ / 投稿日時）
- 記事タップで Qiita ページを WebView で表示

## セットアップ

```
.env:
QIITA_ACCESS_TOKEN=<your_token>   # 任意（未認証でも検索は可能）
```

## 開発

```bash
flutter pub get
flutter run            # 実行（Android / iOS / Web 等を選択）
flutter analyze        # CI と同じ
flutter test
flutter build apk      # Android APK
flutter build ios      # iOS
flutter build web
```
