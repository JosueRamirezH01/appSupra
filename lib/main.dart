import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/errors/global_error.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/error_utils.dart';
import 'presentation/providers/location/client_location_data_providers.dart';
void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Más espacio para banners del home y perfiles con muchas fotos.
      PaintingBinding.instance.imageCache
        ..maximumSize = 200
        ..maximumSizeBytes = 200 << 20;

      final sharedPreferences = await SharedPreferences.getInstance();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        debugPrint('FlutterError: ${details.exceptionAsString()}');
      };

      runApp(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWith(
              (ref) async => sharedPreferences,
            ),
          ],
          child: const ServicesTectonicsApp(),
        ),
      );
    },
    (error, stack) => debugPrint('Uncaught error: $error\n$stack'),
  );
}

class ServicesTectonicsApp extends ConsumerWidget {
  const ServicesTectonicsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Supra',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: router,
      builder: (context, child) {
        return _GlobalErrorListener(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

class _GlobalErrorListener extends ConsumerWidget {
  const _GlobalErrorListener({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      globalErrorProvider,
      (_, next) {
        next.whenOrNull(
          error: (error, _) => showErrorSnackBar(context, error),
        );
      },
    );
    return child;
  }
}
