import '../../data/models/categories/category_model.dart';

class HomeCatalogSection {
  const HomeCatalogSection({
    required this.categoryId,
    required this.title,
    required this.subcategories,
    this.totalSubcategories,
  });

  final int categoryId;
  final String title;
  final List<SubcategoryModel> subcategories;
  final int? totalSubcategories;
}

bool matchesProfessionCategory(String name) {
  final normalized = name.toLowerCase();
  return normalized.contains('profes') || normalized == 'profession';
}

bool matchesProductCategory(String name) {
  final normalized = name.toLowerCase();
  return normalized.contains('product');
}
