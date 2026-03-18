import 'package:flutter_test/flutter_test.dart';
import 'package:qiita_search/models/article.dart';
import 'package:qiita_search/models/user.dart';

void main() {
  group('Article.fromJson', () {
    test('有効なJSONからArticleを生成できる', () {
      final json = {
        'title': 'FlutterでQiita検索アプリを作る',
        'user': {
          'id': 'test_user',
          'profile_image_url': 'https://example.com/avatar.png',
        },
        'likes_count': 42,
        'tags': [
          {'name': 'Flutter'},
          {'name': 'Dart'},
        ],
        'created_at': '2026-01-15T10:30:00+09:00',
        'url': 'https://qiita.com/test_user/items/abc123',
      };

      final article = Article.fromJson(json);

      expect(article.title, 'FlutterでQiita検索アプリを作る');
      expect(article.user.id, 'test_user');
      expect(article.likesCount, 42);
      expect(article.tags, ['Flutter', 'Dart']);
      expect(article.createdAt, DateTime.parse('2026-01-15T10:30:00+09:00'));
      expect(article.url, 'https://qiita.com/test_user/items/abc123');
    });

    test('タグが空のJSONからArticleを生成できる', () {
      final json = {
        'title': 'タグなし記事',
        'user': {
          'id': 'author',
          'profile_image_url': 'https://example.com/img.png',
        },
        'likes_count': 0,
        'tags': <Map<String, String>>[],
        'created_at': '2026-03-01T00:00:00+09:00',
        'url': 'https://qiita.com/author/items/xyz',
      };

      final article = Article.fromJson(json);

      expect(article.tags, isEmpty);
      expect(article.likesCount, 0);
    });

    test('タグが多数あるJSONを正しくパースできる', () {
      final json = {
        'title': 'テスト記事',
        'user': {
          'id': 'user1',
          'profile_image_url': 'https://example.com/img.png',
        },
        'likes_count': 100,
        'tags': [
          {'name': 'Flutter'},
          {'name': 'Dart'},
          {'name': 'Firebase'},
          {'name': 'Android'},
          {'name': 'iOS'},
        ],
        'created_at': '2025-12-25T09:00:00+09:00',
        'url': 'https://qiita.com/user1/items/def',
      };

      final article = Article.fromJson(json);

      expect(article.tags.length, 5);
      expect(article.tags, ['Flutter', 'Dart', 'Firebase', 'Android', 'iOS']);
    });

    test('UTC日時をパースできる', () {
      final json = {
        'title': 'UTC記事',
        'user': {
          'id': 'user2',
          'profile_image_url': 'https://example.com/img.png',
        },
        'likes_count': 5,
        'tags': [
          {'name': 'Test'},
        ],
        'created_at': '2026-06-15T12:00:00Z',
        'url': 'https://qiita.com/user2/items/ghi',
      };

      final article = Article.fromJson(json);

      expect(article.createdAt.isUtc, isTrue);
      expect(article.createdAt.month, 6);
      expect(article.createdAt.day, 15);
    });
  });

  group('Article コンストラクタ', () {
    test('デフォルト値が正しく設定される', () {
      final article = Article(
        title: 'テスト',
        user: User(id: 'u', profileImageUrl: 'https://example.com/img.png'),
        createdAt: DateTime(2026, 1, 1),
        url: 'https://qiita.com/test',
      );

      expect(article.likesCount, 0);
      expect(article.tags, isEmpty);
    });
  });
}
