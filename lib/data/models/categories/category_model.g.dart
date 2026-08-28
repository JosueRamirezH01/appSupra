// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoryModelImpl _$$CategoryModelImplFromJson(Map<String, dynamic> json) =>
    _$CategoryModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      status: json['status'] as bool? ?? true,
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$CategoryModelImplToJson(_$CategoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'imageUrl': instance.imageUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$SubcategoryModelImpl _$$SubcategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubcategoryModelImpl(
  id: (json['id'] as num).toInt(),
  categoryId: (json['categoryId'] as num).toInt(),
  name: json['name'] as String,
  status: json['status'] as bool? ?? true,
  imageUrl: json['imageUrl'] as String?,
  suggestions: parseProductSubcategorySuggestions(json['suggestions']),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$SubcategoryModelImplToJson(
  _$SubcategoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'name': instance.name,
  'status': instance.status,
  'imageUrl': instance.imageUrl,
  'suggestions': instance.suggestions,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_$SubSubCategoryModelImpl _$$SubSubCategoryModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubSubCategoryModelImpl(
  id: (json['id'] as num).toInt(),
  subcategoryId: (json['subcategoryId'] as num).toInt(),
  name: json['name'] as String,
  status: json['status'] as bool? ?? true,
  imageUrl: json['imageUrl'] as String?,
  contactMetricType: json['contactMetricType'] as String? ?? 'none',
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$SubSubCategoryModelImplToJson(
  _$SubSubCategoryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'subcategoryId': instance.subcategoryId,
  'name': instance.name,
  'status': instance.status,
  'imageUrl': instance.imageUrl,
  'contactMetricType': instance.contactMetricType,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_$CreateCategoryRequestImpl _$$CreateCategoryRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateCategoryRequestImpl(
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$CreateCategoryRequestImplToJson(
  _$CreateCategoryRequestImpl instance,
) => <String, dynamic>{'name': instance.name, 'imageUrl': instance.imageUrl};

_$UpdateCategoryRequestImpl _$$UpdateCategoryRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateCategoryRequestImpl(
  name: json['name'] as String,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$UpdateCategoryRequestImplToJson(
  _$UpdateCategoryRequestImpl instance,
) => <String, dynamic>{'name': instance.name, 'imageUrl': instance.imageUrl};

_$CreateSubcategoryRequestImpl _$$CreateSubcategoryRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateSubcategoryRequestImpl(
  name: json['name'] as String,
  categoryId: (json['categoryId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$CreateSubcategoryRequestImplToJson(
  _$CreateSubcategoryRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'categoryId': instance.categoryId,
  'imageUrl': instance.imageUrl,
};

_$CreateSubSubCategoryRequestImpl _$$CreateSubSubCategoryRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateSubSubCategoryRequestImpl(
  name: json['name'] as String,
  subcategoryId: (json['subcategoryId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$$CreateSubSubCategoryRequestImplToJson(
  _$CreateSubSubCategoryRequestImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'subcategoryId': instance.subcategoryId,
  'imageUrl': instance.imageUrl,
};

_$UpdateStatusRequestImpl _$$UpdateStatusRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateStatusRequestImpl(status: json['status'] as bool);

Map<String, dynamic> _$$UpdateStatusRequestImplToJson(
  _$UpdateStatusRequestImpl instance,
) => <String, dynamic>{'status': instance.status};
