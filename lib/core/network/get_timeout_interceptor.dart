import 'package:dio/dio.dart';

import '../config/app_config.dart';

/// Timeouts cortos solo en GET (listados y fichas). POST/PUT de fotos no se tocan.
class GetTimeoutInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.method.toUpperCase() == 'GET') {
      options.connectTimeout = AppConfig.listConnectTimeout;
      options.receiveTimeout = AppConfig.listReceiveTimeout;
    }
    handler.next(options);
  }
}
