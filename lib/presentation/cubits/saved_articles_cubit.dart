import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/domain/repositories/article_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

class SavedArticlesCubit extends WCubit<SavedArticlesState> {
  SavedArticlesCubit() : super(const SavedArticlesLoadingState());

  final _articleRepository = ArticleRepository();

  Future<void> get() async {
    emit(const SavedArticlesLoadingState());

    try {
      final saved = await _articleRepository.getSavedArticles();

      final articles = saved
          .map((title) => _articleRepository.getArticleByTitle(title))
          .toList();

      for (var i = 0; i < articles.length; i++) {
        if (articles[i] == null) {
          articles[i] = await _articleRepository.fetchArticleByTitle(saved[i]);
        }
      }

      final filteredArticles = articles.whereType<Article>().toList();

      if (filteredArticles.isEmpty) {
        return emit(const SavedArticlesEmptyState());
      }

      emit(SavedArticlesLoadedState(filteredArticles));
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);
      emit(const SavedArticlesErrorState());
    }
  }
}

abstract class SavedArticlesState {
  const SavedArticlesState();
}

class SavedArticlesLoadingState extends SavedArticlesState {
  const SavedArticlesLoadingState();
}

class SavedArticlesLoadedState extends SavedArticlesState {
  final List<Article> articles;

  const SavedArticlesLoadedState(this.articles);
}

class SavedArticlesEmptyState extends SavedArticlesState {
  const SavedArticlesEmptyState();
}

class SavedArticlesErrorState extends SavedArticlesState {
  const SavedArticlesErrorState();
}
