import 'package:wikwok/cubits/cubit.dart';
import 'package:wikwok/models/version.dart';
import 'package:wikwok/repositories/version_repository.dart';

class UpdateCubit extends WCubit<UpdateState?> {
  UpdateCubit() : super(null);

  final _versionRepository = VersionRepository();

  Future get() async {
    final updateAvailable = await _versionRepository.isUpdateAvailable();

    if (!updateAvailable) return emit(const UpdateUnavailableState());

    final url = await _versionRepository.getUpdateUrl();
    final version = await _versionRepository.getLatestVersion();

    emit(UpdateAvailableState(url, version));
  }
}

abstract class UpdateState {
  const UpdateState();
}

class UpdateAvailableState extends UpdateState {
  final String url;
  final Version version;

  const UpdateAvailableState(
    this.url,
    this.version,
  );
}

class UpdateUnavailableState extends UpdateState {
  const UpdateUnavailableState();
}
