import '../../data/models/categories/catalog_list_result.dart';
import '../../data/models/categories/category_model.dart';

abstract class CategoriesRepository {
  Future<List<CategoryModel>> getCategories({bool includeInactive});
  Future<CategoryModel> createCategory(CreateCategoryRequest request);
  Future<CategoryModel> updateCategory(int id, UpdateCategoryRequest request);
  Future<CategoryModel> updateCategoryStatus(int id, bool status);
  Future<CatalogListResult<SubcategoryModel>> getSubcategories(
    int categoryId, {
    CatalogListQuery query = const CatalogListQuery(),
  });
  Future<SubcategoryModel> createSubcategory(CreateSubcategoryRequest request);
  Future<SubcategoryModel> updateSubcategory(int id, UpdateCategoryRequest request);
  Future<SubcategoryModel> updateSubcategoryStatus(int id, bool status);
  Future<CatalogListResult<SubSubCategoryModel>> getSubSubCategories(
    int subcategoryId, {
    CatalogListQuery query = const CatalogListQuery(),
  });
  Future<SubSubCategoryModel> createSubSubCategory(CreateSubSubCategoryRequest request);
  Future<SubSubCategoryModel> updateSubSubCategory(int id, UpdateCategoryRequest request);
  Future<SubSubCategoryModel> updateSubSubCategoryStatus(int id, bool status);
}
