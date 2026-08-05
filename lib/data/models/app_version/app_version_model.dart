class AppVersionPolicyModel {
  const AppVersionPolicyModel({
    required this.platform,
    required this.minVersionCode,
    required this.latestVersionCode,
    required this.minVersionName,
    required this.latestVersionName,
    required this.forceUpdate,
    required this.message,
    required this.storeUrl,
  });

  final String platform;
  final int minVersionCode;
  final int latestVersionCode;
  final String minVersionName;
  final String latestVersionName;
  final bool forceUpdate;
  final String message;
  final String storeUrl;

  factory AppVersionPolicyModel.fromJson(Map<String, dynamic> json) {
    return AppVersionPolicyModel(
      platform: json['platform'] as String? ?? 'android',
      minVersionCode: (json['minVersionCode'] as num?)?.toInt() ?? 1,
      latestVersionCode: (json['latestVersionCode'] as num?)?.toInt() ?? 1,
      minVersionName: json['minVersionName'] as String? ?? '1.0.0',
      latestVersionName: json['latestVersionName'] as String? ?? '1.0.0',
      forceUpdate: json['forceUpdate'] as bool? ?? false,
      message: json['message'] as String? ??
          'Hay una nueva versión disponible. Actualiza para continuar.',
      storeUrl: json['storeUrl'] as String? ??
          'https://play.google.com/store/apps/details?id=com.cimak.supra',
    );
  }
}

enum AppUpdateRequirement {
  none,
  optional,
  required,
}

class AppVersionCheckResult {
  const AppVersionCheckResult({
    required this.installedVersionCode,
    required this.installedVersionName,
    required this.policy,
    required this.requirement,
  });

  final int installedVersionCode;
  final String installedVersionName;
  final AppVersionPolicyModel policy;
  final AppUpdateRequirement requirement;

  bool get mustBlock => requirement == AppUpdateRequirement.required;
}
