import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../errors/app_exception.dart';

AppException parseException(Object error) {
  if (error is AppException) return error;
  if (error is DioException && error.error is AppException) {
    return error.error as AppException;
  }
  if (error is DioException) {
    return AppException.network(error.message);
  }
  return AppException.unknown(error.toString());
}

void showErrorSnackBar(BuildContext context, Object error) {
  final exception = parseException(error);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(exception.message),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

Future<void> runSoftRefresh(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (error) {
    if (context.mounted) showErrorSnackBar(context, error);
  }
}

String errorMessage(Object error) => parseException(error).message;
