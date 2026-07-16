import 'package:freezed_annotation/freezed_annotation.dart';

part 'technician_model.freezed.dart';
part 'technician_model.g.dart';

@freezed
class DayScheduleModel with _$DayScheduleModel {
  const factory DayScheduleModel({
    required bool enabled,
    String? start,
    String? end,
  }) = _DayScheduleModel;

  factory DayScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$DayScheduleModelFromJson(json);
}

@freezed
class WeeklyScheduleModel with _$WeeklyScheduleModel {
  const factory WeeklyScheduleModel({
    DayScheduleModel? monday,
    DayScheduleModel? tuesday,
    DayScheduleModel? wednesday,
    DayScheduleModel? thursday,
    DayScheduleModel? friday,
    DayScheduleModel? saturday,
    DayScheduleModel? sunday,
  }) = _WeeklyScheduleModel;

  factory WeeklyScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$WeeklyScheduleModelFromJson(json);
}

@freezed
class LocationModel with _$LocationModel {
  const factory LocationModel({
    required double lat,
    required double lng,
    String? address,
  }) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);
}

@freezed
class TechnicianSubcategoryModel with _$TechnicianSubcategoryModel {
  const factory TechnicianSubcategoryModel({
    required int id,
    required String name,
    required int categoryId,
    required String categoryName,
    double? priceMin,
    double? priceMax,
    String? priceUnit,
  }) = _TechnicianSubcategoryModel;

  factory TechnicianSubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianSubcategoryModelFromJson(json);
}

@freezed
class SubcategoryPricingInputModel with _$SubcategoryPricingInputModel {
  const factory SubcategoryPricingInputModel({
    required int subcategoryId,
    double? priceMin,
    double? priceMax,
  }) = _SubcategoryPricingInputModel;

  factory SubcategoryPricingInputModel.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryPricingInputModelFromJson(json);
}

@freezed
class TechnicianSubSubCategoryModel with _$TechnicianSubSubCategoryModel {
  const factory TechnicianSubSubCategoryModel({
    required int id,
    required String name,
    required int subcategoryId,
    required String subcategoryName,
    required int categoryId,
    required String categoryName,
    @Default('none') String contactMetricType,
  }) = _TechnicianSubSubCategoryModel;

  factory TechnicianSubSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianSubSubCategoryModelFromJson(json);
}

@freezed
class TechnicianPendingServiceModel with _$TechnicianPendingServiceModel {
  const factory TechnicianPendingServiceModel({
    required int id,
    required String name,
    required int subcategoryId,
  }) = _TechnicianPendingServiceModel;

  factory TechnicianPendingServiceModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianPendingServiceModelFromJson(json);
}

@freezed
class TechnicianPortfolioItemModel with _$TechnicianPortfolioItemModel {
  const factory TechnicianPortfolioItemModel({
    required int id,
    required String title,
    String? description,
    String? imageUrl,
    String? linkUrl,
    @Default(0) int sortOrder,
  }) = _TechnicianPortfolioItemModel;

  factory TechnicianPortfolioItemModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianPortfolioItemModelFromJson(json);
}

@freezed
class TechnicianWorkPhotoModel with _$TechnicianWorkPhotoModel {
  const factory TechnicianWorkPhotoModel({
    required int id,
    required String imageUrl,
    String? caption,
    @Default(0) int sortOrder,
  }) = _TechnicianWorkPhotoModel;

  factory TechnicianWorkPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianWorkPhotoModelFromJson(json);
}

@freezed
class WorkPhotoInputModel with _$WorkPhotoInputModel {
  const factory WorkPhotoInputModel({
    required String imageUrl,
    String? caption,
  }) = _WorkPhotoInputModel;

  factory WorkPhotoInputModel.fromJson(Map<String, dynamic> json) =>
      _$WorkPhotoInputModelFromJson(json);
}

@freezed
class TechnicianLicenseModel with _$TechnicianLicenseModel {
  const factory TechnicianLicenseModel({
    required int id,
    required String name,
    String? licenseNumber,
    String? imageUrl,
    @Default(false) bool verified,
  }) = _TechnicianLicenseModel;

