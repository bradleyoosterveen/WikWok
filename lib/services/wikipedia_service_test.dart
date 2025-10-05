// ignore_for_file: depend_on_referenced_packages
import 'package:flutter_test/flutter_test.dart';
import 'package:wikwok/services/wikipedia_service.dart';

void main() {
  final service = WikipediaService();

  group('WikipediaService', () {
    test('fetchRandomArticle()', () async {
      final article = await service.fetchRandomArticle();

      expect(article.containsKey('pageid'), true);
    });
    test('fetchArticleByTitle()', () async {
      final article = await service.fetchArticleByTitle('Flutter');

      expect(article.containsKey('pageid'), true);
    });
  });
}
