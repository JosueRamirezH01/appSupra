import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../data/models/sellers/product_model.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

/// Isla del home: hasta 6 ofertas, mayor descuento primero.
final homeProductOffersProvider =
    FutureProvider.autoDispose<ProductOffersResult>((ref) async {
  final clientLocation = await ref.watch(activeClientLocationProvider.future);
  return ref.read(sellersRepositoryProvider).listProductOffers(
        ProductOffersQuery(
          view: 'carousel',
          page: 1,
          limit: CatalogConstants.homeOffersPreviewCount,
          lat: clientLocation?.lat,
          lng: clientLocation?.lng,
          radiusKm: clientLocation?.radiusKm ?? 15,
        ),
      );
});

class ProductOffersCatalogState {
  const ProductOffersCatalogState({
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

class ProductOffersCatalogNotifier
    extends StateNotifier<AsyncValue<ProductOffersCatalogState>> {
  ProductOffersCatalogNotifier(this._ref) : super(const AsyncValue.loading()) {
    _load(page: 1, append: false);
  }

  final Ref _ref;
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
        state = AsyncValue.data(
          ProductOffersCatalogState(
            products: current.products,
            page: current.page,
            hasMore: current.hasMore,
            total: current.total,
            isLoadingMore: true,
          ),
        );
      }
    } else {
      state = const AsyncValue.loading();
    }

    try {
      final clientLocation = await _ref.read(activeClientLocationProvider.future);
      final result = await _ref.read(sellersRepositoryProvider).listProductOffers(
            ProductOffersQuery(
              view: 'catalog',
              page: page,
              limit: _pageSize,
              lat: clientLocation?.lat,
              lng: clientLocation?.lng,
              radiusKm: clientLocation?.radiusKm ?? 15,
            ),
          );
      final previous =
          append ? (state.valueOrNull?.products ?? const []) : const <ProductPublicModel>[];
      final pagination = result.pagination;
      state = AsyncValue.data(
        ProductOffersCatalogState(
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
            ProductOffersCatalogState(
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

final productOffersCatalogProvider = StateNotifierProvider.autoDispose<
    ProductOffersCatalogNotifier, AsyncValue<ProductOffersCatalogState>>(
  ProductOffersCatalogNotifier.new,
);
