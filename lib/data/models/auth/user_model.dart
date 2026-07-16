import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/enums/app_view.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class ClientProfileCompletionModel with _$ClientProfileCompletionModel {
  const factory ClientProfileCompletionModel({
    required int percent,
    required bool isComplete,
    @Default([]) List<String> missingFields,
  }) = _ClientProfileCompletionModel;

  factory ClientProfileCompletionModel.fromJson(Map<String, dynamic> json) =>
      _$ClientProfileCompletionModelFromJson(json);
}

@freezed
class ClientProfileModel with _$ClientProfileModel {
  const factory ClientProfileModel({
    String? phone,
    String? address,
  }) = _ClientProfileModel;

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ClientProfileModelFromJson(json);
}

@freezed
class TechnicianProfileSummaryModel with _$TechnicianProfileSummaryModel {
  const factory TechnicianProfileSummaryModel({
    String? specialty,
    String? phone,
    @Default(false) bool verified,
    String? verificationStatus,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    @Default(false) bool canResubmit,
    @Default(false) bool canSubmitVerification,
  }) = _TechnicianProfileSummaryModel;

  factory TechnicianProfileSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianProfileSummaryModelFromJson(json);
}

@freezed
class SellerProfileSummaryModel with _$SellerProfileSummaryModel {
  const factory SellerProfileSummaryModel({
    required String businessName,
    required String ruc,
    required String legalRepresentativeName,
    String? phone,
    String? description,
    String? logoUrl,
    @Default(false) bool verified,
    String? verificationStatus,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    @Default(false) bool canSubmitVerification,
  }) = _SellerProfileSummaryModel;

  factory SellerProfileSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SellerProfileSummaryModelFromJson(json);
}

@freezed
class UserNavigationModel with _$UserNavigationModel {
  const factory UserNavigationModel({
    @Default([]) List<String> availableViews,
    String? defaultView,
    @Default(false) bool canBecomeTechnician,
    @Default(false) bool canBecomeSeller,
    @Default(false) bool technicianApplicationPending,
    @Default(false) bool sellerApplicationPending,
  }) = _UserNavigationModel;

  factory UserNavigationModel.fromJson(Map<String, dynamic> json) =>
      _$UserNavigationModelFromJson(json);
}

@freezed
class UserViewsModel with _$UserViewsModel {
  const factory UserViewsModel({
    ClientProfileModel? client,
    TechnicianProfileSummaryModel? technician,
    SellerProfileSummaryModel? seller,
  }) = _UserViewsModel;

  factory UserViewsModel.fromJson(Map<String, dynamic> json) =>
      _$UserViewsModelFromJson(json);
}

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required int id,
    required String name,
    required String email,
    String? profilePhotoUrl,
    @Default([]) List<String> roles,
    UserNavigationModel? navigation,
    UserViewsModel? views,
    ClientProfileCompletionModel? profileCompletion,
    @Default(true) bool active,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  bool get isAdmin => roles.contains('admin');
  bool get isClient => roles.contains('cliente');
  bool get isTechnician => roles.contains('tecnico');
  bool get isSeller => roles.contains('vendedor');

  bool get hasTechnicianProfile =>
      views?.technician != null || isTechnician;

  bool get hasSellerProfile => views?.seller != null || isSeller;

  bool get hasClientProfile => views?.client != null || isClient;

  List<AppView> get parsedAvailableViews {
    final fromApi = navigation?.availableViews
            .map(AppView.tryParse)
            .whereType<AppView>()
            .toList() ??
        [];

    if (fromApi.isNotEmpty) return fromApi;

    final fallback = <AppView>[];
    if (hasClientProfile) fallback.add(AppView.client);
    if (hasTechnicianProfile) fallback.add(AppView.technician);
    if (hasSellerProfile) fallback.add(AppView.seller);
    if (isAdmin) fallback.add(AppView.admin);
    return fallback;
  }

  bool get canSwitchProfileMode {
    final views = parsedAvailableViews
        .where((view) => view != AppView.admin)
        .toSet();
    return views.length > 1;
  }

  AppView get preferredDefaultView =>
      AppView.tryParse(navigation?.defaultView) ??
      (parsedAvailableViews.isNotEmpty
          ? parsedAvailableViews.first
          : AppView.client);

  TechnicianProfileSummaryModel? get technicianSummary => views?.technician;
  SellerProfileSummaryModel? get sellerSummary => views?.seller;

  bool get needsClientProfileCompletion =>
      profileCompletion != null && !profileCompletion!.isComplete;
}
