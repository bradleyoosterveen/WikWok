import 'package:wikwok/core/exception_handler.dart';
import 'package:wikwok/core/http_client.dart';
import 'package:wikwok/shared/utils/async_cache.dart';

class GithubService {
  static final GithubService _instance = GithubService._internal();

  factory GithubService() => _instance;

  GithubService._internal();

  final _httpClient =
      WHttpClient().getClient(baseUrl: 'https://api.github.com/');

  final _asyncCache = AsyncCache();

  Future<Map<String, dynamic>> fetchLatestRelease() async => _asyncCache.handle(
      key: 'GithubService.fetchLatestRelease',
      action: () async {
        try {
          final response = await _httpClient.get(
            'repos/bradleyoosterveen/wikwok/releases/latest',
          );

          return response.data as Map<String, dynamic>;
        } on Exception catch (e) {
          WExceptionHandler().handleException(e);

          rethrow;
        }
      });
}
