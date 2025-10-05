import 'package:dio/dio.dart';
import 'package:wikwok/utils/async_cache.dart';

class WikipediaService {
  static final WikipediaService _instance = WikipediaService._internal();

  factory WikipediaService() => _instance;

  WikipediaService._internal();

  final _dio = Dio();

  final _asyncCache = AsyncCache();

  final _baseUrl = 'https://en.wikipedia.org/api/rest_v1';

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    final response = await _dio.get('$_baseUrl/page/random/summary');

    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> fetchArticleByTitle(String title) async =>
      _asyncCache.handle(
          key: title,
          action: () async {
            final response = await _dio.get('$_baseUrl/page/summary/$title');

            return response.data as Map<String, dynamic>;
          });
}
