import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/repositories/article_repository.dart';

class ArticleCubit extends Cubit<Article?> {
  ArticleCubit() : super(null);

  final _articleRepository = ArticleRepository();

  Article? getArticleByIndex(int index) =>
      _articleRepository.getArticleByIndex(index);

  Future<void> prefetch(BuildContext context, int currentIndex) async {
    final newArticle = await _articleRepository.prefetch(context, currentIndex);

    emit(newArticle);
  }

  Future<void> openUrl(BuildContext context, String title) async {
    final article = _articleRepository.getArticleByTitle(title);

    if (article == null) {
      final newArticle = await _articleRepository.fetchArticleByTitle(title);

      await launchUrl(Uri.parse(newArticle.url));
    }

    if (article != null) {
      await launchUrl(Uri.parse(article.url));
    }
  }

  Future<void> copyToClipboard(BuildContext context, String title) async {
    final article = _articleRepository.getArticleByTitle(title);

    if (article != null) {
      await Clipboard.setData(ClipboardData(text: article.url));
    }
  }
}
