import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reemplaza el estado con un fetch nuevo sin borrar el último valor exitoso.
/// Si ya había datos y falla, se conservan y se relanza el error para el snackbar.
Future<void> refreshKeepingPrevious<T>({
  required AsyncValue<T> current,
  required void Function(AsyncValue<T> next) setState,
  required Future<T> Function() fetch,
}) async {
  final previous = current.valueOrNull;
  try {
    setState(AsyncValue.data(await fetch()));
  } catch (error, stackTrace) {
    if (previous != null) {
      setState(AsyncValue.data(previous));
      Error.throwWithStackTrace(error, stackTrace);
    }
    setState(AsyncValue.error(error, stackTrace));
  }
}
