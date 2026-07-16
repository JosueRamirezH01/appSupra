// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomeHeroModelImpl _$$HomeHeroModelImplFromJson(Map<String, dynamic> json) =>
    _$HomeHeroModelImpl(
      backgroundImageUrl: json['backgroundImageUrl'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$HomeHeroModelImplToJson(_$HomeHeroModelImpl instance) =>
    <String, dynamic>{
      'backgroundImageUrl': instance.backgroundImageUrl,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_$HomeCarouselSlideModelImpl _$$HomeCarouselSlideModelImplFromJson(
  Map<String, dynamic> json,
) => _$HomeCarouselSlideModelImpl(
  id: (json['id'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  title: json['title'] as String,
  buttonLabel: json['buttonLabel'] as String? ?? 'AQUÍ',
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  status: json['status'] as bool? ?? true,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$HomeCarouselSlideModelImplToJson(
  _$HomeCarouselSlideModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'buttonLabel': instance.buttonLabel,
  'sortOrder': instance.sortOrder,
  'status': instance.status,
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_$HomeContentModelImpl _$$HomeContentModelImplFromJson(
  Map<String, dynamic> json,
) => _$HomeContentModelImpl(
  hero: HomeHeroModel.fromJson(json['hero'] as Map<String, dynamic>),
  carouselSlides:
      (json['carouselSlides'] as List<dynamic>?)
          ?.map(
            (e) => HomeCarouselSlideModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
);

Map<String, dynamic> _$$HomeContentModelImplToJson(
  _$HomeContentModelImpl instance,
) => <String, dynamic>{
  'hero': instance.hero,
  'carouselSlides': instance.carouselSlides,
};
