import '../../domain/repositories/categories_repository.dart';
import '../datasources/categories_remote_datasource.dart';
import '../models/categories/catalog_list_result.dart';
import '../models/categories/category_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  CategoriesRepositoryImpl(this._remote);

  final CategoriesRemoteDataSource _remote;

  @override
  Future<List<CategoryModel>> getCategories({bool includeInactive = false}) =>
      _remote.getCategories(includeInactive: includeInactive);

  @override
  Future<CategoryModel> createCategory(CreateCategoryRequest request) =>
      _remote.createCategory(request);

  @override
  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest request) =>
      _remote.updateCategory(id, request);

  @override
  Future<CategoryModel> updateCategoryStatus(int id, bool status) =>
      _remote.updateCategoryStatus(id, status);

  @override
  Future<CatalogListResult<SubcategoryModel>> getSubcategories(
    int categoryId, {
    CatalogListQuery query = const CatalogListQuery(),
  }) =>
      _remote.getSubcategories(categoryId, query: query);

  @override
  Future<SubcategoryModel> createSubcategory(CreateSubcategoryRequest request) =>
      _remote.createSubcategory(request);

  @override
  Future<SubcategoryModel> updateSubcategory(
    int id,
    UpdateCategoryRequest request,
  ) =>
      _remote.updateSubcategory(id, request);

  @override
  Future<SubcategoryModel> updateSubcategoryStatus(int id, bool status) =>
      _remote.updateSubcategoryStatus(id, status);

  @override
  Future<CatalogListResult<SubSubCategoryModel>> getSubSubCategories(
    int subcategoryId, {
    CatalogListQuery query = const CatalogListQuery(),
  }) =>
      _remote.getSubSubCategories(subcategoryId, query: query);

  @override
  Future<SubSubCategoryModel> createSubSubCategory(
    CreateSubSubCategoryRequest request,
  ) =>
      _remote.createSubSubCategory(request);

  @override
  Future<SubSubCategoryModel> updateSubSubCategory(
    int id,
    UpdateCategoryRequest request,
  ) =>
      _remote.updateSubSubCategory(id, request);

  @override
  Future<SubSubCategoryModel> updateSubSubCategoryStatus(int id, bool status) =>
      _remote.updateSubSubCategoryStatus(id, status);
}
