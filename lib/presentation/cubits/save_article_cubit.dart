import 'package:wikwok/domain/repositories/article_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

class SaveArticleCubit extends WCubit<bool?> {
  SaveArticleCubit() : super(null);

  final _articleRepository = ArticleRepository();

  Future<void> get(String title) async => emit(
        await _articleRepository.isArticleSaved(title),
      );

  Future<void> save(String title) async => emit(
        await _articleRepository.saveArticle(title),
      );

  Future<void> unsave(String title) async => emit(
        await _articleRepository.unsaveArticle(title),
      );

  Future<bool> toggle(String title) async {
    final saved = await _articleRepository.isArticleSaved(title);

    if (saved) {
      await _articleRepository.unsaveArticle(title);
    } else {
      await _articleRepository.saveArticle(title);
    }

    emit(!saved);

    return !saved;
  }
}
