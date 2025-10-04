import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wikwok/models/version.dart';
import 'package:wikwok/utils/async_cache.dart';

class VersionRepository {
  static final VersionRepository _instance = VersionRepository._internal();

  factory VersionRepository() => _instance;

  VersionRepository._internal();

  final _dio = Dio();

  final _asyncCache = AsyncCache();

  Future<Version> getCurrentVersion() async => _asyncCache.handle(
      key: 'VersionRepository.getCurrentVersion',
      action: () async {
        final packageInfo = await PackageInfo.fromPlatform();

        final version = packageInfo.version;

        return Version.parse(version);
      });

  Future<Version> getLatestVersion() async => _asyncCache.handle(
      key: 'VersionRepository.getLatestVersion',
      action: () async {
        final response = await _dio.get(
          'https://api.github.com/repos/bradleyoosterveen/wikwok/releases/latest',
        );

        final data = response.data;

        final versionString = data['tag_name'] as String;

        return Version.parse(versionString.substring(1));
      });

  Future<bool> isUpdateAvailable() async => _asyncCache.handle(
      key: 'VersionRepository.isUpdateAvailable',
      action: () async {
        final currentVersion = await getCurrentVersion();
        final latestVersion = await getLatestVersion();

        return latestVersion.isNewerThan(currentVersion);
      });

  Future<String> getUpdateUrl() async => _asyncCache.handle(
      key: 'VersionRepository.getUpdateUrl',
      action: () async {
        final response = await _dio.get(
          'https://api.github.com/repos/bradleyoosterveen/wikwok/releases/latest',
        );

        final data = response.data;

        return data['html_url'] as String;
      });
}
