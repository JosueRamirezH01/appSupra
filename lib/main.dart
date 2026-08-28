import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prueba/routes/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/errors/global_error.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/error_utils.dart';
import 'data/models/app_version/app_version_model.dart';
import 'presentation/providers/app_version/app_version_check_provider.dart';
import 'presentation/providers/location/client_location_data_providers.dart';
import 'presentation/screens/force_update_screen.dart';

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

class ServicesTectonicsApp extends ConsumerStatefulWidget {
  const ServicesTectonicsApp({super.key});

  @override
  ConsumerState<ServicesTectonicsApp> createState() => _ServicesTectonicsAppState();
}

class _ServicesTectonicsAppState extends ConsumerState<ServicesTectonicsApp> {
  bool _dismissedOptionalUpdate = false;

  @override
  Widget build(BuildContext context) {
    final versionAsync = ref.watch(appVersionCheckProvider);

    return versionAsync.when(
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, _) => _buildMainApp(),
      data: (result) {
        if (result == null) return _buildMainApp();

        if (result.requirement == AppUpdateRequirement.required) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: ForceUpdateScreen(result: result),
          );
        }

        if (result.requirement == AppUpdateRequirement.optional &&
            !_dismissedOptionalUpdate) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: ForceUpdateScreen(
              result: result,
              canDismiss: true,
              onDismiss: () => setState(() => _dismissedOptionalUpdate = true),
            ),
          );
        }

        return _buildMainApp();
      },
    );
  }

  Widget _buildMainApp() {
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
