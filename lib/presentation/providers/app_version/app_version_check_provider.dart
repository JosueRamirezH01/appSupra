import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/app_version/app_version_model.dart';
import '../repository_providers.dart';

part 'app_version_check_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AppVersionCheckResult?> appVersionCheck(AppVersionCheckRef ref) async {
  try {
    return await ref.watch(appVersionRepositoryProvider).check();
  } catch (_) {
    // Fail open: if the version API is down, do not block the whole app.
    return null;
  }
}
