import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/models/article.dart';
import 'package:wikwok/repositories/article_repository.dart';

class SavedArticlesCubit extends Cubit<List<Article>?> {
  SavedArticlesCubit() : super(null);

  final _articleRepository = ArticleRepository();

  Future<void> get() async {
    final saved = await _articleRepository.getSavedArticles();

    final articles = saved
        .map((title) => _articleRepository.getArticleByTitle(title))
        .toList();

    for (var i = 0; i < articles.length; i++) {
      if (articles[i] == null) {
        articles[i] = await _articleRepository.fetchArticleByTitle(saved[i]);
      }
    }

    emit(articles.whereType<Article>().toList());
  }

  Future<void> unsave(String title) async {
    await _articleRepository.unsaveArticle(title);

    await get();
  }

  Future<void> unsaveAll() async {
    final saved = await _articleRepository.getSavedArticles();

    for (var title in saved) {
      await _articleRepository.unsaveArticle(title);
    }

    await get();
  }
}
