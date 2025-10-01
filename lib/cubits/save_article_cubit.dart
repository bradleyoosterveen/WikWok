import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/repositories/article_repository.dart';

class SaveArticleCubit extends Cubit<bool?> {
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
}