  factory TechnicianLicenseModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianLicenseModelFromJson(json);
}

@freezed
class TechnicianCertificationModel with _$TechnicianCertificationModel {
  const factory TechnicianCertificationModel({
    required int id,
    required String name,
    String? issuer,
    String? imageUrl,
    @Default(false) bool verified,
  }) = _TechnicianCertificationModel;

  factory TechnicianCertificationModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianCertificationModelFromJson(json);
}

@freezed
class TechnicianCoverageDistrictModel with _$TechnicianCoverageDistrictModel {
  const factory TechnicianCoverageDistrictModel({
    required int id,
    required String label,
    required double lat,
    required double lng,
    @Default(false) bool isPrimary,
  }) = _TechnicianCoverageDistrictModel;

  factory TechnicianCoverageDistrictModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianCoverageDistrictModelFromJson(json);
}

@freezed
class TechnicianPublicModel with _$TechnicianPublicModel {
  const factory TechnicianPublicModel({
    required int id,
    required String name,
    String? specialty,
    String? profilePhotoUrl,
    @Default('independiente') String profileType,
    @Default(false) bool verified,
    String? verificationStatus,
    String? description,
    String? phone,
    String? address,
    LocationModel? location,
    @Default(10) int coverageRadiusKm,
    @Default(false) bool coversAllPeru,
    @Default([]) List<TechnicianCoverageDistrictModel> coverageDistricts,
    WeeklyScheduleModel? schedule,
    @Default([]) List<TechnicianSubcategoryModel> subcategories,
    @Default([]) List<TechnicianSubSubCategoryModel> subSubCategories,
    @Default([]) List<TechnicianPendingServiceModel> pendingServices,
    int? experienceYears,
    String? experienceDescription,
    @Default([]) List<TechnicianPortfolioItemModel> portfolio,
    @Default([]) List<TechnicianWorkPhotoModel> workPhotos,
    @Default([]) List<TechnicianCertificationModel> validatedCertifications,
    @Default(false) bool hasValidatedCertifications,
    double? averageRating,
    @Default(0) int ratingCount,
    double? distanceKm,
  }) = _TechnicianPublicModel;

  factory TechnicianPublicModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianPublicModelFromJson(json);
}

@freezed
class TechnicianApplicationModel with _$TechnicianApplicationModel {
  const factory TechnicianApplicationModel({
    @JsonKey(readValue: _technicianEntityId) required int id,
    required String name,
    int? userId,
    String? email,
    String? specialty,
    String? profilePhotoUrl,
    String? description,
    String? phone,
    String? address,
    String? documentType,
    String? documentNumber,
    String? documentImageUrl,
    String? documentFrontImageUrl,
    String? documentBackImageUrl,
    String? facePhotoUrl,
    String? rucDocumentUrl,
    String? companyLogoUrl,
    String? legalRepresentativeDocumentUrl,
    String? legalRepresentativeDocumentFrontUrl,
    String? legalRepresentativeDocumentBackUrl,
    @Default('independiente') String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
    String? backgroundDeclaration,
    @Default(false) bool backgroundVerified,
    LocationModel? location,
    @Default(10) int coverageRadiusKm,
    @Default(false) bool coversAllPeru,
    @Default([]) List<TechnicianCoverageDistrictModel> coverageDistricts,
    @Default(false) bool hasServiceArea,
    WeeklyScheduleModel? schedule,
    @Default([]) List<TechnicianSubcategoryModel> subcategories,
    @Default([]) List<TechnicianSubSubCategoryModel> subSubCategories,
    @Default([]) List<TechnicianPendingServiceModel> pendingServices,
    int? experienceYears,
    String? experienceDescription,
    @Default([]) List<TechnicianPortfolioItemModel> portfolio,
    @Default([]) List<TechnicianWorkPhotoModel> workPhotos,
    @Default([]) List<TechnicianLicenseModel> licenses,
    @Default([]) List<TechnicianCertificationModel> certifications,
    @Default([]) List<TechnicianCertificationModel> validatedCertifications,
    String? verificationStatus,
    @Default(false) bool verified,
    String? rejectionReason,
    DateTime? submittedAt,
    DateTime? reviewedAt,
    @Default(false) bool canEditProfile,
    @Default(false) bool canResubmit,
    @Default(false) bool canSubmitVerification,
    @Default(false) bool canSubmitCertification,
    @Default(false) bool certificationPending,
    @Default(false) bool hasValidatedCertifications,
    double? averageRating,
    @Default(0) int ratingCount,
  }) = _TechnicianApplicationModel;

