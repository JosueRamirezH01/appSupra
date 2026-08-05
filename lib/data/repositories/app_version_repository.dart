import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';

import '../datasources/app_version_remote_datasource.dart';
import '../models/app_version/app_version_model.dart';

class AppVersionRepository {
  AppVersionRepository(this._remote);

  final AppVersionRemoteDataSource _remote;

  Future<AppVersionCheckResult> check({String? platform}) async {
    final resolvedPlatform = platform ?? (Platform.isIOS ? 'ios' : 'android');
    final info = await PackageInfo.fromPlatform();
    final installedCode = int.tryParse(info.buildNumber) ?? 0;
    final installedName = info.version;

    final policy = await _remote.fetchPolicy(platform: resolvedPlatform);

    final AppUpdateRequirement requirement;
    if (installedCode < policy.minVersionCode) {
      requirement = policy.forceUpdate
          ? AppUpdateRequirement.required
          : AppUpdateRequirement.optional;
    } else {
      requirement = AppUpdateRequirement.none;
    }

    return AppVersionCheckResult(
      installedVersionCode: installedCode,
      installedVersionName: installedName,
      policy: policy,
      requirement: requirement,
    );
  }
}
