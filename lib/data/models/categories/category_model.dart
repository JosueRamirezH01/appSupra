import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Sugerencias 1–5 del admin para rubros de producto. Solo ayuda para nombrar.
List<String> parseProductSubcategorySuggestions(Object? value) {
  if (value is! List) return const [];

  final seen = <String>{};
  final suggestions = <String>[];

  for (final item in value) {
    if (item is! String) continue;
    final trimmed = item.trim();
    if (trimmed.isEmpty) continue;
    if (!seen.add(trimmed.toLowerCase())) continue;
    suggestions.add(trimmed);
    if (suggestions.length >= 5) break;
  }

  return suggestions;
}

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required int id,
    required String name,
    @Default(true) bool status,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}

@freezed
class SubcategoryModel with _$SubcategoryModel {
  const factory SubcategoryModel({
    required int id,
    required int categoryId,
    required String name,
    @Default(true) bool status,
    String? imageUrl,
    @Default([]) List<String> suggestions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SubcategoryModel;

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryModelFromJson(json);
}

@freezed
class SubSubCategoryModel with _$SubSubCategoryModel {
  const factory SubSubCategoryModel({
    required int id,
    required int subcategoryId,
    required String name,
    @Default(true) bool status,
    String? imageUrl,
    @Default('none') String contactMetricType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SubSubCategoryModel;

  factory SubSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubSubCategoryModelFromJson(json);
}

@freezed
class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    required String name,
    String? imageUrl,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}

@freezed
class UpdateCategoryRequest with _$UpdateCategoryRequest {
  const factory UpdateCategoryRequest({
    required String name,
    String? imageUrl,
  }) = _UpdateCategoryRequest;

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryRequestFromJson(json);
}

@freezed
class CreateSubcategoryRequest with _$CreateSubcategoryRequest {
  const factory CreateSubcategoryRequest({
    required String name,
    required int categoryId,
    String? imageUrl,
  }) = _CreateSubcategoryRequest;

  factory CreateSubcategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSubcategoryRequestFromJson(json);
}

@freezed
class CreateSubSubCategoryRequest with _$CreateSubSubCategoryRequest {
  const factory CreateSubSubCategoryRequest({
    required String name,
    required int subcategoryId,
    String? imageUrl,
  }) = _CreateSubSubCategoryRequest;

  factory CreateSubSubCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSubSubCategoryRequestFromJson(json);
}

@freezed
class UpdateStatusRequest with _$UpdateStatusRequest {
  const factory UpdateStatusRequest({required bool status}) =
      _UpdateStatusRequest;

  factory UpdateStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateStatusRequestFromJson(json);
}
