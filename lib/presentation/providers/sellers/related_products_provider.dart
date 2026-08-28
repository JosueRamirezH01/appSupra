import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../data/models/sellers/product_model.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

/// Materiales agrupados por rubro para el oficio (máx. 3 rieles, 4 productos c/u).
final relatedProductsForProfessionProvider = FutureProvider.autoDispose
    .family<RelatedProductsResult, int>((ref, professionSubcategoryId) async {
  final clientLocation = await ref.watch(activeClientLocationProvider.future);
  return ref.read(sellersRepositoryProvider).listRelatedProducts(
        RelatedProductsQuery(
          professionSubcategoryId: professionSubcategoryId,
          limit: 4,
          groupsLimit: 3,
          lat: clientLocation?.lat,
          lng: clientLocation?.lng,
          radiusKm: clientLocation?.radiusKm ?? 15,
        ),
      );
});

/// Materiales destacados para el servicio (sub-sub). Un carrusel de hasta 6.
final relatedProductsForSubSubProvider = FutureProvider.autoDispose
    .family<RelatedProductsResult, int>((ref, professionSubSubCategoryId) async {
  final clientLocation = await ref.watch(activeClientLocationProvider.future);
  return ref.read(sellersRepositoryProvider).listRelatedProductsBySubSub(
        RelatedProductsBySubSubQuery(
          professionSubSubCategoryId: professionSubSubCategoryId,
          view: 'carousel',
          limit: CatalogConstants.relatedMaterialsPreviewCount,
          groupsLimit: 3,
          lat: clientLocation?.lat,
          lng: clientLocation?.lng,
          radiusKm: clientLocation?.radiusKm ?? 15,
        ),
      );
});

class RelatedMaterialsCatalogState {
  const RelatedMaterialsCatalogState({
    required this.products,
    required this.page,
    required this.hasMore,
    required this.total,
    this.isLoadingMore = false,
  });

  final List<ProductPublicModel> products;
  final int page;
  final bool hasMore;
  final int total;
  final bool isLoadingMore;
}

class RelatedMaterialsCatalogNotifier
    extends StateNotifier<AsyncValue<RelatedMaterialsCatalogState>> {
  RelatedMaterialsCatalogNotifier(this._ref, this._professionSubSubCategoryId)
      : super(const AsyncValue.loading()) {
    _load(page: 1, append: false);
  }

  final Ref _ref;
  final int _professionSubSubCategoryId;
  static const _pageSize = 20;
  bool _loadingMore = false;

  Future<void> retry() => _load(page: 1, append: false);

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || _loadingMore) return;
    await _load(page: current.page + 1, append: true);
  }

  Future<void> _load({required int page, required bool append}) async {
    if (append) {
      _loadingMore = true;
      final current = state.valueOrNull;
      if (current != null) {
        state = AsyncValue.data(RelatedMaterialsCatalogState(
          products: current.products,
          page: current.page,
          hasMore: current.hasMore,
          total: current.total,
          isLoadingMore: true,
        ));
      }
    } else {
      state = const AsyncValue.loading();
    }

    try {
      final clientLocation = await _ref.read(activeClientLocationProvider.future);
      final result = await _ref.read(sellersRepositoryProvider).listRelatedProductsBySubSub(
            RelatedProductsBySubSubQuery(
              professionSubSubCategoryId: _professionSubSubCategoryId,
              view: 'catalog',
              page: page,
              limit: _pageSize,
              lat: clientLocation?.lat,
              lng: clientLocation?.lng,
              radiusKm: clientLocation?.radiusKm ?? 15,
            ),
          );
      final previous = append ? (state.valueOrNull?.products ?? const []) : const <ProductPublicModel>[];
      final pagination = result.pagination;
      state = AsyncValue.data(
        RelatedMaterialsCatalogState(
          products: [...previous, ...result.products],
          page: pagination?.page ?? page,
          hasMore: result.hasMore,
          total: result.total,
        ),
      );
    } catch (error, stackTrace) {
      if (append) {
        final current = state.valueOrNull;
        if (current != null) {
          state = AsyncValue.data(
            RelatedMaterialsCatalogState(
              products: current.products,
              page: current.page,
              hasMore: current.hasMore,
              total: current.total,
            ),
          );
        }
      } else {
        state = AsyncValue.error(error, stackTrace);
      }
    } finally {
      _loadingMore = false;
    }
  }
}

final relatedMaterialsCatalogProvider = StateNotifierProvider.autoDispose
    .family<RelatedMaterialsCatalogNotifier, AsyncValue<RelatedMaterialsCatalogState>, int>(
  (ref, professionSubSubCategoryId) =>
      RelatedMaterialsCatalogNotifier(ref, professionSubSubCategoryId),
);
