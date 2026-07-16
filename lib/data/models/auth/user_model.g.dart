// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientProfileCompletionModelImpl _$$ClientProfileCompletionModelImplFromJson(
  Map<String, dynamic> json,
) => _$ClientProfileCompletionModelImpl(
  percent: (json['percent'] as num).toInt(),
  isComplete: json['isComplete'] as bool,
  missingFields:
      (json['missingFields'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$ClientProfileCompletionModelImplToJson(
  _$ClientProfileCompletionModelImpl instance,
) => <String, dynamic>{
  'percent': instance.percent,
  'isComplete': instance.isComplete,
  'missingFields': instance.missingFields,
};

_$ClientProfileModelImpl _$$ClientProfileModelImplFromJson(
  Map<String, dynamic> json,
) => _$ClientProfileModelImpl(
  phone: json['phone'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$$ClientProfileModelImplToJson(
  _$ClientProfileModelImpl instance,
) => <String, dynamic>{'phone': instance.phone, 'address': instance.address};

_$TechnicianProfileSummaryModelImpl
_$$TechnicianProfileSummaryModelImplFromJson(Map<String, dynamic> json) =>
    _$TechnicianProfileSummaryModelImpl(
      specialty: json['specialty'] as String?,
      phone: json['phone'] as String?,
      verified: json['verified'] as bool? ?? false,
      verificationStatus: json['verificationStatus'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] == null
          ? null
          : DateTime.parse(json['submittedAt'] as String),
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      canResubmit: json['canResubmit'] as bool? ?? false,
      canSubmitVerification: json['canSubmitVerification'] as bool? ?? false,
    );

Map<String, dynamic> _$$TechnicianProfileSummaryModelImplToJson(
  _$TechnicianProfileSummaryModelImpl instance,
) => <String, dynamic>{
  'specialty': instance.specialty,
  'phone': instance.phone,
  'verified': instance.verified,
  'verificationStatus': instance.verificationStatus,
  'rejectionReason': instance.rejectionReason,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
  'canResubmit': instance.canResubmit,
  'canSubmitVerification': instance.canSubmitVerification,
};

_$SellerProfileSummaryModelImpl _$$SellerProfileSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$SellerProfileSummaryModelImpl(
  businessName: json['businessName'] as String,
  ruc: json['ruc'] as String,
  legalRepresentativeName: json['legalRepresentativeName'] as String,
  phone: json['phone'] as String?,
  description: json['description'] as String?,
  logoUrl: json['logoUrl'] as String?,
  verified: json['verified'] as bool? ?? false,
  verificationStatus: json['verificationStatus'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  submittedAt: json['submittedAt'] == null
      ? null
      : DateTime.parse(json['submittedAt'] as String),
  reviewedAt: json['reviewedAt'] == null
      ? null
      : DateTime.parse(json['reviewedAt'] as String),
  canSubmitVerification: json['canSubmitVerification'] as bool? ?? false,
);

Map<String, dynamic> _$$SellerProfileSummaryModelImplToJson(
  _$SellerProfileSummaryModelImpl instance,
) => <String, dynamic>{
  'businessName': instance.businessName,
  'ruc': instance.ruc,
  'legalRepresentativeName': instance.legalRepresentativeName,
  'phone': instance.phone,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'verified': instance.verified,
  'verificationStatus': instance.verificationStatus,
  'rejectionReason': instance.rejectionReason,
  'submittedAt': instance.submittedAt?.toIso8601String(),
  'reviewedAt': instance.reviewedAt?.toIso8601String(),
  'canSubmitVerification': instance.canSubmitVerification,
};

_$UserNavigationModelImpl _$$UserNavigationModelImplFromJson(
  Map<String, dynamic> json,
) => _$UserNavigationModelImpl(
  availableViews:
      (json['availableViews'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  defaultView: json['defaultView'] as String?,
  canBecomeTechnician: json['canBecomeTechnician'] as bool? ?? false,
  canBecomeSeller: json['canBecomeSeller'] as bool? ?? false,
  technicianApplicationPending:
      json['technicianApplicationPending'] as bool? ?? false,
  sellerApplicationPending: json['sellerApplicationPending'] as bool? ?? false,
);

Map<String, dynamic> _$$UserNavigationModelImplToJson(
  _$UserNavigationModelImpl instance,
) => <String, dynamic>{
  'availableViews': instance.availableViews,
  'defaultView': instance.defaultView,
  'canBecomeTechnician': instance.canBecomeTechnician,
  'canBecomeSeller': instance.canBecomeSeller,
  'technicianApplicationPending': instance.technicianApplicationPending,
  'sellerApplicationPending': instance.sellerApplicationPending,
};

_$UserViewsModelImpl _$$UserViewsModelImplFromJson(Map<String, dynamic> json) =>
    _$UserViewsModelImpl(
      client: json['client'] == null
          ? null
          : ClientProfileModel.fromJson(json['client'] as Map<String, dynamic>),
      technician: json['technician'] == null
          ? null
          : TechnicianProfileSummaryModel.fromJson(
              json['technician'] as Map<String, dynamic>,
            ),
      seller: json['seller'] == null
          ? null
          : SellerProfileSummaryModel.fromJson(
              json['seller'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$$UserViewsModelImplToJson(
  _$UserViewsModelImpl instance,
) => <String, dynamic>{
  'client': instance.client,
  'technician': instance.technician,
  'seller': instance.seller,
};

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      profilePhotoUrl: json['profilePhotoUrl'] as String?,
      roles:
          (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      navigation: json['navigation'] == null
          ? null
          : UserNavigationModel.fromJson(
              json['navigation'] as Map<String, dynamic>,
            ),
      views: json['views'] == null
          ? null
          : UserViewsModel.fromJson(json['views'] as Map<String, dynamic>),
      profileCompletion: json['profileCompletion'] == null
          ? null
          : ClientProfileCompletionModel.fromJson(
              json['profileCompletion'] as Map<String, dynamic>,
            ),
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profilePhotoUrl': instance.profilePhotoUrl,
      'roles': instance.roles,
      'navigation': instance.navigation,
      'views': instance.views,
      'profileCompletion': instance.profileCompletion,
      'active': instance.active,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
