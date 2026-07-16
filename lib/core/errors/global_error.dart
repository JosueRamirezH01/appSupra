import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Canal opcional para mostrar errores globales vía snackbar en [main.dart].
final globalErrorProvider = StateProvider<AsyncValue<void>>(
  (ref) => const AsyncValue.data(null),
);

void reportGlobalError(WidgetRef ref, Object error, [StackTrace? stackTrace]) {
  ref.read(globalErrorProvider.notifier).state = AsyncValue.error(
    error,
    stackTrace ?? StackTrace.current,
  );
}
