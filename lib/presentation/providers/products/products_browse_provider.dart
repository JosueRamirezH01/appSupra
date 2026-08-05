import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/categories/category_model.dart';
import '../../../data/models/common/pagination_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../models/home_catalog_section.dart';
import '../categories/active_categories_provider.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

part 'products_browse_provider.g.dart';

class ProductsBrowseViewState {
  const ProductsBrowseViewState({
    required this.products,
    required this.pagination,
    required this.selectedSubcategoryId,
    this.search,
    this.searchSuggestions = const [],
    this.isLoadingMore = false,
  });

  final List<ProductPublicModel> products;
  final PaginationModel pagination;
  final int? selectedSubcategoryId;
  final String? search;
  final List<ProductSearchSuggestionModel> searchSuggestions;
  final bool isLoadingMore;

  ProductsBrowseViewState copyWith({
    List<ProductPublicModel>? products,
    PaginationModel? pagination,
    int? selectedSubcategoryId,
    String? search,
    List<ProductSearchSuggestionModel>? searchSuggestions,
    bool? isLoadingMore,
    bool clearSelectedSubcategory = false,
  }) {
    return ProductsBrowseViewState(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      selectedSubcategoryId: clearSelectedSubcategory
          ? null
          : (selectedSubcategoryId ?? this.selectedSubcategoryId),
      search: search ?? this.search,
      searchSuggestions: searchSuggestions ?? this.searchSuggestions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@Riverpod(keepAlive: true)
Future<int?> productCategoryId(ProductCategoryIdRef ref) async {
  final categories = await ref.watch(activeCategoriesProvider.future);
  for (final category in categories) {
    if (category.status && matchesProductCategory(category.name)) {
      return category.id;
    }
  }
  return null;
}

@riverpod
Future<List<SubcategoryModel>> productBrowseSubcategories(
  ProductBrowseSubcategoriesRef ref,
  int categoryId,
) async {
  final result = await ref
      .read(categoriesRepositoryProvider)
      .getSubcategories(categoryId);
  return result.items.where((subcategory) => subcategory.status).toList();
}

@riverpod
class ProductsBrowseController extends _$ProductsBrowseController {
  static const _pageSize = 20;

  int? _selectedSubcategoryId;
  String? _search;

  @override
  Future<ProductsBrowseViewState> build(
    int categoryId, {
    int? initialSubcategoryId,
  }) async {
    await ref.watch(activeClientLocationProvider.future);
    _selectedSubcategoryId = initialSubcategoryId;
    _search = null;
    return _fetchFirstPage(categoryId);
  }

  Future<void> selectSubcategory(int? subcategoryId) async {
    if (_selectedSubcategoryId == subcategoryId) return;

    _selectedSubcategoryId = subcategoryId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFirstPage(categoryId));
  }

  Future<void> search(String? text) async {
    final normalized = text?.trim();
    final nextSearch = normalized == null || normalized.isEmpty
        ? null
        : normalized;
    if (_search == nextSearch) return;

    _search = nextSearch;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFirstPage(categoryId));
  }

  Future<void> clearSearch() async {
    if (_search == null) return;
    _search = null;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFirstPage(categoryId));
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
      final fetched = await _fetchPage(categoryId: categoryId, page: nextPage);

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

  Future<ProductsBrowseViewState> _fetchFirstPage(int categoryId) async {
    final fetched = await _fetchPage(categoryId: categoryId, page: 1);
    return ProductsBrowseViewState(
      products: fetched.products,
      pagination: fetched.pagination,
      selectedSubcategoryId: _selectedSubcategoryId,
      search: _search,
      searchSuggestions: fetched.searchSuggestions,
    );
  }

  Future<
    ({
      List<ProductPublicModel> products,
      PaginationModel pagination,
      List<ProductSearchSuggestionModel> searchSuggestions,
    })
  >
  _fetchPage({required int categoryId, required int page}) async {
    final clientLocation = await ref.read(activeClientLocationProvider.future);
    final result = await ref
        .read(sellersRepositoryProvider)
        .listProducts(
          ProductsQuery(
            page: page,
            limit: _pageSize,
            categoryId: _selectedSubcategoryId == null ? categoryId : null,
            subcategoryId: _selectedSubcategoryId,
            search: _search,
            lat: clientLocation?.lat,
            lng: clientLocation?.lng,
            radiusKm: clientLocation?.radiusKm ?? 15,
          ),
        );

    return (
      products: result.products,
      pagination: result.pagination,
      searchSuggestions: result.searchSuggestions,
    );
  }
}
