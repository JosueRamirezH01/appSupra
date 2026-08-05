import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/common/pagination_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../utils/seller_product_publish_status.dart';
import '../repository_providers.dart';

part 'my_seller_products_provider.g.dart';

class MySellerProductsViewState {
  const MySellerProductsViewState({
    required this.products,
    required this.pagination,
    required this.counts,
    this.isLoadingMore = false,
    this.publishStatus,
  });

  final List<ProductPublicModel> products;
  final PaginationModel pagination;
  final MyProductsCounts counts;
  final bool isLoadingMore;
  final String? publishStatus;

  MySellerProductsViewState copyWith({
    List<ProductPublicModel>? products,
    PaginationModel? pagination,
    MyProductsCounts? counts,
    bool? isLoadingMore,
    String? publishStatus,
    bool clearPublishStatus = false,
  }) {
    return MySellerProductsViewState(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      counts: counts ?? this.counts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      publishStatus: clearPublishStatus
          ? null
          : (publishStatus ?? this.publishStatus),
    );
  }
}

/// Preview del home vendedor (carrusel): solo 8 ítems + conteos globales.
@riverpod
Future<MyProductsListResult> mySellerProductsPreview(
  MySellerProductsPreviewRef ref,
) {
  return ref.read(sellersRepositoryProvider).listMyProducts(
        const MyProductsQuery(page: 1, limit: 8),
      );
}

/// Listado paginado de "Mis productos".
@riverpod
class MySellerProductsController extends _$MySellerProductsController {
  static const pageSize = 20;

  @override
  Future<MySellerProductsViewState> build() async {
    return _fetchFirstPage(publishStatus: null);
  }

  Future<void> refresh() async {
    final selected = state.valueOrNull?.publishStatus;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchFirstPage(publishStatus: selected),
    );
  }

  Future<void> setPublishStatus(String? publishStatus) async {
    final current = state.valueOrNull;
    if (current != null && current.publishStatus == publishStatus) return;

    if (current != null) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    }

    try {
      final next = await _fetchFirstPage(publishStatus: publishStatus);
      state = AsyncValue.data(next);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
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
      final fetched = await ref.read(sellersRepositoryProvider).listMyProducts(
            MyProductsQuery(
              page: nextPage,
              limit: pageSize,
              publishStatus: current.publishStatus,
            ),
          );

      state = AsyncValue.data(
        current.copyWith(
          products: [...current.products, ...fetched.products],
          pagination: fetched.pagination,
          counts: fetched.counts,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<MySellerProductsViewState> _fetchFirstPage({
    required String? publishStatus,
  }) async {
    final fetched = await ref.read(sellersRepositoryProvider).listMyProducts(
          MyProductsQuery(
            page: 1,
            limit: pageSize,
            publishStatus: publishStatus,
          ),
        );

    return MySellerProductsViewState(
      products: fetched.products,
      pagination: fetched.pagination,
      counts: fetched.counts,
      publishStatus: publishStatus,
    );
  }
}

/// Mapa compatible con chips/summary del panel.
Map<String, int> myProductsCountsAsFilterMap(MyProductsCounts counts) {
  return {
    SellerProductPublishFilter.published: counts.published,
    SellerProductPublishFilter.unpublished: counts.unpublished,
  };
}
