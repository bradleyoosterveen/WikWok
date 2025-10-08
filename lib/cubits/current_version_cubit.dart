import 'package:wikwok/cubits/cubit.dart';
import 'package:wikwok/repositories/version_repository.dart';

class CurrentVersionCubit extends WCubit<String?> {
  CurrentVersionCubit() : super(null);

  final _versionRepository = VersionRepository();

  Future get() async {
    final version = await _versionRepository.getCurrentVersion();

    emit(version.toString());
  }
}
