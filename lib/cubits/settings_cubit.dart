import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wikwok/models/settings.dart';
import 'package:wikwok/repositories/settings_repository.dart';

class SettingsCubit extends Cubit<Settings> {
  SettingsCubit() : super(Settings.withDefaultValues());

  final _settingsRepository = SettingsRepository();

  Future get() async {
    final settings = await _settingsRepository.get();

    emit(settings);
  }

  Future change(Settings settings) async {
    await _settingsRepository.set(settings);

    emit(settings);
  }
}
