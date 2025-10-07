import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WCubit<T> extends Cubit<T> {
  WCubit(super.initialState);

  @override
  void onChange(Change<T> change) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('$runtimeType ${change.currentState} -> ${change.nextState}');
    }
    super.onChange(change);
  }
}
