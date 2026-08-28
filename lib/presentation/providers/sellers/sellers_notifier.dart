import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../models/home_catalog_section.dart';
import '../../providers/categories/active_categories_provider.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

part 'sellers_notifier.g.dart';

@riverpod
class ProductsList extends _$ProductsList {
  String? _search;

  @override
  Future<ProductsListResult> build() async {
    final clientLocation = await ref.watch(activeClientLocationProvider.future);
    return ref.read(sellersRepositoryProvider).listProducts(
          ProductsQuery(
            page: 1,
            limit: 10,
            search: _search,
            lat: clientLocation?.lat,
            lng: clientLocation?.lng,
            radiusKm: clientLocation?.radiusKm ?? 15,
          ),
        );
  }

  Future<void> search(String? query) async {
    _search = query;
    ref.invalidateSelf();
    await future;
  }
}

@riverpod
Future<ProductPublicModel> productDetail(ProductDetailRef ref, int productId) {
  return ref.read(sellersRepositoryProvider).getProduct(productId);
}

@riverpod
Future<SellerPublicModel> sellerPublicProfile(
  SellerPublicProfileRef ref,
  int userId,
) {
  return ref.read(sellersRepositoryProvider).getSeller(userId);
}

@riverpod
Future<SellerApplicationModel> mySellerApplication(MySellerApplicationRef ref) {
  return ref.read(sellersRepositoryProvider).getMyApplication();
}

@riverpod
Future<List<SubcategoryModel>> sellerProductSubcategories(
  SellerProductSubcategoriesRef ref,
) async {
  final categories = await ref.watch(activeCategoriesProvider.future);
  CategoryModel? category;
  for (final item in categories) {
    if (item.status && matchesProductCategory(item.name)) {
      category = item;
      break;
    }
  }
  if (category == null) return const [];

  final result = await ref.read(categoriesRepositoryProvider).getSubcategories(
        category.id,
      );
  return result.items
      .where(
        (item) =>
            item.status && CatalogConstants.isClientVisibleSubcategory(item.name),
      )
      .toList();
}
