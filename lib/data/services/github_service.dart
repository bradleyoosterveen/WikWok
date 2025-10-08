import 'package:dio/dio.dart';
import 'package:wikwok/shared/utils/async_cache.dart';

class GithubService {
  static final GithubService _instance = GithubService._internal();

  factory GithubService() => _instance;

  GithubService._internal();

  final _dio = Dio();

  final _asyncCache = AsyncCache();

  final _baseUrl = 'https://api.github.com';

  Future<Map<String, dynamic>> fetchLatestRelease() async => _asyncCache.handle(
      key: 'GithubService.fetchLatestRelease',
      action: () async {
        final response = await _dio.get(
          '$_baseUrl/repos/bradleyoosterveen/wikwok/releases/latest',
        );

        return response.data as Map<String, dynamic>;
      });
}
