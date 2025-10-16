import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/domain/repositories/article_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

class ArticleCubit extends WCubit<ArticleState> {
  ArticleCubit() : super(const ArticleLoadingState());

  final _articleRepository = ArticleRepository();

  Future<void> fetch(int currentIndex) async {
    emit(const ArticleLoadingState());

    try {
      final article = await _articleRepository.fetch(currentIndex);

      if (article == null) {
        return emit(const ArticleNotFoundState());
      }

      emit(ArticleLoadedState(article));
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);
      emit(const ArticleErrorState());
    }
  }
}

abstract class ArticleState {
  const ArticleState();
}

class ArticleLoadingState extends ArticleState {
  const ArticleLoadingState();
}

class ArticleLoadedState extends ArticleState {
  final Article article;

  const ArticleLoadedState(this.article);
}

class ArticleNotFoundState extends ArticleState {
  const ArticleNotFoundState();
}

class ArticleErrorState extends ArticleState {
  const ArticleErrorState();
}
