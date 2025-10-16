import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class WExceptionHandler {
  static final WExceptionHandler _instance = WExceptionHandler._internal();

  factory WExceptionHandler() => _instance;

  WExceptionHandler._internal();

  BehaviorSubject<String> errorStream = BehaviorSubject<String>();

  void handleException(Exception e) => errorStream.add(switch (e) {
        _ when e is DioException => _onDioException(e),
        _ => _onException(e),
      });

  void handleAnything(Object e) => errorStream.add(e.toString());

  String _onException(Exception e) => 'A generic exception occurred: $e';

  String _onDioException(DioException e) =>
      '${e.requestOptions.uri.toString()} returned ${e.response?.statusCode}';
}
