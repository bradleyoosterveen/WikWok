import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/repositories/article_repository.dart';

class ArticleCubit extends Cubit<Article?> {
  ArticleCubit() : super(null);

  final _articleRepository = ArticleRepository();

  Article? getArticleByIndex(int index) =>
      _articleRepository.getArticleByIndex(index);

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
