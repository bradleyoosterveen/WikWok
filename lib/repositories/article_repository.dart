import 'dart:async';

import 'package:collection/collection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/services/wikipedia_service.dart';

class ArticleRepository {
  static final ArticleRepository _instance = ArticleRepository._internal();

  factory ArticleRepository() => _instance;

  ArticleRepository._internal();

  final _preferences = SharedPreferencesAsync();

  final _wikipediaService = WikipediaService();

  final _maxCache = 99;

  final _articles = <int, Article>{};

  final String _key = 'saved';

  Article? getArticleByIndex(int index) => _articles[index];

  Article? getArticleByTitle(String title) => _articles.values.firstWhereOrNull(
        (article) => article.title == title,
      );

  Future<Article?> fetch(int currentIndex) async {
    Article? article = _articles[currentIndex];

    if (article == null) {
      article = await _fetchRandomArticle();

      _articles[currentIndex] = article;
    }

    unawaited(_fetchNextArticle(currentIndex));

    return article;
  }

  Future<void> _fetchNextArticle(int currentIndex) async {
    final nextIndex = currentIndex + 1;

    if (!_articles.containsKey(nextIndex)) {
      final nextArticle = await _fetchRandomArticle();

      _articles[nextIndex] = nextArticle;
    }

    if (_articles.length > _maxCache) {
      _articles.remove(_articles.keys.first);
    }
  }

  Future<bool> isArticleSaved(String title) async {
    final saved = await getSavedArticles();

    return saved.contains(title);
  }

  Future<bool> saveArticle(String title) async {
    if (await isArticleSaved(title)) {
      return true;
    }

    final saved = await getSavedArticles();

    saved.add(title);

    await _preferences.setStringList(
        _key, saved.map((e) => e.toString()).toList());

    return true;
  }

  Future<bool> unsaveArticle(String title) async {
    if (!await isArticleSaved(title)) {
      return false;
    }

    final saved = await getSavedArticles();

    saved.remove(title);

    await _preferences.setStringList(
        _key, saved.map((e) => e.toString()).toList());

    return false;
  }

  Future<List<String>> getSavedArticles() async {
    final saved = await _preferences.getStringList(_key);

    if (saved == null) {
      await _preferences.setStringList(_key, []);

      return [];
    }

    return saved;
  }

  Future<Article> _fetchRandomArticle() async {
    final data = await _wikipediaService.fetchRandomArticle();

    return Article.fromJson(data);
  }

  Future<Article> fetchArticleByTitle(String title) async {
    final data = await _wikipediaService.fetchArticleByTitle(title);

    return Article.fromJson(data);
  }
}
