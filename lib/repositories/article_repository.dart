import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/utils/async_cache.dart';

class ArticleRepository {
  static final ArticleRepository _instance = ArticleRepository._internal();

  factory ArticleRepository() => _instance;

  ArticleRepository._internal();

  final _preferences = SharedPreferencesAsync();

  final _dio = Dio();

  final _asyncCache = AsyncCache();

  final _maxCache = 99;

  final _articles = <int, Article>{};

  final String _key = 'saved';

  Article? getArticleByIndex(int index) => _articles[index];

  Article? getArticleByTitle(String title) => _articles.values.firstWhereOrNull(
        (article) => article.title == title,
      );

  Future<Article?> fetch(BuildContext context, int currentIndex) async {
    Article? article = _articles[currentIndex];

    if (article == null) {
      article = await _fetchRandomArticle();

      if (context.mounted) {
        precacheImage(CachedNetworkImageProvider(article.image), context);
      }

      _articles[currentIndex] = article;
    }

    // ignore: use_build_context_synchronously
    unawaited(_fetchNextArticle(context, currentIndex));

    return article;
  }

  Future<void> _fetchNextArticle(BuildContext context, int currentIndex) async {
    final nextIndex = currentIndex + 1;

    if (!_articles.containsKey(nextIndex)) {
      final nextArticle = await _fetchRandomArticle();

      _articles[nextIndex] = nextArticle;

      if (context.mounted) {
        precacheImage(CachedNetworkImageProvider(nextArticle.image), context);
      }
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
    final response = await _dio
        .get('https://en.wikipedia.org/api/rest_v1/page/random/summary');

    final data = response.data;

    return Article(
      id: data['pageid'] as int,
      subtitle: data['description'] as String,
      title: data['titles']['normalized'] as String,
      content: data['extract'] as String,
      image: data['originalimage']['source'] as String,
      url: data['content_urls']['mobile']['page'] as String,
    );
  }

  Future<Article> fetchArticleByTitle(String title) async => _asyncCache.handle(
      key: title,
      action: () async {
        final response = await _dio
            .get('https://en.wikipedia.org/api/rest_v1/page/summary/$title');

        final data = response.data;

        return Article(
          id: data['pageid'] as int,
          subtitle: data['description'] as String,
          title: data['titles']['normalized'] as String,
          content: data['extract'] as String,
          image: data['originalimage']['source'] as String,
          url: data['content_urls']['mobile']['page'] as String,
        );
      });
}
