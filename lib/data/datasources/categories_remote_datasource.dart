import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/categories/catalog_list_result.dart';
import '../models/categories/category_model.dart';

class CategoriesRemoteDataSource {
  CategoriesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CategoryModel>> getCategories({bool includeInactive = false}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.categories,
      queryParameters:
          includeInactive ? {'includeInactive': 'true'} : null,
    );
    return _parseList(response.data, 'categories', CategoryModel.fromJson);
  }

  Future<CategoryModel> createCategory(CreateCategoryRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.categories,
      data: request.toJson(),
    );
    return _parseSingle(response.data, 'category', CategoryModel.fromJson);
  }

  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest request) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.category(id),
      data: request.toJson(),
    );
    return _parseSingle(response.data, 'category', CategoryModel.fromJson);
  }

  Future<CategoryModel> updateCategoryStatus(int id, bool status) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.categoryStatus(id),
      data: UpdateStatusRequest(status: status).toJson(),
    );
    return _parseSingle(response.data, 'category', CategoryModel.fromJson);
  }

  Future<CatalogListResult<SubcategoryModel>> getSubcategories(
    int categoryId, {
    CatalogListQuery query = const CatalogListQuery(),
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.subcategoriesByCategory(categoryId),
      queryParameters: query.toQueryParameters(),
    );
    return _parseCatalogList(
      response.data,
      listKey: 'subcategories',
      fromJson: SubcategoryModel.fromJson,
    );
  }

  Future<SubcategoryModel> createSubcategory(CreateSubcategoryRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.subcategories,
      data: request.toJson(),
    );
    return _parseSingle(response.data, 'subcategory', SubcategoryModel.fromJson);
  }

  Future<SubcategoryModel> updateSubcategory(
    int id,
    UpdateCategoryRequest request,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.subcategory(id),
      data: request.toJson(),
    );
    return _parseSingle(response.data, 'subcategory', SubcategoryModel.fromJson);
  }

  Future<SubcategoryModel> updateSubcategoryStatus(int id, bool status) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.subcategoryStatus(id),
      data: UpdateStatusRequest(status: status).toJson(),
    );
    return _parseSingle(response.data, 'subcategory', SubcategoryModel.fromJson);
  }

  Future<CatalogListResult<SubSubCategoryModel>> getSubSubCategories(
    int subcategoryId, {
    CatalogListQuery query = const CatalogListQuery(),
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.subSubCategoriesBySubcategory(subcategoryId),
      queryParameters: query.toQueryParameters(),
    );
    return _parseCatalogList(
      response.data,
      listKey: 'subSubCategories',
      fromJson: SubSubCategoryModel.fromJson,
    );
  }

  Future<SubSubCategoryModel> createSubSubCategory(
    CreateSubSubCategoryRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.subSubCategories,
      data: request.toJson(),
    );
    return _parseSingle(
      response.data,
      'subSubCategory',
      SubSubCategoryModel.fromJson,
    );
  }

  Future<SubSubCategoryModel> updateSubSubCategory(
    int id,
    UpdateCategoryRequest request,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.subSubCategory(id),
      data: request.toJson(),
    );
    return _parseSingle(
      response.data,
      'subSubCategory',
      SubSubCategoryModel.fromJson,
    );
  }

  Future<SubSubCategoryModel> updateSubSubCategoryStatus(int id, bool status) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.subSubCategoryStatus(id),
      data: UpdateStatusRequest(status: status).toJson(),
    );
    return _parseSingle(
      response.data,
      'subSubCategory',
      SubSubCategoryModel.fromJson,
    );
  }

  CatalogListResult<T> _parseCatalogList<T>(
    Map<String, dynamic>? json, {
    required String listKey,
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final data = json?['data'] as Map<String, dynamic>?;
    final list = data?[listKey] as List<dynamic>?;
    if (list == null) throw AppException.unknown('Lista vacía o inválida');

    final paginationJson = data?['pagination'] as Map<String, dynamic>?;

    return CatalogListResult(
      items: list.map((e) => fromJson(e as Map<String, dynamic>)).toList(),
      pagination: paginationJson == null
          ? null
          : CatalogPagination.fromJson(paginationJson),
    );
  }

  List<T> _parseList<T>(
    Map<String, dynamic>? json,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = json?['data'] as Map<String, dynamic>?;
    final list = data?[key] as List<dynamic>?;
    if (list == null) throw AppException.unknown('Lista vacía o inválida');
    return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
  }

  T _parseSingle<T>(
    Map<String, dynamic>? json,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final data = json?['data'] as Map<String, dynamic>?;
    final item = data?[key] as Map<String, dynamic>?;
    if (item == null) throw AppException.unknown('Recurso no encontrado');
    return fromJson(item);
  }
}
