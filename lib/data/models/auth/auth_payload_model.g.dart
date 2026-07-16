// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_payload_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthPayloadModelImpl _$$AuthPayloadModelImplFromJson(
  Map<String, dynamic> json,
) => _$AuthPayloadModelImpl(
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  session: SessionModel.fromJson(json['session'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AuthPayloadModelImplToJson(
  _$AuthPayloadModelImpl instance,
) => <String, dynamic>{'user': instance.user, 'session': instance.session};

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_$GoogleLoginRequestImpl _$$GoogleLoginRequestImplFromJson(
  Map<String, dynamic> json,
) => _$GoogleLoginRequestImpl(idToken: json['idToken'] as String);

Map<String, dynamic> _$$GoogleLoginRequestImplToJson(
  _$GoogleLoginRequestImpl instance,
) => <String, dynamic>{'idToken': instance.idToken};

_$RefreshRequestImpl _$$RefreshRequestImplFromJson(Map<String, dynamic> json) =>
    _$RefreshRequestImpl(refreshToken: json['refreshToken'] as String);

Map<String, dynamic> _$$RefreshRequestImplToJson(
  _$RefreshRequestImpl instance,
) => <String, dynamic>{'refreshToken': instance.refreshToken};

_$RegisterClientRequestImpl _$$RegisterClientRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterClientRequestImpl(
  email: json['email'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$$RegisterClientRequestImplToJson(
  _$RegisterClientRequestImpl instance,
) => <String, dynamic>{'email': instance.email, 'password': instance.password};

_$ForgotPasswordRequestImpl _$$ForgotPasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ForgotPasswordRequestImpl(email: json['email'] as String);

Map<String, dynamic> _$$ForgotPasswordRequestImplToJson(
  _$ForgotPasswordRequestImpl instance,
) => <String, dynamic>{'email': instance.email};

_$UpdateClientProfileRequestImpl _$$UpdateClientProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateClientProfileRequestImpl(
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  uploadSessionId: json['uploadSessionId'] as String?,
);

Map<String, dynamic> _$$UpdateClientProfileRequestImplToJson(
  _$UpdateClientProfileRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'uploadSessionId': instance.uploadSessionId,
};

_$AddClientProfileRequestImpl _$$AddClientProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddClientProfileRequestImpl(
  phone: json['phone'] as String?,
  address: json['address'] as String?,
);

Map<String, dynamic> _$$AddClientProfileRequestImplToJson(
  _$AddClientProfileRequestImpl instance,
) => <String, dynamic>{'phone': instance.phone, 'address': instance.address};

_$RegisterTechnicianRequestImpl _$$RegisterTechnicianRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterTechnicianRequestImpl(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  phone: json['phone'] as String,
  subcategoryIds: (json['subcategoryIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  documentNumber: json['documentNumber'] as String,
  specialty: json['specialty'] as String?,
  address: json['address'] as String?,
  documentType: json['documentType'] as String? ?? 'DNI',
  subSubCategoryIds: (json['subSubCategoryIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  description: json['description'] as String?,
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  uploadSessionId: json['uploadSessionId'] as String?,
  profileType: json['profileType'] as String? ?? 'independiente',
  ruc: json['ruc'] as String?,
  businessName: json['businessName'] as String?,
  legalRepresentativeName: json['legalRepresentativeName'] as String?,
);

Map<String, dynamic> _$$RegisterTechnicianRequestImplToJson(
  _$RegisterTechnicianRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'phone': instance.phone,
  'subcategoryIds': instance.subcategoryIds,
  'documentNumber': instance.documentNumber,
  'specialty': instance.specialty,
  'address': instance.address,
  'documentType': instance.documentType,
  'subSubCategoryIds': instance.subSubCategoryIds,
  'description': instance.description,
  'experienceYears': instance.experienceYears,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'uploadSessionId': instance.uploadSessionId,
  'profileType': instance.profileType,
  'ruc': instance.ruc,
  'businessName': instance.businessName,
  'legalRepresentativeName': instance.legalRepresentativeName,
};

_$AddTechnicianProfileRequestImpl _$$AddTechnicianProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddTechnicianProfileRequestImpl(
  subcategoryIds: (json['subcategoryIds'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  documentNumber: json['documentNumber'] as String,
  phone: json['phone'] as String,
  specialty: json['specialty'] as String?,
  address: json['address'] as String?,
  documentType: json['documentType'] as String? ?? 'DNI',
  subSubCategoryIds: (json['subSubCategoryIds'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  description: json['description'] as String?,
  experienceYears: (json['experienceYears'] as num?)?.toInt(),
  profilePhotoUrl: json['profilePhotoUrl'] as String?,
  profileType: json['profileType'] as String? ?? 'independiente',
  ruc: json['ruc'] as String?,
  businessName: json['businessName'] as String?,
  legalRepresentativeName: json['legalRepresentativeName'] as String?,
);

Map<String, dynamic> _$$AddTechnicianProfileRequestImplToJson(
  _$AddTechnicianProfileRequestImpl instance,
) => <String, dynamic>{
  'subcategoryIds': instance.subcategoryIds,
  'documentNumber': instance.documentNumber,
  'phone': instance.phone,
  'specialty': instance.specialty,
  'address': instance.address,
  'documentType': instance.documentType,
  'subSubCategoryIds': instance.subSubCategoryIds,
  'description': instance.description,
  'experienceYears': instance.experienceYears,
  'profilePhotoUrl': instance.profilePhotoUrl,
  'profileType': instance.profileType,
  'ruc': instance.ruc,
  'businessName': instance.businessName,
  'legalRepresentativeName': instance.legalRepresentativeName,
};

_$RegisterSellerRequestImpl _$$RegisterSellerRequestImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterSellerRequestImpl(
  name: json['name'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  phone: json['phone'] as String,
  businessName: json['businessName'] as String,
  ruc: json['ruc'] as String,
  legalRepresentativeName: json['legalRepresentativeName'] as String,
  address: json['address'] as String?,
  description: json['description'] as String?,
  logoUrl: json['logoUrl'] as String?,
  rucDocumentUrl: json['rucDocumentUrl'] as String?,
);

Map<String, dynamic> _$$RegisterSellerRequestImplToJson(
  _$RegisterSellerRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'password': instance.password,
  'phone': instance.phone,
  'businessName': instance.businessName,
  'ruc': instance.ruc,
  'legalRepresentativeName': instance.legalRepresentativeName,
  'address': instance.address,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'rucDocumentUrl': instance.rucDocumentUrl,
};

_$AddSellerProfileRequestImpl _$$AddSellerProfileRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AddSellerProfileRequestImpl(
  businessName: json['businessName'] as String,
  ruc: json['ruc'] as String,
  legalRepresentativeName: json['legalRepresentativeName'] as String,
  phone: json['phone'] as String,
  address: json['address'] as String?,
  description: json['description'] as String?,
  logoUrl: json['logoUrl'] as String?,
  rucDocumentUrl: json['rucDocumentUrl'] as String?,
);

Map<String, dynamic> _$$AddSellerProfileRequestImplToJson(
  _$AddSellerProfileRequestImpl instance,
) => <String, dynamic>{
  'businessName': instance.businessName,
  'ruc': instance.ruc,
  'legalRepresentativeName': instance.legalRepresentativeName,
  'phone': instance.phone,
  'address': instance.address,
  'description': instance.description,
  'logoUrl': instance.logoUrl,
  'rucDocumentUrl': instance.rucDocumentUrl,
};
