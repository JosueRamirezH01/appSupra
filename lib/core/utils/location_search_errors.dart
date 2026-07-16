import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../errors/app_exception.dart';

String resolveLocationSearchError(Object error) {
  final appException = _asAppException(error);
  if (appException != null) {
    if (appException.code == 'NETWORK_ERROR') {
      return _networkMessage();
    }
    return appException.message;
  }

  if (error is DioException) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return _networkMessage();
    }
  }

  return 'No se pudo buscar la ubicación. Intenta de nuevo.';
}

AppException? _asAppException(Object error) {
  if (error is AppException) return error;
  if (error is DioException && error.error is AppException) {
    return error.error as AppException;
  }
  return null;
}

String _networkMessage() {
  return 'No se pudo conectar al servidor (${AppConfig.baseUrl}). '
      'Verifica que el backend esté encendido. '
      'En celular físico usa la IP de tu PC, no 10.0.2.2.';
}
