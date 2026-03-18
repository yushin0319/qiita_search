import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/models/user.dart';
import 'package:qiita_search/widgets/article_container.dart';

// NetworkImageのHTTPリクエストをテスト環境で無効化
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

Article _createArticle({
  String title = 'テスト記事タイトル',
  String userId = 'test_user',
  String profileImageUrl = 'https://example.com/avatar.png',
  int likesCount = 10,
  List<String> tags = const ['Flutter', 'Dart'],
  DateTime? createdAt,
  String url = 'https://qiita.com/test',
}) {
  return Article(
    title: title,
    user: User(id: userId, profileImageUrl: profileImageUrl),
    likesCount: likesCount,
    tags: tags,
    createdAt: createdAt ?? DateTime(2026, 3, 15),
    url: url,
  );
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  tearDownAll(() {
    HttpOverrides.global = null;
  });

  group('ArticleContainer', () {
    testWidgets('記事タイトルが表示される', (tester) async {
      final article = _createArticle(title: 'Flutterの基礎');

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );

      expect(find.text('Flutterの基礎'), findsOneWidget);
    });

    testWidgets('投稿日がyyyy/MM/dd形式で表示される', (tester) async {
      final date = DateTime(2026, 3, 15);
      final article = _createArticle(createdAt: date);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );

      expect(find.text(DateFormat('yyyy/MM/dd').format(date)), findsOneWidget);
    });

    testWidgets('タグがハッシュタグ形式で表示される', (tester) async {
      final article = _createArticle(tags: ['Flutter', 'Dart', 'Firebase']);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );

      expect(find.text('#Flutter #Dart #Firebase'), findsOneWidget);
    });

    testWidgets('いいね数が表示される', (tester) async {
      final article = _createArticle(likesCount: 99);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );

      expect(find.text('99'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('投稿者名が表示される', (tester) async {
      final article = _createArticle(userId: 'qiita_lover');

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );

      expect(find.text('qiita_lover'), findsOneWidget);
    });

    testWidgets('GestureDetectorが配置されている（タップ可能）', (tester) async {
      final article = _createArticle();

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );

      // タップ可能なGestureDetectorが存在することを確認
      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
