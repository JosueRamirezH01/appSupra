import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/common/pagination_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../repository_providers.dart';

part 'seller_catalog_provider.g.dart';

class SellerCatalogFacet {
  const SellerCatalogFacet({
    required this.subcategoryId,
    required this.name,
    this.count = 0,
  });

  final int subcategoryId;
  final String name;
  final int count;

  SellerCatalogFacet copyWith({
    String? name,
    int? count,
  }) {
    return SellerCatalogFacet(
      subcategoryId: subcategoryId,
      name: name ?? this.name,
      count: count ?? this.count,
    );
  }
}

class SellerCatalogViewState {
  const SellerCatalogViewState({
    required this.products,
    required this.pagination,
    this.isLoadingMore = false,
    this.selectedSubcategoryId,
    this.facets = const [],
    this.allProductsTotal = 0,
  });

  final List<ProductPublicModel> products;
  final PaginationModel pagination;
  final bool isLoadingMore;
  final int? selectedSubcategoryId;
  final List<SellerCatalogFacet> facets;
  final int allProductsTotal;

  SellerCatalogViewState copyWith({
    List<ProductPublicModel>? products,
    PaginationModel? pagination,
    bool? isLoadingMore,
    int? selectedSubcategoryId,
    bool clearSelectedSubcategory = false,
    List<SellerCatalogFacet>? facets,
    int? allProductsTotal,
  }) {
    return SellerCatalogViewState(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedSubcategoryId: clearSelectedSubcategory
          ? null
          : (selectedSubcategoryId ?? this.selectedSubcategoryId),
      facets: facets ?? this.facets,
      allProductsTotal: allProductsTotal ?? this.allProductsTotal,
    );
  }
}

@riverpod
class SellerCatalogController extends _$SellerCatalogController {
  static const _pageSize = 50;

  @override
  Future<SellerCatalogViewState> build(int sellerId) async {
    return _fetchFirstPage(sellerId, subcategoryId: null);
  }

  Future<void> refresh() async {
    final selected = state.valueOrNull?.selectedSubcategoryId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _fetchFirstPage(sellerId, subcategoryId: selected),
    );
  }

  Future<void> setSubcategoryFilter(int? subcategoryId) async {
    final current = state.valueOrNull;
    if (current != null && current.selectedSubcategoryId == subcategoryId) {
      return;
    }

    if (current != null) {
      state = AsyncValue.data(current.copyWith(isLoadingMore: true));
    }

    try {
      final next = await _fetchFirstPage(
        sellerId,
        subcategoryId: subcategoryId,
        previous: current,
      );
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
      final fetched = await _fetchPage(
        sellerId: sellerId,
        page: nextPage,
        subcategoryId: current.selectedSubcategoryId,
      );

      final mergedProducts = [...current.products, ...fetched.products];
      final facets = current.selectedSubcategoryId == null
          ? _addFacetCounts(
              _upsertFacetNames(current.facets, fetched.products),
              fetched.products,
            )
          : current.facets;

      state = AsyncValue.data(
        current.copyWith(
          products: mergedProducts,
          pagination: fetched.pagination,
          isLoadingMore: false,
          facets: facets,
          allProductsTotal: current.selectedSubcategoryId == null
              ? fetched.pagination.total
              : current.allProductsTotal,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<SellerCatalogViewState> _fetchFirstPage(
    int sellerId, {
    required int? subcategoryId,
    SellerCatalogViewState? previous,
  }) async {
    final fetched = await _fetchPage(
      sellerId: sellerId,
      page: 1,
      subcategoryId: subcategoryId,
    );

    late final List<SellerCatalogFacet> facets;
    if (subcategoryId == null) {
      // Reinicia conteos con la 1ª página; conserva nombres ya descubiertos.
      final named = _upsertFacetNames(
        previous?.facets ?? const [],
        fetched.products,
      );
      facets = _addFacetCounts(
        named.map((f) => f.copyWith(count: 0)).toList(),
        fetched.products,
      );
    } else {
      var next = _upsertFacetNames(
        previous?.facets ?? const [],
        fetched.products,
      );
      if (next.isEmpty) {
        next = _upsertFacetNames(const [], fetched.products);
      }
      facets = next
          .map(
            (facet) => facet.subcategoryId == subcategoryId
                ? facet.copyWith(count: fetched.pagination.total)
                : facet,
          )
          .toList();
    }

    return SellerCatalogViewState(
      products: fetched.products,
      pagination: fetched.pagination,
      selectedSubcategoryId: subcategoryId,
      facets: facets,
      allProductsTotal: subcategoryId == null
          ? fetched.pagination.total
          : (previous?.allProductsTotal ?? fetched.pagination.total),
    );
  }

  Future<
      ({
        List<ProductPublicModel> products,
        PaginationModel pagination,
      })> _fetchPage({
    required int sellerId,
    required int page,
    int? subcategoryId,
  }) async {
    final result = await ref.read(sellersRepositoryProvider).listProducts(
          ProductsQuery(
            sellerId: sellerId,
            subcategoryId: subcategoryId,
            page: page,
            limit: _pageSize,
          ),
        );

    return (
      products: result.products,
      pagination: result.pagination,
    );
  }

  List<SellerCatalogFacet> _upsertFacetNames(
    List<SellerCatalogFacet> existing,
    List<ProductPublicModel> products,
  ) {
    final byId = <int, SellerCatalogFacet>{
      for (final facet in existing) facet.subcategoryId: facet,
    };

    for (final product in products) {
      if (product.subcategoryId <= 0) continue;
      final name = product.subcategoryName.trim().isEmpty
          ? 'Categoría'
          : product.subcategoryName.trim();
      final current = byId[product.subcategoryId];
      byId[product.subcategoryId] = current == null
          ? SellerCatalogFacet(
              subcategoryId: product.subcategoryId,
              name: name,
            )
          : current.copyWith(name: name);
    }

    final list = byId.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  List<SellerCatalogFacet> _addFacetCounts(
    List<SellerCatalogFacet> existing,
    List<ProductPublicModel> products,
  ) {
    final byId = <int, SellerCatalogFacet>{
      for (final facet in existing) facet.subcategoryId: facet,
    };

    for (final product in products) {
      if (product.subcategoryId <= 0) continue;
      final current = byId[product.subcategoryId];
      if (current == null) {
        final name = product.subcategoryName.trim().isEmpty
            ? 'Categoría'
            : product.subcategoryName.trim();
        byId[product.subcategoryId] = SellerCatalogFacet(
          subcategoryId: product.subcategoryId,
          name: name,
          count: 1,
        );
      } else {
        byId[product.subcategoryId] =
            current.copyWith(count: current.count + 1);
      }
    }

    final list = byId.values.toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }
}
