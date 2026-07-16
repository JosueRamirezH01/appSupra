import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/common/pagination_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../repository_providers.dart';

part 'seller_catalog_provider.g.dart';

class SellerCatalogViewState {
  const SellerCatalogViewState({
    required this.products,
    required this.pagination,
    this.isLoadingMore = false,
  });

  final List<ProductPublicModel> products;
  final PaginationModel pagination;
  final bool isLoadingMore;

  SellerCatalogViewState copyWith({
    List<ProductPublicModel>? products,
    PaginationModel? pagination,
    bool? isLoadingMore,
  }) {
    return SellerCatalogViewState(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@riverpod
class SellerCatalogController extends _$SellerCatalogController {
  static const _pageSize = 20;

  @override
  Future<SellerCatalogViewState> build(int sellerId) async {
    return _fetchFirstPage(sellerId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFirstPage(sellerId));
  }

  Future<void> loadNextPage() async {
    final current = state.valueOrNull;
    if (current == null ||
        current.isLoadingMore ||
        current.pagination.page >= current.pagination.totalPages) {
      return;
    }

    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.pagination.page + 1;
      final fetched = await _fetchPage(sellerId: sellerId, page: nextPage);

      state = AsyncValue.data(
        current.copyWith(
          products: [...current.products, ...fetched.products],
          pagination: fetched.pagination,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<SellerCatalogViewState> _fetchFirstPage(int sellerId) async {
    final fetched = await _fetchPage(sellerId: sellerId, page: 1);
    return SellerCatalogViewState(
      products: fetched.products,
      pagination: fetched.pagination,
    );
  }

  Future<
      ({
        List<ProductPublicModel> products,
        PaginationModel pagination,
      })> _fetchPage({
    required int sellerId,
    required int page,
  }) async {
    final result = await ref.read(sellersRepositoryProvider).listProducts(
          ProductsQuery(
            sellerId: sellerId,
            page: page,
            limit: _pageSize,
          ),
        );

    return (
      products: result.products,
      pagination: result.pagination,
    );
  }
}
