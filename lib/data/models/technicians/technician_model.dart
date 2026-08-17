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
    /// Modo de precio del catálogo: both | labor | turnkey.
    @Default('both') String pricingMode,
    /// Imagen del catálogo (sub-subcategoría), independiente del portafolio del técnico.
    String? imageUrl,
    String? description,
    double? minimumQuote,
    int? experienceYears,
    /// Alias de mano de obra (compat API).
    double? priceMin,
    double? priceMax,
    double? laborPriceMin,
    double? laborPriceMax,
    double? turnkeyPriceMin,
    double? turnkeyPriceMax,
    /// Precio a mostrar en el carrusel del perfil: labor | turnkey.
    @Default('labor') String profilePriceDisplay,
    /// Imagen de portada de la card (carrusel). Independiente del portafolio.
    String? cardImageServiceUrl,
    @Default(false) bool hasPortfolio,
    @Default([]) List<TechnicianWorkPhotoModel> workPhotos,
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
class TechnicianPortfolioImageModel with _$TechnicianPortfolioImageModel {
  const factory TechnicianPortfolioImageModel({
    required int id,
    required String imageUrl,
    @Default(0) int sortOrder,
  }) = _TechnicianPortfolioImageModel;

  factory TechnicianPortfolioImageModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianPortfolioImageModelFromJson(json);
}

@freezed
class TechnicianPortfolioItemModel with _$TechnicianPortfolioItemModel {
  const factory TechnicianPortfolioItemModel({
    required int id,
    required String title,
    String? location,
    String? description,
    String? imageUrl,
    @Default([]) List<TechnicianPortfolioImageModel> images,
    String? linkUrl,
    @Default(0) int sortOrder,
  }) = _TechnicianPortfolioItemModel;

  factory TechnicianPortfolioItemModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianPortfolioItemModelFromJson(json);
}

@freezed
class PortfolioImageInputModel with _$PortfolioImageInputModel {
  const factory PortfolioImageInputModel({
    required String imageUrl,
  }) = _PortfolioImageInputModel;

  factory PortfolioImageInputModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioImageInputModelFromJson(json);
}

@freezed
class PortfolioItemInputModel with _$PortfolioItemInputModel {
  const factory PortfolioItemInputModel({
    String? title,
    required String location,
    String? description,
    @Default([]) List<PortfolioImageInputModel> images,
  }) = _PortfolioItemInputModel;

  factory PortfolioItemInputModel.fromJson(Map<String, dynamic> json) =>
      _$PortfolioItemInputModelFromJson(json);
}

@freezed
class TechnicianWorkPhotoModel with _$TechnicianWorkPhotoModel {
  const factory TechnicianWorkPhotoModel({
    required int id,
    required String imageUrl,
    String? caption,
    @Default(0) int sortOrder,
    double? estimatedCost,
    double? estimatedCostMin,
    double? estimatedCostMax,
    @Default('labor') String estimatePricingType,
  }) = _TechnicianWorkPhotoModel;

  factory TechnicianWorkPhotoModel.fromJson(Map<String, dynamic> json) =>
      _$TechnicianWorkPhotoModelFromJson(json);
}

@freezed
class WorkPhotoInputModel with _$WorkPhotoInputModel {
  const factory WorkPhotoInputModel({
    required String imageUrl,
    String? caption,
    double? estimatedCost,
    double? estimatedCostMin,
    double? estimatedCostMax,
    @Default('labor') String estimatePricingType,
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
    /// Razón social (empresa). Null en independiente.
    String? businessName,
    /// Nombre público preferido del API (empresa → razón social).
    String? displayName,
    /// Logo de empresa (cards / perfil público).
    String? companyLogoUrl,
    /// Cotización mínima referencial del perfil (piso comercial).
    double? minimumQuote,
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
    @Default('organic') String placement,
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
    /// Cotización mínima referencial del perfil (piso comercial).
    double? minimumQuote,
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
    /// '' limpia en API; omitir no modifica. Monto como texto.
    @JsonKey(includeIfNull: false) String? minimumQuote,
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
    List<PortfolioItemInputModel>? portfolio,
  }) = _UpdateTechnicianProfileRequest;

  factory UpdateTechnicianProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTechnicianProfileRequestFromJson(json);
}

/// Contenido editable de un servicio (sub-subcategoría) del técnico: descripción,
/// experiencia, precio referencial y portafolio de fotos.
@freezed
class UpdateTechnicianServiceRequest with _$UpdateTechnicianServiceRequest {
  const factory UpdateTechnicianServiceRequest({
    /// Si es null no se envía (no borra en backend). Para limpiar, enviar ''.
    @JsonKey(includeIfNull: false) String? description,
    @JsonKey(includeIfNull: false) int? experienceYears,
    /// Alias mano de obra (compat). Omitir no modifica; null limpia si se envía explícito vía otro flujo.
    @JsonKey(includeIfNull: false) double? priceMin,
    @JsonKey(includeIfNull: false) double? priceMax,
    @JsonKey(includeIfNull: false) double? laborPriceMin,
    @JsonKey(includeIfNull: false) double? laborPriceMax,
    @JsonKey(includeIfNull: false) double? turnkeyPriceMin,
    @JsonKey(includeIfNull: false) double? turnkeyPriceMax,
    @JsonKey(includeIfNull: false) String? profilePriceDisplay,
    @JsonKey(includeIfNull: false) String? cardImageServiceUrl,
    @JsonKey(includeIfNull: false) List<WorkPhotoInputModel>? workPhotos,
    @JsonKey(includeIfNull: false) String? uploadSessionId,
  }) = _UpdateTechnicianServiceRequest;

  factory UpdateTechnicianServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTechnicianServiceRequestFromJson(json);
}

@freezed
class RejectApplicationRequest with _$RejectApplicationRequest {
  const factory RejectApplicationRequest({required String reason}) =
      _RejectApplicationRequest;

  factory RejectApplicationRequest.fromJson(Map<String, dynamic> json) =>
      _$RejectApplicationRequestFromJson(json);
}

@freezed
class SubmitTechnicianVerificationRequest
    with _$SubmitTechnicianVerificationRequest {
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

  factory SubmitTechnicianVerificationRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$SubmitTechnicianVerificationRequestFromJson(json);
}

@freezed
class SubmitTechnicianCertificationRequest
    with _$SubmitTechnicianCertificationRequest {
  const factory SubmitTechnicianCertificationRequest({
    required String name,
    String? issuer,
    required String imageUrl,
  }) = _SubmitTechnicianCertificationRequest;

  factory SubmitTechnicianCertificationRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$SubmitTechnicianCertificationRequestFromJson(json);
}

@freezed
class WorkPhotoSubmitRequest with _$WorkPhotoSubmitRequest {
  const factory WorkPhotoSubmitRequest({
    required String imageUrl,
    String? caption,
    double? estimatedCost,
    double? estimatedCostMin,
    double? estimatedCostMax,
    @Default('labor') String estimatePricingType,
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
