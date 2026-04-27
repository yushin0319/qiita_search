# qiita_search

Qiita API で記事を検索する Flutter アプリ。GitHub description: 「Qiita漁るやつ(Flutter)」。

## スタック

- Flutter（Dart SDK ^3.7.2）
- HTTP: `http` ^1.6.0
- 環境変数: `flutter_dotenv` ^6.0.1
- WebView: `webview_flutter` ^4.13.1
- ローカライゼーション: `intl` ^0.20.2
- UI: Material Design

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
android/ / ios/ / linux/ / web/   プラットフォーム固有コード
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
flutter test
flutter build apk      # Android APK
flutter build ios      # iOS
flutter build web
```
