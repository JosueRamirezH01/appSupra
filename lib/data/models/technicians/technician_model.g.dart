// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technician_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DayScheduleModelImpl _$$DayScheduleModelImplFromJson(
  Map<String, dynamic> json,
) => _$DayScheduleModelImpl(
  enabled: json['enabled'] as bool,
  start: json['start'] as String?,
  end: json['end'] as String?,
);

Map<String, dynamic> _$$DayScheduleModelImplToJson(
  _$DayScheduleModelImpl instance,
) => <String, dynamic>{
  'enabled': instance.enabled,
  'start': instance.start,
  'end': instance.end,
};

_$WeeklyScheduleModelImpl _$$WeeklyScheduleModelImplFromJson(
  Map<String, dynamic> json,
) => _$WeeklyScheduleModelImpl(
  monday: json['monday'] == null
      ? null
      : DayScheduleModel.fromJson(json['monday'] as Map<String, dynamic>),
  tuesday: json['tuesday'] == null
      ? null
      : DayScheduleModel.fromJson(json['tuesday'] as Map<String, dynamic>),
  wednesday: json['wednesday'] == null
      ? null
      : DayScheduleModel.fromJson(json['wednesday'] as Map<String, dynamic>),
  thursday: json['thursday'] == null
      ? null
      : DayScheduleModel.fromJson(json['thursday'] as Map<String, dynamic>),
  friday: json['friday'] == null
      ? null
      : DayScheduleModel.fromJson(json['friday'] as Map<String, dynamic>),
  saturday: json['saturday'] == null
      ? null
      : DayScheduleModel.fromJson(json['saturday'] as Map<String, dynamic>),
  sunday: json['sunday'] == null
      ? null
      : DayScheduleModel.fromJson(json['sunday'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$WeeklyScheduleModelImplToJson(
  _$WeeklyScheduleModelImpl instance,
) => <String, dynamic>{
  'monday': instance.monday,
  'tuesday': instance.tuesday,
  'wednesday': instance.wednesday,
  'thursday': instance.thursday,
  'friday': instance.friday,
  'saturday': instance.saturday,
  'sunday': instance.sunday,
};

_$LocationModelImpl _$$LocationModelImplFromJson(Map<String, dynamic> json) =>
    _$LocationModelImpl(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String?,
    );

Map<String, dynamic> _$$LocationModelImplToJson(_$LocationModelImpl instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
    };

_$TechnicianSubcategoryModelImpl _$$TechnicianSubcategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianSubcategoryModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  categoryName: json['categoryName'] as String,
  priceMin: (json['priceMin'] as num?)?.toDouble(),
  priceMax: (json['priceMax'] as num?)?.toDouble(),
  priceUnit: json['priceUnit'] as String?,
);

Map<String, dynamic> _$$TechnicianSubcategoryModelImplToJson(
  _$TechnicianSubcategoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
  'priceUnit': instance.priceUnit,
};

_$SubcategoryPricingInputModelImpl _$$SubcategoryPricingInputModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubcategoryPricingInputModelImpl(
  subcategoryId: (json['subcategoryId'] as num).toInt(),
  priceMin: (json['priceMin'] as num?)?.toDouble(),
  priceMax: (json['priceMax'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$SubcategoryPricingInputModelImplToJson(
  _$SubcategoryPricingInputModelImpl instance,
) => <String, dynamic>{
  'subcategoryId': instance.subcategoryId,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
};

_$TechnicianSubSubCategoryModelImpl
_$$TechnicianSubSubCategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$TechnicianSubSubCategoryModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      subcategoryId: (json['subcategoryId'] as num).toInt(),
      subcategoryName: json['subcategoryName'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: json['categoryName'] as String,
      contactMetricType: json['contactMetricType'] as String? ?? 'none',
      pricingMode: json['pricingMode'] as String? ?? 'both',
      imageUrl: json['imageUrl'] as String?,
      description: json['description'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      laborPriceMin: (json['laborPriceMin'] as num?)?.toDouble(),
      laborPriceMax: (json['laborPriceMax'] as num?)?.toDouble(),
      turnkeyPriceMin: (json['turnkeyPriceMin'] as num?)?.toDouble(),
      turnkeyPriceMax: (json['turnkeyPriceMax'] as num?)?.toDouble(),
      profilePriceDisplay: json['profilePriceDisplay'] as String? ?? 'labor',
      previewImageUrl: json['previewImageUrl'] as String?,
      hasPortfolio: json['hasPortfolio'] as bool? ?? false,
      workPhotos:
          (json['workPhotos'] as List<dynamic>?)
              ?.map(
                (e) => TechnicianWorkPhotoModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TechnicianSubSubCategoryModelImplToJson(
  _$TechnicianSubSubCategoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'subcategoryId': instance.subcategoryId,
  'subcategoryName': instance.subcategoryName,
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'contactMetricType': instance.contactMetricType,
  'pricingMode': instance.pricingMode,
  'imageUrl': instance.imageUrl,
  'description': instance.description,
  'experienceYears': instance.experienceYears,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
  'laborPriceMin': instance.laborPriceMin,
  'laborPriceMax': instance.laborPriceMax,
  'turnkeyPriceMin': instance.turnkeyPriceMin,
  'turnkeyPriceMax': instance.turnkeyPriceMax,
  'profilePriceDisplay': instance.profilePriceDisplay,
  'previewImageUrl': instance.previewImageUrl,
  'hasPortfolio': instance.hasPortfolio,
  'workPhotos': instance.workPhotos,
};

_$TechnicianPendingServiceModelImpl
_$$TechnicianPendingServiceModelImplFromJson(Map<String, dynamic> json) =>
    _$TechnicianPendingServiceModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      subcategoryId: (json['subcategoryId'] as num).toInt(),
    );

Map<String, dynamic> _$$TechnicianPendingServiceModelImplToJson(
  _$TechnicianPendingServiceModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'subcategoryId': instance.subcategoryId,
};

_$TechnicianPortfolioImageModelImpl
_$$TechnicianPortfolioImageModelImplFromJson(Map<String, dynamic> json) =>
    _$TechnicianPortfolioImageModelImpl(
      id: (json['id'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TechnicianPortfolioImageModelImplToJson(
  _$TechnicianPortfolioImageModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'sortOrder': instance.sortOrder,
};

_$TechnicianPortfolioItemModelImpl _$$TechnicianPortfolioItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianPortfolioItemModelImpl(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  location: json['location'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  images:
      (json['images'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianPortfolioImageModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  linkUrl: json['linkUrl'] as String?,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TechnicianPortfolioItemModelImplToJson(
  _$TechnicianPortfolioItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'location': instance.location,
  'description': instance.description,
  'imageUrl': instance.imageUrl,
  'images': instance.images,
  'linkUrl': instance.linkUrl,
  'sortOrder': instance.sortOrder,
};

_$PortfolioImageInputModelImpl _$$PortfolioImageInputModelImplFromJson(
  Map<String, dynamic> json,
) => _$PortfolioImageInputModelImpl(imageUrl: json['imageUrl'] as String);

Map<String, dynamic> _$$PortfolioImageInputModelImplToJson(
  _$PortfolioImageInputModelImpl instance,
) => <String, dynamic>{'imageUrl': instance.imageUrl};

_$PortfolioItemInputModelImpl _$$PortfolioItemInputModelImplFromJson(
  Map<String, dynamic> json,
) => _$PortfolioItemInputModelImpl(
  title: json['title'] as String?,
  location: json['location'] as String,
  description: json['description'] as String?,
  images:
      (json['images'] as List<dynamic>?)
          ?.map(
            (e) => PortfolioImageInputModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PortfolioItemInputModelImplToJson(
  _$PortfolioItemInputModelImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'location': instance.location,
  'description': instance.description,
  'images': instance.images,
};

_$TechnicianWorkPhotoModelImpl _$$TechnicianWorkPhotoModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianWorkPhotoModelImpl(
  id: (json['id'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  caption: json['caption'] as String?,
  estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TechnicianWorkPhotoModelImplToJson(
  _$TechnicianWorkPhotoModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'caption': instance.caption,
  'estimatedCost': instance.estimatedCost,
  'sortOrder': instance.sortOrder,
};

_$WorkPhotoInputModelImpl _$$WorkPhotoInputModelImplFromJson(
  Map<String, dynamic> json,
) => _$WorkPhotoInputModelImpl(
  imageUrl: json['imageUrl'] as String,
  caption: json['caption'] as String?,
  estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$WorkPhotoInputModelImplToJson(
  _$WorkPhotoInputModelImpl instance,
) => <String, dynamic>{
  'imageUrl': instance.imageUrl,
  'caption': instance.caption,
  'estimatedCost': instance.estimatedCost,
};

_$TechnicianLicenseModelImpl _$$TechnicianLicenseModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianLicenseModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  licenseNumber: json['licenseNumber'] as String?,
  imageUrl: json['imageUrl'] as String?,
  verified: json['verified'] as bool? ?? false,
);

Map<String, dynamic> _$$TechnicianLicenseModelImplToJson(
  _$TechnicianLicenseModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'licenseNumber': instance.licenseNumber,
  'imageUrl': instance.imageUrl,
  'verified': instance.verified,
};

_$TechnicianCertificationModelImpl _$$TechnicianCertificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianCertificationModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  issuer: json['issuer'] as String?,
  imageUrl: json['imageUrl'] as String?,
  verified: json['verified'] as bool? ?? false,
);

Map<String, dynamic> _$$TechnicianCertificationModelImplToJson(
  _$TechnicianCertificationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'issuer': instance.issuer,
  'imageUrl': instance.imageUrl,
  'verified': instance.verified,
};

_$TechnicianCoverageDistrictModelImpl
_$$TechnicianCoverageDistrictModelImplFromJson(Map<String, dynamic> json) =>
    _$TechnicianCoverageDistrictModelImpl(
      id: (json['id'] as num).toInt(),
      label: json['label'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      isPrimary: json['isPrimary'] as bool? ?? false,
    );

Map<String, dynamic> _$$TechnicianCoverageDistrictModelImplToJson(
  _$TechnicianCoverageDistrictModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'lat': instance.lat,
  'lng': instance.lng,
  'isPrimary': instance.isPrimary,
};

_$TechnicianPublicModelImpl _$$TechnicianPublicModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianPublicModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  businessName: json['businessName'] as String?,
  displayName: json['displayName'] as String?,
  specialty: json['specialty'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  companyLogoUrl: json['companyLogoUrl'] as String?,
  profileType: json['profileType'] as String? ?? 'independiente',
  verified: json['verified'] as bool? ?? false,
  verificationStatus: json['verificationStatus'] as String?,
  description: json['description'] as String?,
  minimumQuote: (json['minimumQuote'] as num?)?.toDouble(),
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  location: json['location'] == null
      ? null
      : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
  coverageRadiusKm: (json['coverageRadiusKm'] as num?)?.toInt() ?? 10,
  coversAllPeru: json['coversAllPeru'] as bool? ?? false,
  coverageDistricts:
      (json['coverageDistricts'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianCoverageDistrictModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  schedule: json['schedule'] == null
      ? null
      : WeeklyScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
  subcategories:
      (json['subcategories'] as List<dynamic>?)
          ?.map(
            (e) =>
                TechnicianSubcategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  subSubCategories:
      (json['subSubCategories'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianSubSubCategoryModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  pendingServices:
      (json['pendingServices'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianPendingServiceModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  experienceDescription: json['experienceDescription'] as String?,
  portfolio:
      (json['portfolio'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianPortfolioItemModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  workPhotos:
      (json['workPhotos'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianWorkPhotoModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  validatedCertifications:
      (json['validatedCertifications'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianCertificationModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  hasValidatedCertifications:
      json['hasValidatedCertifications'] as bool? ?? false,
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  distanceKm: (json['distanceKm'] as num?)?.toDouble(),
  placement: json['placement'] as String? ?? 'organic',
);

Map<String, dynamic> _$$TechnicianPublicModelImplToJson(
  _$TechnicianPublicModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'businessName': instance.businessName,
  'displayName': instance.displayName,
  'specialty': instance.specialty,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'companyLogoUrl': instance.companyLogoUrl,
  'profileType': instance.profileType,
  'verified': instance.verified,
  'verificationStatus': instance.verificationStatus,
  'description': instance.description,
  'minimumQuote': instance.minimumQuote,
  'phone': instance.phone,
  'address': instance.address,
  'location': instance.location,
  'coverageRadiusKm': instance.coverageRadiusKm,
  'coversAllPeru': instance.coversAllPeru,
  'coverageDistricts': instance.coverageDistricts,
  'schedule': instance.schedule,
  'subcategories': instance.subcategories,
  'subSubCategories': instance.subSubCategories,
  'pendingServices': instance.pendingServices,
  'experienceYears': instance.experienceYears,
  'experienceDescription': instance.experienceDescription,
  'portfolio': instance.portfolio,
  'workPhotos': instance.workPhotos,
  'validatedCertifications': instance.validatedCertifications,
  'hasValidatedCertifications': instance.hasValidatedCertifications,
  'averageRating': instance.averageRating,
  'ratingCount': instance.ratingCount,
  'distanceKm': instance.distanceKm,
  'placement': instance.placement,
};

_$TechnicianApplicationModelImpl _$$TechnicianApplicationModelImplFromJson(
  Map<String, dynamic> json,
) => _$TechnicianApplicationModelImpl(
  id: (_technicianEntityId(json, 'id') as num).toInt(),
  name: json['name'] as String,
  userId: (json['userId'] as num?)?.toInt(),
  email: json['email'] as String?,
  specialty: json['specialty'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  description: json['description'] as String?,
  minimumQuote: (json['minimumQuote'] as num?)?.toDouble(),
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  documentType: json['documentType'] as String?,
  documentNumber: json['documentNumber'] as String?,
  documentImageUrl: json['documentImageUrl'] as String?,
  documentFrontImageUrl: json['documentFrontImageUrl'] as String?,
  documentBackImageUrl: json['documentBackImageUrl'] as String?,
  facePhotoUrl: json['facePhotoUrl'] as String?,
  rucDocumentUrl: json['rucDocumentUrl'] as String?,
  companyLogoUrl: json['companyLogoUrl'] as String?,
  legalRepresentativeDocumentUrl:
      json['legalRepresentativeDocumentUrl'] as String?,
  legalRepresentativeDocumentFrontUrl:
      json['legalRepresentativeDocumentFrontUrl'] as String?,
  legalRepresentativeDocumentBackUrl:
      json['legalRepresentativeDocumentBackUrl'] as String?,
  profileType: json['profileType'] as String? ?? 'independiente',
  ruc: json['ruc'] as String?,
  businessName: json['businessName'] as String?,
  legalRepresentativeName: json['legalRepresentativeName'] as String?,
  backgroundDeclaration: json['backgroundDeclaration'] as String?,
  backgroundVerified: json['backgroundVerified'] as bool? ?? false,
  location: json['location'] == null
      ? null
      : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
  coverageRadiusKm: (json['coverageRadiusKm'] as num?)?.toInt() ?? 10,
  coversAllPeru: json['coversAllPeru'] as bool? ?? false,
  coverageDistricts:
      (json['coverageDistricts'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianCoverageDistrictModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  hasServiceArea: json['hasServiceArea'] as bool? ?? false,
  schedule: json['schedule'] == null
      ? null
      : WeeklyScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
  subcategories:
      (json['subcategories'] as List<dynamic>?)
          ?.map(
            (e) =>
                TechnicianSubcategoryModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  subSubCategories:
      (json['subSubCategories'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianSubSubCategoryModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  pendingServices:
      (json['pendingServices'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianPendingServiceModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  experienceDescription: json['experienceDescription'] as String?,
  portfolio:
      (json['portfolio'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianPortfolioItemModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  workPhotos:
      (json['workPhotos'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianWorkPhotoModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  licenses:
      (json['licenses'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianLicenseModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  certifications:
      (json['certifications'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianCertificationModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  validatedCertifications:
      (json['validatedCertifications'] as List<dynamic>?)
          ?.map(
            (e) => TechnicianCertificationModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList() ??
      const [],
  verificationStatus: json['verificationStatus'] as String?,
  verified: json['verified'] as bool? ?? false,
  rejectionReason: json['rejectionReason'] as String?,
  submittedAt: json['submittedAt'] == null
      ? null
      : DateTime.parse(json['submittedAt'] as String),
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
  canEditProfile: json['canEditProfile'] as bool? ?? false,
  canResubmit: json['canResubmit'] as bool? ?? false,
  canSubmitVerification: json['canSubmitVerification'] as bool? ?? false,
  canSubmitCertification: json['canSubmitCertification'] as bool? ?? false,
  certificationPending: json['certificationPending'] as bool? ?? false,
  hasValidatedCertifications:
      json['hasValidatedCertifications'] as bool? ?? false,
  averageRating: (json['averageRating'] as num?)?.toDouble(),
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$TechnicianApplicationModelImplToJson(
  _$TechnicianApplicationModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'userId': instance.userId,
  'email': instance.email,
  'specialty': instance.specialty,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'description': instance.description,
  'minimumQuote': instance.minimumQuote,
  'phone': instance.phone,
  'address': instance.address,
  'documentType': instance.documentType,
  'documentNumber': instance.documentNumber,
  'documentImageUrl': instance.documentImageUrl,
  'documentFrontImageUrl': instance.documentFrontImageUrl,
  'documentBackImageUrl': instance.documentBackImageUrl,
  'facePhotoUrl': instance.facePhotoUrl,
  'rucDocumentUrl': instance.rucDocumentUrl,
  'companyLogoUrl': instance.companyLogoUrl,
  'legalRepresentativeDocumentUrl': instance.legalRepresentativeDocumentUrl,
  'legalRepresentativeDocumentFrontUrl':
      instance.legalRepresentativeDocumentFrontUrl,
  'legalRepresentativeDocumentBackUrl':
      instance.legalRepresentativeDocumentBackUrl,
  'profileType': instance.profileType,
  'ruc': instance.ruc,
  'businessName': instance.businessName,
  'legalRepresentativeName': instance.legalRepresentativeName,
  'backgroundDeclaration': instance.backgroundDeclaration,
  'backgroundVerified': instance.backgroundVerified,
  'location': instance.location,
  'coverageRadiusKm': instance.coverageRadiusKm,
  'coversAllPeru': instance.coversAllPeru,
  'coverageDistricts': instance.coverageDistricts,
  'hasServiceArea': instance.hasServiceArea,
  'schedule': instance.schedule,
  'subcategories': instance.subcategories,
  'subSubCategories': instance.subSubCategories,
  'pendingServices': instance.pendingServices,
  'experienceYears': instance.experienceYears,
  'experienceDescription': instance.experienceDescription,
  'portfolio': instance.portfolio,
  'workPhotos': instance.workPhotos,
  'licenses': instance.licenses,
  'certifications': instance.certifications,
  'validatedCertifications': instance.validatedCertifications,
  'verificationStatus': instance.verificationStatus,
  'verified': instance.verified,
  'rejectionReason': instance.rejectionReason,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
  'canEditProfile': instance.canEditProfile,
  'canResubmit': instance.canResubmit,
  'canSubmitVerification': instance.canSubmitVerification,
  'canSubmitCertification': instance.canSubmitCertification,
  'certificationPending': instance.certificationPending,
  'hasValidatedCertifications': instance.hasValidatedCertifications,
  'averageRating': instance.averageRating,
  'ratingCount': instance.ratingCount,
};

_$UpdateTechnicianProfileRequestImpl
_$$UpdateTechnicianProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateTechnicianProfileRequestImpl(
  name: json['name'] as String?,
  specialty: json['specialty'] as String?,
  phone: json['phone'] as String?,
  address: json['address'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  description: json['description'] as String?,
  minimumQuote: json['minimumQuote'] as String?,
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  experienceDescription: json['experienceDescription'] as String?,
  location: json['location'] == null
      ? null
      : LocationModel.fromJson(json['location'] as Map<String, dynamic>),
  coverageRadiusKm: (json['coverageRadiusKm'] as num?)?.toInt(),
  coversAllPeru: json['coversAllPeru'] as bool?,
  coveragePlaceIds: (json['coveragePlaceIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  primaryCoveragePlaceId: (json['primaryCoveragePlaceId'] as num?)?.toInt(),
  schedule: json['schedule'] == null
      ? null
      : WeeklyScheduleModel.fromJson(json['schedule'] as Map<String, dynamic>),
  subcategoryIds: (json['subcategoryIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  subcategoryPricing: (json['subcategoryPricing'] as List<dynamic>?)
      ?.map(
        (e) => SubcategoryPricingInputModel.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  subSubCategoryIds: (json['subSubCategoryIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  workPhotos: (json['workPhotos'] as List<dynamic>?)
      ?.map((e) => WorkPhotoInputModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  portfolio: (json['portfolio'] as List<dynamic>?)
      ?.map((e) => PortfolioItemInputModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$UpdateTechnicianProfileRequestImplToJson(
  _$UpdateTechnicianProfileRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'specialty': instance.specialty,
  'phone': instance.phone,
  'address': instance.address,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'description': instance.description,
  if (instance.minimumQuote case final value?) 'minimumQuote': value,
  'experienceYears': instance.experienceYears,
  'experienceDescription': instance.experienceDescription,
  'location': instance.location,
  'coverageRadiusKm': instance.coverageRadiusKm,
  'coversAllPeru': instance.coversAllPeru,
  'coveragePlaceIds': instance.coveragePlaceIds,
  'primaryCoveragePlaceId': instance.primaryCoveragePlaceId,
  'schedule': instance.schedule,
  'subcategoryIds': instance.subcategoryIds,
  'subcategoryPricing': instance.subcategoryPricing,
  'subSubCategoryIds': instance.subSubCategoryIds,
  'workPhotos': instance.workPhotos,
  'portfolio': instance.portfolio,
};

_$UpdateTechnicianServiceRequestImpl
_$$UpdateTechnicianServiceRequestImplFromJson(Map<String, dynamic> json) =>
    _$UpdateTechnicianServiceRequestImpl(
      description: json['description'] as String?,
      experienceYears: (json['experienceYears'] as num?)?.toInt(),
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      laborPriceMin: (json['laborPriceMin'] as num?)?.toDouble(),
      laborPriceMax: (json['laborPriceMax'] as num?)?.toDouble(),
      turnkeyPriceMin: (json['turnkeyPriceMin'] as num?)?.toDouble(),
      turnkeyPriceMax: (json['turnkeyPriceMax'] as num?)?.toDouble(),
      profilePriceDisplay: json['profilePriceDisplay'] as String?,
      workPhotos:
          (json['workPhotos'] as List<dynamic>?)
              ?.map(
                (e) => WorkPhotoInputModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      uploadSessionId: json['uploadSessionId'] as String?,
    );

Map<String, dynamic> _$$UpdateTechnicianServiceRequestImplToJson(
  _$UpdateTechnicianServiceRequestImpl instance,
) => <String, dynamic>{
  if (instance.description case final value?) 'description': value,
  if (instance.experienceYears case final value?) 'experienceYears': value,
  'priceMin': instance.priceMin,
  'priceMax': instance.priceMax,
  'laborPriceMin': instance.laborPriceMin,
  'laborPriceMax': instance.laborPriceMax,
  'turnkeyPriceMin': instance.turnkeyPriceMin,
  'turnkeyPriceMax': instance.turnkeyPriceMax,
  if (instance.profilePriceDisplay case final value?)
    'profilePriceDisplay': value,
  'workPhotos': instance.workPhotos,
  if (instance.uploadSessionId case final value?) 'uploadSessionId': value,
};

_$RejectApplicationRequestImpl _$$RejectApplicationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RejectApplicationRequestImpl(reason: json['reason'] as String);

Map<String, dynamic> _$$RejectApplicationRequestImplToJson(
  _$RejectApplicationRequestImpl instance,
) => <String, dynamic>{'reason': instance.reason};

_$SubmitTechnicianVerificationRequestImpl
_$$SubmitTechnicianVerificationRequestImplFromJson(Map<String, dynamic> json) =>
    _$SubmitTechnicianVerificationRequestImpl(
      documentImageUrl: json['documentImageUrl'] as String?,
      documentFrontImageUrl: json['documentFrontImageUrl'] as String?,
      documentBackImageUrl: json['documentBackImageUrl'] as String?,
      facePhotoUrl: json['facePhotoUrl'] as String?,
      rucDocumentUrl: json['rucDocumentUrl'] as String?,
      companyLogoUrl: json['companyLogoUrl'] as String?,
      legalRepresentativeDocumentUrl:
          json['legalRepresentativeDocumentUrl'] as String?,
      legalRepresentativeDocumentFrontUrl:
          json['legalRepresentativeDocumentFrontUrl'] as String?,
      legalRepresentativeDocumentBackUrl:
          json['legalRepresentativeDocumentBackUrl'] as String?,
      backgroundDeclaration: json['backgroundDeclaration'] as String?,
      workPhotos: (json['workPhotos'] as List<dynamic>?)
          ?.map(
            (e) => WorkPhotoSubmitRequest.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$$SubmitTechnicianVerificationRequestImplToJson(
  _$SubmitTechnicianVerificationRequestImpl instance,
) => <String, dynamic>{
  'documentImageUrl': instance.documentImageUrl,
  'documentFrontImageUrl': instance.documentFrontImageUrl,
  'documentBackImageUrl': instance.documentBackImageUrl,
  'facePhotoUrl': instance.facePhotoUrl,
  'rucDocumentUrl': instance.rucDocumentUrl,
  'companyLogoUrl': instance.companyLogoUrl,
  'legalRepresentativeDocumentUrl': instance.legalRepresentativeDocumentUrl,
  'legalRepresentativeDocumentFrontUrl':
      instance.legalRepresentativeDocumentFrontUrl,
  'legalRepresentativeDocumentBackUrl':
      instance.legalRepresentativeDocumentBackUrl,
  'backgroundDeclaration': instance.backgroundDeclaration,
  'workPhotos': instance.workPhotos,
};

_$SubmitTechnicianCertificationRequestImpl
_$$SubmitTechnicianCertificationRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SubmitTechnicianCertificationRequestImpl(
  name: json['name'] as String,
  issuer: json['issuer'] as String?,
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$$SubmitTechnicianCertificationRequestImplToJson(
  _$SubmitTechnicianCertificationRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'issuer': instance.issuer,
  'imageUrl': instance.imageUrl,
};

_$WorkPhotoSubmitRequestImpl _$$WorkPhotoSubmitRequestImplFromJson(
  Map<String, dynamic> json,
) => _$WorkPhotoSubmitRequestImpl(
  imageUrl: json['imageUrl'] as String,
  caption: json['caption'] as String?,
  estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
);

Map<String, dynamic> _$$WorkPhotoSubmitRequestImplToJson(
  _$WorkPhotoSubmitRequestImpl instance,
) => <String, dynamic>{
  'imageUrl': instance.imageUrl,
  'caption': instance.caption,
  'estimatedCost': instance.estimatedCost,
};
