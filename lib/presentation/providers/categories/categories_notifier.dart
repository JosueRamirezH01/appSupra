import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../data/models/categories/catalog_list_result.dart';
import '../../../data/models/categories/category_model.dart';
import '../../models/home_catalog_section.dart';
import '../repository_providers.dart';

part 'categories_notifier.g.dart';

@riverpod
class CategoriesList extends _$CategoriesList {
  @override
  Future<List<CategoryModel>> build({bool includeInactive = false}) {
    return ref
        .read(categoriesRepositoryProvider)
        .getCategories(includeInactive: includeInactive);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref
          .read(categoriesRepositoryProvider)
          .getCategories(includeInactive: includeInactive),
    );
  }

  Future<void> create(String name, {String? imageUrl}) async {
    await ref
        .read(categoriesRepositoryProvider)
        .createCategory(CreateCategoryRequest(name: name, imageUrl: imageUrl));
    ref.invalidateSelf();
  }

  Future<void> updateCategory(int id, String name, {String? imageUrl}) async {
    await ref
        .read(categoriesRepositoryProvider)
        .updateCategory(
          id,
          UpdateCategoryRequest(name: name, imageUrl: imageUrl),
        );
    ref.invalidateSelf();
  }

  Future<void> toggleStatus(int id, bool status) async {
    await ref.read(categoriesRepositoryProvider).updateCategoryStatus(id, status);
    ref.invalidateSelf();
  }
}

@riverpod
class SubcategoriesList extends _$SubcategoriesList {
  @override
  Future<List<SubcategoryModel>> build(int categoryId) async {
    final result = await ref
        .read(categoriesRepositoryProvider)
        .getSubcategories(
          categoryId,
          query: CatalogListQuery(includeInactive: false),
        );
    return result.items;
  }

  Future<void> create(String name, {String? imageUrl}) async {
    await ref.read(categoriesRepositoryProvider).createSubcategory(
          CreateSubcategoryRequest(
            name: name,
            categoryId: categoryId,
            imageUrl: imageUrl,
          ),
        );
    ref.invalidateSelf();
  }

  Future<void> updateSubcategory(int id, String name, {String? imageUrl}) async {
    await ref
        .read(categoriesRepositoryProvider)
        .updateSubcategory(
          id,
          UpdateCategoryRequest(name: name, imageUrl: imageUrl),
        );
    ref.invalidateSelf();
  }

  Future<void> toggleStatus(int id, bool status) async {
    await ref.read(categoriesRepositoryProvider).updateSubcategoryStatus(id, status);
    ref.invalidateSelf();
  }
}

@riverpod
class SubSubCategoriesList extends _$SubSubCategoriesList {
  @override
  Future<List<SubSubCategoryModel>> build(int subcategoryId) async {
    final result = await ref
        .read(categoriesRepositoryProvider)
        .getSubSubCategories(subcategoryId);
    return result.items;
  }

  Future<void> create(String name, {String? imageUrl}) async {
    await ref.read(categoriesRepositoryProvider).createSubSubCategory(
          CreateSubSubCategoryRequest(
            name: name,
            subcategoryId: subcategoryId,
            imageUrl: imageUrl,
          ),
        );
    ref.invalidateSelf();
  }

  Future<void> updateSubSubCategory(int id, String name, {String? imageUrl}) async {
    await ref
        .read(categoriesRepositoryProvider)
        .updateSubSubCategory(
          id,
          UpdateCategoryRequest(name: name, imageUrl: imageUrl),
        );
    ref.invalidateSelf();
  }

  Future<void> toggleStatus(int id, bool status) async {
    await ref
        .read(categoriesRepositoryProvider)
        .updateSubSubCategoryStatus(id, status);
    ref.invalidateSelf();
  }
}

@Riverpod(keepAlive: true)
Future<List<SubcategoryModel>> allActiveSubcategories(
  AllActiveSubcategoriesRef ref,
) async {
  final repo = ref.read(categoriesRepositoryProvider);
  final categories = await repo.getCategories();
  final results = <SubcategoryModel>[];

  for (final category in categories.where((c) => c.status)) {
    final subs = await repo.getSubcategories(category.id);
    results.addAll(subs.items.where((s) => s.status));
  }

  return results;
}

@Riverpod(keepAlive: true)
Future<List<SubcategoryModel>> professionSubcategories(
  ProfessionSubcategoriesRef ref,
) async {
  final repo = ref.read(categoriesRepositoryProvider);
  final categories = await repo.getCategories();

  CategoryModel? professionCategory;
  for (final category in categories) {
    if (category.status && matchesProfessionCategory(category.name)) {
      professionCategory = category;
      break;
    }
  }

  if (professionCategory == null) return [];

  final subs = await repo.getSubcategories(professionCategory.id);
  return subs.items
      .where(
        (s) => s.status && CatalogConstants.isClientVisibleSubcategory(s.name),
      )
      .toList();
}
