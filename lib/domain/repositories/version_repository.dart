import 'package:package_info_plus/package_info_plus.dart';
import 'package:wikwok/data/services/github_service.dart';
import 'package:wikwok/domain/models/version.dart';

class VersionRepository {
  static final VersionRepository _instance = VersionRepository._internal();

  factory VersionRepository() => _instance;

  VersionRepository._internal();

  final _githubService = GithubService();

  Future<Version> getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();

    final version = packageInfo.version;

    return Version.parse(version);
  }

  Future<Version> getLatestVersion() async {
    final data = await _githubService.fetchLatestRelease();

    final versionString = data['tag_name'] as String;

    return Version.parse(versionString.substring(1));
  }

  Future<bool> isUpdateAvailable() async {
    final currentVersion = await getCurrentVersion();
    final latestVersion = await getLatestVersion();

    return latestVersion.isNewerThan(currentVersion);
  }

  Future<String> getUpdateUrl() async {
    final data = await _githubService.fetchLatestRelease();

    return data['html_url'] as String;
  }
}
