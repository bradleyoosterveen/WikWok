import 'dart:developer' as developer;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wikwok/app.dart';
import 'package:wikwok/core/exception_handler.dart';

void main() {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: binding);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  WExceptionHandler().errorStream.listen((error) => developer.log(
        error,
        name: 'Exception',
      ));

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    WExceptionHandler().handleAnything(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    WExceptionHandler().handleAnything(error);
    return true;
  };

  runApp(const App());
}
