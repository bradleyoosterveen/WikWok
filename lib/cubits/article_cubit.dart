import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleCubit extends Cubit<Article?> {
  ArticleCubit() : super(null);

  final _dio = Dio();

  final _maxCache = 99;

  final _articles = <int, Article>{};

  Article? getArticle(int index) => _articles[index];

  Future<void> prefetch(BuildContext context, int currentIndex) async {
    late final Article article;

    if (_articles.containsKey(currentIndex)) {
      article = _articles[currentIndex]!;
    } else {
      article = await _fetchArticle(currentIndex);

      if (context.mounted) {
        precacheImage(NetworkImage(article.image), context);
      }

      _articles[currentIndex] = article;
    }

    final nextIndex = currentIndex + 1;

    if (!_articles.containsKey(nextIndex)) {
      final nextArticle = await _fetchArticle(nextIndex);

      _articles[nextIndex] = nextArticle;

      if (context.mounted) {
        precacheImage(NetworkImage(nextArticle.image), context);
      }
    }

    if (_articles.length > _maxCache) {
      _articles.remove(_articles.keys.first);
    }

    emit(getArticle(currentIndex));
  }

  Future<void> openUrl(BuildContext context, int index) async {
    final article = getArticle(index);

    if (article != null) {
      await launchUrl(Uri.parse(article.url));
    }
  }

  Future<void> copyToClipboard(BuildContext context, int index) async {
    final article = getArticle(index);

    if (article != null) {
      await Clipboard.setData(ClipboardData(text: article.url));
    }
  }

  Future<Article> _fetchArticle(int index) async {
    final response = await _dio
        .get('https://en.wikipedia.org/api/rest_v1/page/random/summary');

    final data = response.data;

    return Article(
      subtitle: data['description'] as String,
      title: data['titles']['normalized'] as String,
      content: data['extract'] as String,
      image: data['originalimage']['source'] as String,
      url: data['content_urls']['mobile']['page'] as String,
    );
  }
}

class Article {
  final String subtitle;
  final String title;
  final String content;
  final String image;
  final String url;

  Article({
    required this.subtitle,
    required this.title,
    required this.content,
    required this.image,
    required this.url,
  });
}
