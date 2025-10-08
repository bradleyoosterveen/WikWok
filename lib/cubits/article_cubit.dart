import 'package:flutter/services.dart';
import 'package:wikwok/cubits/cubit.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/repositories/article_repository.dart';

class ArticleCubit extends WCubit<Article?> {
  ArticleCubit() : super(null);

  final _articleRepository = ArticleRepository();

  Future<void> fetch(int currentIndex) async {
    final newArticle = await _articleRepository.fetch(currentIndex);

    emit(newArticle);
  }

  Future<void> copyToClipboard(String title) async {
    final article = _articleRepository.getArticleByTitle(title);

    if (article != null) {
      await Clipboard.setData(ClipboardData(text: article.url));
    }
  }
}
