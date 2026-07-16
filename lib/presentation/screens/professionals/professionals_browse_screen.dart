import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_browse_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/categories/categories_notifier.dart';
import '../../providers/professionals/professionals_browse_provider.dart';
import '../../widgets/catalog/browse_subcategory_strip.dart';
import '../../widgets/catalog/catalog_active_filters_bar.dart';
import '../../widgets/catalog/catalog_browse_header.dart';
import '../../widgets/catalog/sub_sub_category_picker_dialog.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/professionals/professional_grid_card.dart';

class ProfessionalsBrowseScreen extends ConsumerStatefulWidget {
  const ProfessionalsBrowseScreen({
    super.key,
    this.initialSubcategoryId,
  });

  final int? initialSubcategoryId;

  @override
  ConsumerState<ProfessionalsBrowseScreen> createState() =>
      _ProfessionalsBrowseScreenState();
}

class _ProfessionalsBrowseScreenState extends ConsumerState<ProfessionalsBrowseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _appliedInitialSubcategory = false;

  static const _headerTitle = 'Técnicos disponibles';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 280) {
      final categoryId = ref.read(professionCategoryIdProvider).valueOrNull;
      if (categoryId == null) return;
      ref.read(professionalsBrowseControllerProvider(categoryId).notifier).loadNextPage();
    }
  }

  Future<void> _refreshBrowse(int categoryId) async {
    await ref.read(professionalsBrowseControllerProvider(categoryId).notifier).refresh();
  }

  void _runSearch(int categoryId, String query) {
    ref.read(professionalsBrowseControllerProvider(categoryId).notifier).search(query);
  }

  Future<void> _openSubSubCategoryPicker({
    required int categoryId,
    required int subcategoryId,
    required String subcategoryLabel,
    int? selectedId,
  }) async {
    final options = await ref.read(subSubCategoriesListProvider(subcategoryId).future);
    if (!mounted) return;

    final activeOptions = options.where((item) => item.status).toList();
    final picked = await showSubSubCategoryPickerDialog(
      context: context,
      subcategoryName: subcategoryLabel,
      options: activeOptions,
      selectedId: selectedId,
    );

    if (!mounted || picked == selectedId) return;

    await ref
        .read(professionalsBrowseControllerProvider(categoryId).notifier)
        .selectPrioritizeSubSubCategory(picked);
  }

  Widget _buildHeader({
    required int categoryId,
    required List<SubcategoryModel> subcategories,
    required ProfessionalsBrowseViewState? feed,
    required AsyncValue<List<SubSubCategoryModel>>? subSubOptionsAsync,
  }) {
    final selectedId = feed?.selectedSubcategoryId;
    final subcategoryLabel = resolveSubcategoryLabel(subcategories, selectedId);
    final subSubOptions = subSubOptionsAsync?.valueOrNull ?? const [];
    final subSubCategoryLabel = resolveSubSubCategoryLabel(
      subSubOptions,
      feed?.prioritizeSubSubCategoryId,
    );

    return CatalogBrowseHeader(
      title: _headerTitle,
      searchController: _searchController,
      searchHint: 'Buscar por nombre, oficio o servicio',
      onSearch: (query) => _runSearch(categoryId, query),
      subcategoriesSection: BrowseSubcategoryStrip(
        subcategories: subcategories,
        selectedSubcategoryId: selectedId,
        onSelected: (subcategoryId) {
          ref.read(professionalsBrowseControllerProvider(categoryId).notifier).selectSubcategory(subcategoryId);
        },
      ),
      activeFiltersSection: CatalogActiveFiltersBar(
        subcategoryLabel: subcategoryLabel,
        subSubCategoryLabel: subSubCategoryLabel,
        searchQuery: feed?.search,
        onClearSubcategory: selectedId == null
            ? null : () {
                ref.read(professionalsBrowseControllerProvider(categoryId).notifier).selectSubcategory(null);
              },
        onClearSubSubCategory: feed?.prioritizeSubSubCategoryId == null
            ? null
            : () {
                ref
                    .read(professionalsBrowseControllerProvider(categoryId).notifier)
                    .selectPrioritizeSubSubCategory(null);
              },
        onClearSearch: feed?.search == null
            ? null : () {
                _searchController.clear();
                ref.read(professionalsBrowseControllerProvider(categoryId).notifier).clearSearch();
              },
        onOpenSubSubCategoryPicker: selectedId == null || subcategoryLabel == null
            ? null
            : () => _openSubSubCategoryPicker(
                  categoryId: categoryId,
                  subcategoryId: selectedId,
                  subcategoryLabel: subcategoryLabel,
                  selectedId: feed?.prioritizeSubSubCategoryId,
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryIdAsync = ref.watch(professionCategoryIdProvider);

    return categoryIdAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(title: const Text(_headerTitle)),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(professionCategoryIdProvider),
        ),
      ),
      data: (categoryId) {
        if (categoryId == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(_headerTitle)),
            body: const EmptyView(
              message: 'No se encontró la categoría de profesionales.',
            ),
          );
        }

        _applyInitialSubcategory(categoryId);

        final subcategoriesAsync = ref.watch(professionBrowseSubcategoriesProvider(categoryId));
        final feedAsync = ref.watch(professionalsBrowseControllerProvider(categoryId));
        final feed = feedAsync.valueOrNull;
        final subSubOptionsAsync = feed?.selectedSubcategoryId == null
            ? null : ref.watch(subSubCategoriesListProvider(feed!.selectedSubcategoryId!));

        return Scaffold(
          backgroundColor: const Color(0xFFF0F1F3),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              subcategoriesAsync.when(
                loading: () => CatalogBrowseHeader(
                  title: _headerTitle,
                  searchController: _searchController,
                  searchHint: 'Buscar por nombre, oficio o servicio',
                  onSearch: (query) => _runSearch(categoryId, query),
                  subcategoriesSection: const SizedBox(
                    height: 118,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
                error: (_, _) => CatalogBrowseHeader(
                  title: _headerTitle,
                  searchController: _searchController,
                  searchHint: 'Buscar por nombre, oficio o servicio',
                  onSearch: (query) => _runSearch(categoryId, query),
                  subcategoriesSection: const SizedBox.shrink(),
                ),
                data: (subcategories) => _buildHeader(
                  categoryId: categoryId,
                  subcategories: subcategories,
                  feed: feed,
                  subSubOptionsAsync: subSubOptionsAsync,
                ),
              ),
              Expanded(
                child: feedAsync.when(
                  loading: () => const LoadingView(
                    message: 'Cargando técnicos...',
                  ),
                  error: (error, _) => ErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(
                      professionalsBrowseControllerProvider(categoryId),
                    ),
                  ),
                  data: (feedData) {
                          final subcategories =
                              subcategoriesAsync.valueOrNull ?? const [];
                          final subcategoryLabel = resolveSubcategoryLabel(
                            subcategories,
                            feedData.selectedSubcategoryId,
                          );
                          final subSubOptions = feedData.selectedSubcategoryId == null
                              ? const <SubSubCategoryModel>[]
                              : ref.watch(subSubCategoriesListProvider(feedData.selectedSubcategoryId!),).valueOrNull ??
                                  const <SubSubCategoryModel>[];
                          final subSubCategoryLabel = resolveSubSubCategoryLabel(
                            subSubOptions,
                            feedData.prioritizeSubSubCategoryId,
                          );

                          if (feedData.technicians.isEmpty) {
                            return _BrowseEmptyState(
                              message: buildCatalogEmptyMessage(
                                searchQuery: feedData.search,
                                subcategoryLabel: subcategoryLabel,
                                subSubCategoryLabel: subSubCategoryLabel,
                                entityLabel: 'técnicos',
                              ),
                              onClearFilters: feedData.selectedSubcategoryId != null ||
                                      feedData.prioritizeSubSubCategoryId != null ||
                                      (feedData.search?.isNotEmpty ?? false)
                                  ? () async {
                                      _searchController.clear();
                                      _selectedSubcategoryIdReset(categoryId);
                                    }
                                  : null,
                            );
                          }

                          final prioritizeId = feedData.prioritizeSubSubCategoryId;
                          final hasPriorityMatches = prioritizeId != null &&
                              feedData.technicians.any(
                                (technician) => technician.subSubCategories.any(
                                  (item) => item.id == prioritizeId,
                                ),
                              );

                          return RefreshIndicator(
                            color: AppBrandColors.primaryGreen,
                            onRefresh: () => _refreshBrowse(categoryId),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (prioritizeId != null && !hasPriorityMatches)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                    child: _InfoBanner(
                                      message:
                                          'Ningún técnico ofrece exactamente $subSubCategoryLabel. Te mostramos otros en $subcategoryLabel.',
                                    ),
                                  ),
                                Expanded(
                                  child: GridView.builder(
                                    controller: _scrollController,
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio:
                                          CatalogBrowseConstants.professionalGridAspectRatio,
                                    ),
                                    itemCount: feedData.technicians.length +
                                        (feedData.isLoadingMore ? 1 : 0),
                                    itemBuilder: (context, index) {
                                      if (index >= feedData.technicians.length) {
                                        return const Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(16),
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        );
                                      }

                                      final technician = feedData.technicians[index];
                                      final isPriorityMatch = prioritizeId != null &&
                                          technician.subSubCategories.any(
                                            (item) => item.id == prioritizeId,
                                          );

                                      return ProfessionalGridCard(
                                        technician: technician,
                                        highlightSubSubCategoryId: prioritizeId,
                                        showPriorityMatch: isPriorityMatch,
                                        onTap: () => context.push(
                                          RoutePaths.technicianDetailPath(
                                            technician.id,
                                            subSubCategoryId: prioritizeId,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectedSubcategoryIdReset(int categoryId) async {
    await ref
        .read(professionalsBrowseControllerProvider(categoryId).notifier)
        .selectSubcategory(null);
  }

  void _applyInitialSubcategory(int categoryId) {
    final initialId = widget.initialSubcategoryId;
    if (_appliedInitialSubcategory || initialId == null) return;

    _appliedInitialSubcategory = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(professionalsBrowseControllerProvider(categoryId).notifier)
          .selectSubcategory(initialId);
    });
  }
}

class _BrowseEmptyState extends StatelessWidget {
  const _BrowseEmptyState({
    required this.message,
    this.onClearFilters,
  });

  final String message;
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: AppBrandColors.textDark,
                height: 1.45,
              ),
            ),
            if (onClearFilters != null) ...[
              const SizedBox(height: 16),
              TextButton(
                onPressed: onClearFilters,
                child: const Text('Quitar filtros'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9A3412),
          height: 1.4,
        ),
      ),
    );
  }
}
