import 'dart:async';

import 'package:dio/dio.dart';

import '../../data/models/auth/session_model.dart';
import '../constants/api_endpoints.dart';
import '../errors/app_exception.dart';
import '../storage/secure_storage_service.dart';

typedef OnSessionExpired = Future<void> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._dio,
    required this._storage,
    required this._onSessionExpired,
  });

  final Dio _dio;
  final SecureStorageService _storage;
  final OnSessionExpired _onSessionExpired;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingRequests = [];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final path = err.requestOptions.path;
    if (path.contains(ApiEndpoints.login) ||
        path.contains(ApiEndpoints.googleLogin) ||
        path.contains(ApiEndpoints.refresh) ||
        path.contains(ApiEndpoints.register)) {
      handler.next(err);
      return;
    }

    final refreshToken = await _storage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _onSessionExpired();
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: AppException.unauthorized(),
        ),
      );
      return;
    }

    if (_isRefreshing) {
      final completer = Completer<Response<dynamic>>();
      _pendingRequests.add(_PendingRequest(err.requestOptions, completer));
      try {
        final response = await completer.future;
        handler.resolve(response);
      } catch (e) {
        handler.reject(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
          ),
        );
      }
      return;
    }

    _isRefreshing = true;
    try {
      final refreshResponse = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.refresh,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': null},
          extra: {'skipAuth': true},
        ),
      );

      final data = refreshResponse.data?['data'] as Map<String, dynamic>?;
      final sessionJson = data?['session'] as Map<String, dynamic>?;
      if (sessionJson == null) {
        throw AppException.unauthorized();
      }

      final session = SessionModel.fromJson(sessionJson);
      await _storage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );

      final retryResponse = await _retry(err.requestOptions);
      _resolvePending(retryResponse);
      handler.resolve(retryResponse);
    } catch (_) {
      await _onSessionExpired();
      _rejectPending(AppException.unauthorized());
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: AppException.unauthorized(),
        ),
      );
    } finally {
      _isRefreshing = false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions options) async {
    final token = await _storage.getAccessToken();
    final headers = Map<String, dynamic>.from(options.headers);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return _dio.fetch<dynamic>(
      options.copyWith(headers: headers),
    );
  }

  void _resolvePending(Response<dynamic> response) {
    for (final pending in _pendingRequests) {
      _retry(pending.options).then(pending.completer.complete).catchError(
            pending.completer.completeError,
          );
    }
    _pendingRequests.clear();
  }

  void _rejectPending(Object error) {
    for (final pending in _pendingRequests) {
      pending.completer.completeError(error);
    }
    _pendingRequests.clear();
  }
}

class _PendingRequest {
  _PendingRequest(this.options, this.completer);

  final RequestOptions options;
  final Completer<Response<dynamic>> completer;
}
