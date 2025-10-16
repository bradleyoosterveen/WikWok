import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/core/http_client.dart';
import 'package:wikwok/shared/utils/async_cache.dart';

class WikipediaService {
  static final WikipediaService _instance = WikipediaService._internal();

  factory WikipediaService() => _instance;

  WikipediaService._internal();

  final _httpClient =
      WHttpClient().getClient(baseUrl: 'https://en.wikipedia.org/api/rest_v1/');

  final _asyncCache = AsyncCache();

  Future<Map<String, dynamic>> fetchRandomArticle() async {
    try {
      final response = await _httpClient.get('page/random/summary');

      return response.data as Map<String, dynamic>;
    } on Exception catch (e) {
      WExceptionHandler().handleException(e);

      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchArticleByTitle(String title) async =>
      _asyncCache.handle(
          key: title,
          action: () async {
            try {
              final response = await _httpClient.get('page/summary/$title');

              return response.data as Map<String, dynamic>;
            } on Exception catch (e) {
              WExceptionHandler().handleException(e);

              rethrow;
            }
          });
}
