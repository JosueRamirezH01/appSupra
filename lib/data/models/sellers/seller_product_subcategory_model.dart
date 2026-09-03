import '../categories/category_model.dart';

/// Rubro de producto para el vendedor: catálogo global o propio.
class SellerProductSubcategoryModel {
  const SellerProductSubcategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    this.suggestions = const [],
    this.status = true,
    this.sortOrder = 1,
    this.ownership = 'catalog',
    this.sellerId,
  });

  factory SellerProductSubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SellerProductSubcategoryModel(
      id: (json['id'] as num).toInt(),
      name: (json['name'] as String?)?.trim() ?? '',
      categoryId: (json['categoryId'] as num).toInt(),
      categoryName: (json['categoryName'] as String?)?.trim() ?? '',
      suggestions: parseProductSubcategorySuggestions(json['suggestions']),
      status: json['status'] as bool? ?? true,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 1,
      ownership: (json['ownership'] as String?)?.trim() == 'seller'
          ? 'seller'
          : 'catalog',
      sellerId: (json['sellerId'] as num?)?.toInt(),
    );
  }

  final int id;
  final String name;
  final int categoryId;
  final String categoryName;
  final List<String> suggestions;
  final bool status;
  final int sortOrder;
  final String ownership;
  final int? sellerId;

  bool get isSellerOwned => ownership == 'seller';
}

/// Tope alineado con el backend (`SELLER_CUSTOM_PRODUCT_SUBCATEGORY_LIMIT`).
const int kSellerCustomProductSubcategoryLimit = 5;
