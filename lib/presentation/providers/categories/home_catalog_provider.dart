import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../data/models/categories/catalog_list_result.dart';
import '../../../data/models/categories/category_model.dart';
import '../../models/home_catalog_section.dart';
import '../repository_providers.dart';

part 'home_catalog_provider.g.dart';

typedef HomeCatalogSections = ({
  HomeCatalogSection? professions,
  HomeCatalogSection? products,
});

@Riverpod(keepAlive: true)
Future<HomeCatalogSections> homeCatalogSections(HomeCatalogSectionsRef ref) async {
  final repo = ref.read(categoriesRepositoryProvider);
  final categories = await repo.getCategories();

  Future<HomeCatalogSection?> buildSection({
    required bool Function(String name) matcher,
    required String title,
    int? fetchLimit,
  }) async {
    CategoryModel? category;
    for (final item in categories) {
      if (item.status && matcher(item.name)) {
        category = item;
        break;
      }
    }

    if (category == null) return null;

    final result = await repo.getSubcategories(
      category.id,
      query: fetchLimit == null
          ? const CatalogListQuery()
          : CatalogListQuery(limit: fetchLimit),
    );
    final active = result.items
        .where((s) => s.status && CatalogConstants.isClientVisibleSubcategory(s.name))
        .toList();

    if (active.isEmpty) return null;

    return HomeCatalogSection(
      categoryId: category.id,
      title: title,
      subcategories: active,
      totalSubcategories: result.pagination?.total ?? active.length,
    );
  }

  final sections = await Future.wait([
    buildSection(
      matcher: matchesProfessionCategory,
      title: 'Profesionales',
    ),
    buildSection(
      matcher: matchesProductCategory,
      title: 'Productos',
      fetchLimit: CatalogConstants.homePreviewFetchLimit,
    ),
  ]);

  return (professions: sections[0], products: sections[1]);
}

@riverpod
Future<List<SubcategoryModel>> exploreSubcategories(
  ExploreSubcategoriesRef ref,
  int categoryId,
) async {
  final repo = ref.read(categoriesRepositoryProvider);
  final result = await repo.getSubcategories(categoryId);
  return result.items
      .where((s) => s.status && CatalogConstants.isClientVisibleSubcategory(s.name))
      .toList();
}