  factory TechnicianApplicationModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianApplicationModelFromJson(json);
}

@freezed
class UpdateTechnicianProfileRequest with _$UpdateTechnicianProfileRequest {
  const factory UpdateTechnicianProfileRequest({
    String? name,
    String? specialty,
    String? phone,
    String? address,
    String? profilePhotoUrl,
    String? description,
    int? experienceYears,
    String? experienceDescription,
    LocationModel? location,
    int? coverageRadiusKm,
    bool? coversAllPeru,
    List<int>? coveragePlaceIds,
    int? primaryCoveragePlaceId,
    WeeklyScheduleModel? schedule,
    List<int>? subcategoryIds,
    List<SubcategoryPricingInputModel>? subcategoryPricing,
    List<int>? subSubCategoryIds,
    List<WorkPhotoInputModel>? workPhotos,
  }) = _UpdateTechnicianProfileRequest;

  factory UpdateTechnicianProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTechnicianProfileRequestFromJson(json);
}

@freezed
class RejectApplicationRequest with _$RejectApplicationRequest {
  const factory RejectApplicationRequest({required String reason}) =
      _RejectApplicationRequest;

  factory RejectApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$RejectApplicationRequestFromJson(json);
}

@freezed
class SubmitTechnicianVerificationRequest with _$SubmitTechnicianVerificationRequest {
  const factory SubmitTechnicianVerificationRequest({
    String? documentImageUrl,
    String? documentFrontImageUrl,
    String? documentBackImageUrl,
    String? facePhotoUrl,
    String? rucDocumentUrl,
    String? companyLogoUrl,
    String? legalRepresentativeDocumentUrl,
    String? legalRepresentativeDocumentFrontUrl,
    String? legalRepresentativeDocumentBackUrl,
    String? backgroundDeclaration,
    List<WorkPhotoSubmitRequest>? workPhotos,
  }) = _SubmitTechnicianVerificationRequest;

  factory SubmitTechnicianVerificationRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitTechnicianVerificationRequestFromJson(json);
}

@freezed
class SubmitTechnicianCertificationRequest with _$SubmitTechnicianCertificationRequest {
  const factory SubmitTechnicianCertificationRequest({
    required String name,
    String? issuer,
    required String imageUrl,
  }) = _SubmitTechnicianCertificationRequest;

  factory SubmitTechnicianCertificationRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitTechnicianCertificationRequestFromJson(json);
}

@freezed
class WorkPhotoSubmitRequest with _$WorkPhotoSubmitRequest {
  const factory WorkPhotoSubmitRequest({
    required String imageUrl,
    String? caption,
  }) = _WorkPhotoSubmitRequest;

  factory WorkPhotoSubmitRequest.fromJson(Map<String, dynamic> json) =>
      _$WorkPhotoSubmitRequestFromJson(json);
}

@freezed
class TechniciansQuery with _$TechniciansQuery {
  const factory TechniciansQuery({
    @Default(1) int page,
    @Default(20) int limit,
    int? categoryId,
    int? subcategoryId,
    int? subSubCategoryId,
    int? prioritizeSubSubCategoryId,
    String? search,
    double? lat,
    double? lng,
    @Default(15) int radiusKm,
  }) = _TechniciansQuery;
}

Object? _technicianEntityId(Map<dynamic, dynamic> json, String _) {
  final raw = json['id'] ?? json['userId'];
  if (raw is num) return raw.toInt();
  return null;
}
