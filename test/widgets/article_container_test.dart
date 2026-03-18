import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/models/user.dart';
import 'package:qiita_search/widgets/article_container.dart';

// 1x1 透明PNG（NetworkImageのHTTPリクエストを即座に完了させる）
final _kTransparentPng = Uint8List.fromList([
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x62, 0x00, 0x00, 0x00, 0x02,
  0x00, 0x01, 0xE2, 0x21, 0xBC, 0x33, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45,
  0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

// NetworkImageのHTTPリクエストに1x1 PNGを即座に返すモックHttpClient
class _FakeHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _kTransparentPng.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.value(_kTransparentPng).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _FakeHttpClient();
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
    HttpOverrides.global = _FakeHttpOverrides();
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
      await tester.pumpAndSettle();

      expect(find.text('Flutterの基礎'), findsOneWidget);
    });

    testWidgets('投稿日がyyyy/MM/dd形式で表示される', (tester) async {
      final date = DateTime(2026, 3, 15);
      final article = _createArticle(createdAt: date);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );
      await tester.pumpAndSettle();

      expect(find.text(DateFormat('yyyy/MM/dd').format(date)), findsOneWidget);
    });

    testWidgets('タグがハッシュタグ形式で表示される', (tester) async {
      final article = _createArticle(tags: ['Flutter', 'Dart', 'Firebase']);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );
      await tester.pumpAndSettle();

      expect(find.text('#Flutter #Dart #Firebase'), findsOneWidget);
    });

    testWidgets('いいね数が表示される', (tester) async {
      final article = _createArticle(likesCount: 99);

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );
      await tester.pumpAndSettle();

      expect(find.text('99'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('投稿者名が表示される', (tester) async {
      final article = _createArticle(userId: 'qiita_lover');

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );
      await tester.pumpAndSettle();

      expect(find.text('qiita_lover'), findsOneWidget);
    });

    testWidgets('GestureDetectorが配置されている（タップ可能）', (tester) async {
      final article = _createArticle();

      await tester.pumpWidget(
        MaterialApp(home: Scaffold(body: ArticleContainer(article: article))),
      );
      await tester.pumpAndSettle();

      expect(find.byType(GestureDetector), findsOneWidget);
    });
  });
}
