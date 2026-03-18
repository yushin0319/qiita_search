import 'package:flutter_test/flutter_test.dart';
import 'package:qiita_search/models/user.dart';

void main() {
  group('User.fromJson', () {
    test('有効なJSONからUserを生成できる', () {
      final json = {
        'id': 'test_user',
        'profile_image_url': 'https://example.com/avatar.png',
      };

      final user = User.fromJson(json);

      expect(user.id, 'test_user');
      expect(user.profileImageUrl, 'https://example.com/avatar.png');
    });

    test('空文字のフィールドでもUserを生成できる', () {
      final json = {
        'id': '',
        'profile_image_url': '',
      };

      final user = User.fromJson(json);

      expect(user.id, '');
      expect(user.profileImageUrl, '');
    });

    test('日本語IDを含むJSONからUserを生成できる', () {
      final json = {
        'id': 'ユーザー名',
        'profile_image_url': 'https://example.com/日本語.png',
      };

      final user = User.fromJson(json);

      expect(user.id, 'ユーザー名');
    });
  });
}
