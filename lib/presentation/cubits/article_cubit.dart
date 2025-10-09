import 'package:wikwok/domain/models/article.dart';
import 'package:wikwok/domain/repositories/article_repository.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';

class ArticleCubit extends WCubit<Article?> {
  ArticleCubit() : super(null);

  final _articleRepository = ArticleRepository();

  Future<void> fetch(int currentIndex) async {
    final newArticle = await _articleRepository.fetch(currentIndex);

    emit(newArticle);
  }
}
