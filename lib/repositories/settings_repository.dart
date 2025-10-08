import 'package:shared_preferences/shared_preferences.dart';
import 'package:wikwok/models/settings.dart';

class SettingsRepository {
  static final SettingsRepository _instance = SettingsRepository._internal();

  factory SettingsRepository() => _instance;

  SettingsRepository._internal();

  final _preferences = SharedPreferencesAsync();

  final String _key = 'settings';

  Future<Settings> get() async {
    final data = await _preferences.getString(_key);

    if (data == null) return Settings.asDefault();

    return Settings.fromJson(data);
  }

  Future<void> set(Settings settings) async {
    await _preferences.setString(_key, settings.toJson());
  }

  Future<void> reset() async {
    await _preferences.remove(_key);
  }
}
