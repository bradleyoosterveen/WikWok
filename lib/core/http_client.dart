import 'package:dio/dio.dart';

class WHttpClient {
  Dio getClient({String baseUrl = ''}) => Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ));
}
