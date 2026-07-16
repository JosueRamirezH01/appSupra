import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/categories/category_model.dart';
import '../../../data/models/common/pagination_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../models/home_catalog_section.dart';
import '../location/client_location_provider.dart';
import '../repository_providers.dart';

part 'professionals_browse_provider.g.dart';

class ProfessionalsBrowseViewState {
  const ProfessionalsBrowseViewState({
    required this.technicians,
    required this.pagination,
    required this.selectedSubcategoryId,
    required this.prioritizeSubSubCategoryId,
    this.search,
    this.isLoadingMore = false,
  });

  final List<TechnicianPublicModel> technicians;
  final PaginationModel pagination;
  final int? selectedSubcategoryId;
  final int? prioritizeSubSubCategoryId;
  final String? search;
  final bool isLoadingMore;

  ProfessionalsBrowseViewState copyWith({
    List<TechnicianPublicModel>? technicians,
    PaginationModel? pagination,
    int? selectedSubcategoryId,
    int? prioritizeSubSubCategoryId,
    String? search,
    bool? isLoadingMore,
    bool clearSelectedSubcategory = false,
    bool clearPrioritizeSubSubCategory = false,
  }) {
    return ProfessionalsBrowseViewState(
      technicians: technicians ?? this.technicians,
      pagination: pagination ?? this.pagination,
      selectedSubcategoryId: clearSelectedSubcategory
          ? null
          : (selectedSubcategoryId ?? this.selectedSubcategoryId),
      prioritizeSubSubCategoryId: clearPrioritizeSubSubCategory
          ? null
          : (prioritizeSubSubCategoryId ?? this.prioritizeSubSubCategoryId),
      search: search ?? this.search,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

@Riverpod(keepAlive: true)
Future<int?> professionCategoryId(ProfessionCategoryIdRef ref) async {
  final categories = await ref.read(categoriesRepositoryProvider).getCategories();
  for (final category in categories) {
    if (category.status && matchesProfessionCategory(category.name)) {
      return category.id;
    }
  }
  return null;
}

@riverpod
Future<List<SubcategoryModel>> professionBrowseSubcategories(
  ProfessionBrowseSubcategoriesRef ref,
  int categoryId,
) async {
  final result =
      await ref.read(categoriesRepositoryProvider).getSubcategories(categoryId);
  return result.items.where((subcategory) => subcategory.status).toList();
}

@riverpod
class ProfessionalsBrowseController extends _$ProfessionalsBrowseController {
  static const _pageSize = 20;

  int? _selectedSubcategoryId;
  int? _prioritizeSubSubCategoryId;
  String? _search;

  @override
  Future<ProfessionalsBrowseViewState> build(int categoryId) async {
    _selectedSubcategoryId = null;
    _prioritizeSubSubCategoryId = null;
    _search = null;
    return _fetchFirstPage(categoryId);
  }

  Future<void> selectSubcategory(int? subcategoryId) async {
    if (_selectedSubcategoryId == subcategoryId &&
        _prioritizeSubSubCategoryId == null) {
      return;
    }

    _selectedSubcategoryId = subcategoryId;
    _prioritizeSubSubCategoryId = null;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFirstPage(categoryId));
  }

  Future<void> selectPrioritizeSubSubCategory(int? subSubCategoryId) async {
    if (_prioritizeSubSubCategoryId == subSubCategoryId) return;

    _prioritizeSubSubCategoryId = subSubCategoryId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchFirstPage(categoryId));
  }

  Future<void> search(String? text) async {
    final normalized = text?.trim();
    final nextSearch =
        normalized == null || normalized.isEmpty ? null : normalized;
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

  Future<void> refresh() async {
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
      final fetched = await _fetchPage(
        categoryId: categoryId,
        page: nextPage,
      );

      state = AsyncValue.data(
        current.copyWith(
          technicians: [...current.technicians, ...fetched.technicians],
          pagination: fetched.pagination,
          isLoadingMore: false,
        ),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<ProfessionalsBrowseViewState> _fetchFirstPage(int categoryId) async {
    final fetched = await _fetchPage(categoryId: categoryId, page: 1);
    return ProfessionalsBrowseViewState(
      technicians: fetched.technicians,
      pagination: fetched.pagination,
      selectedSubcategoryId: _selectedSubcategoryId,
      prioritizeSubSubCategoryId: _prioritizeSubSubCategoryId,
      search: _search,
    );
  }

  Future<({List<TechnicianPublicModel> technicians, PaginationModel pagination})>
      _fetchPage({
    required int categoryId,
    required int page,
  }) async {
    final clientLocation = await ref.read(activeClientLocationProvider.future);

    final query = TechniciansQuery(
      page: page,
      limit: _pageSize,
      categoryId: _selectedSubcategoryId == null ? categoryId : null,
      subcategoryId: _selectedSubcategoryId,
      prioritizeSubSubCategoryId: _prioritizeSubSubCategoryId,
      search: _search,
      lat: clientLocation?.lat,
      lng: clientLocation?.lng,
      radiusKm: clientLocation?.radiusKm ?? 15,
    );

    return ref.read(techniciansRepositoryProvider).getTechnicians(query);
  }
}
