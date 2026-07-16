import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_content_model.freezed.dart';
part 'home_content_model.g.dart';

@freezed
class HomeHeroModel with _$HomeHeroModel {
  const factory HomeHeroModel({
    String? backgroundImageUrl,
    DateTime? updatedAt,
  }) = _HomeHeroModel;

  factory HomeHeroModel.fromJson(Map<String, dynamic> json) =>
      _$HomeHeroModelFromJson(json);
}

@freezed
class HomeCarouselSlideModel with _$HomeCarouselSlideModel {
  const factory HomeCarouselSlideModel({
    required int id,
    required String imageUrl,
    required String title,
    @Default('AQUÍ') String buttonLabel,
    @Default(0) int sortOrder,
    @Default(true) bool status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _HomeCarouselSlideModel;

  factory HomeCarouselSlideModel.fromJson(Map<String, dynamic> json) =>
      _$HomeCarouselSlideModelFromJson(json);
}

@freezed
class HomeContentModel with _$HomeContentModel {
  const factory HomeContentModel({
    required HomeHeroModel hero,
    @Default([]) List<HomeCarouselSlideModel> carouselSlides,
  }) = _HomeContentModel;

  factory HomeContentModel.fromJson(Map<String, dynamic> json) =>
      _$HomeContentModelFromJson(json);
}
