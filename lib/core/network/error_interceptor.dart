import 'package:dio/dio.dart';

import '../../data/models/common/api_error_model.dart';
import '../errors/app_exception.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;

    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      if (data['success'] == false) {
        try {
          final apiError = ApiErrorModel.fromJson(data);
          handler.reject(
            DioException(
              requestOptions: err.requestOptions,
              response: response,
              type: err.type,
              error: AppException.fromApiError(
                apiError,
                statusCode: response.statusCode,
              ),
            ),
          );
          return;
        } catch (_) {
          // fall through
        }
      }
    }

    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: response,
          type: err.type,
          error: AppException.network(),
        ),
      );
      return;
    }

    handler.next(err);
  }
}
