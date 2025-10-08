import 'package:wikwok/domain/models/settings.dart';
import 'package:wikwok/presentation/cubits/cubit.dart';
import 'package:wikwok/domain/repositories/settings_repository.dart';

class SettingsCubit extends WCubit<Settings> {
  SettingsCubit() : super(Settings.asDefault());

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
