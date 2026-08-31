import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/sellers/product_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/products/products_browse_provider.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/catalog/browse_subcategory_strip.dart';
import '../../widgets/catalog/catalog_active_filters_bar.dart';
import '../../widgets/catalog/catalog_browse_header.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/products/product_grid_card.dart';

class ProductsBrowseScreen extends ConsumerStatefulWidget {
  const ProductsBrowseScreen({super.key, this.initialSubcategoryId});

  final int? initialSubcategoryId;

  @override
  ConsumerState<ProductsBrowseScreen> createState() =>
      _ProductsBrowseScreenState();
}

class _ProductsBrowseScreenState extends ConsumerState<ProductsBrowseScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  ProductsBrowseControllerProvider _browseProvider(int categoryId) =>
      productsBrowseControllerProvider(
        categoryId,
        initialSubcategoryId: widget.initialSubcategoryId,
      );

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
      final categoryId = ref.read(productCategoryIdProvider).valueOrNull;
      if (categoryId == null) return;
      ref.read(_browseProvider(categoryId).notifier).loadNextPage();
    }
  }

  void _runSearch(int categoryId, String query) {
    ref.read(_browseProvider(categoryId).notifier).search(query);
  }

  @override
  Widget build(BuildContext context) {
    final categoryIdAsync = ref.watch(productCategoryIdProvider);

    return categoryIdAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(productCategoryIdProvider),
        ),
      ),
      data: (categoryId) {
        if (categoryId == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const EmptyView(
              message: 'No se encontró la categoría Productos.',
            ),
          );
        }

        final subcategoriesAsync = ref.watch(
          productBrowseSubcategoriesProvider(categoryId),
        );
        final feedAsync = ref.watch(_browseProvider(categoryId));

        return Scaffold(
          backgroundColor: const Color(0xFFF0F1F3),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              subcategoriesAsync.when(
                loading: () => CatalogBrowseHeader(
                  searchController: _searchController,
                  searchHint: 'Buscar materiales, marcas o negocio',
                  onSearch: (query) => _runSearch(categoryId, query),
                  subcategoriesSection: const SizedBox(
                    height: 118,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  ),
                ),
                error: (_, _) => CatalogBrowseHeader(
                  searchController: _searchController,
                  searchHint: 'Buscar materiales, marcas o negocio',
                  onSearch: (query) => _runSearch(categoryId, query),
                  subcategoriesSection: const SizedBox.shrink(),
                ),
                data: (subcategories) {
                  final feed = feedAsync.valueOrNull;
                  final selectedId = feed?.selectedSubcategoryId;
                  final subcategoryLabel = resolveSubcategoryLabel(
                    subcategories,
                    selectedId,
                  );

                  return CatalogBrowseHeader(
                    searchController: _searchController,
                    searchHint: 'Buscar materiales, marcas o negocio',
                    onSearch: (query) => _runSearch(categoryId, query),
                    subcategoriesSection: BrowseSubcategoryStrip(
                      subcategories: subcategories,
                      selectedSubcategoryId: selectedId,
                      onSelected: (subcategoryId) {
                        ref
                            .read(_browseProvider(categoryId).notifier)
                            .selectSubcategory(subcategoryId);
                      },
                    ),
                    activeFiltersSection: CatalogActiveFiltersBar(
                      subcategoryLabel: subcategoryLabel,
                      searchQuery: feed?.search,
                      onClearSubcategory: selectedId == null
                          ? null
                          : () {
                              ref.read(_browseProvider(categoryId).notifier).selectSubcategory(null);
                            },
                      onClearSearch: feed?.search == null
                          ? null
                          : () {
                              _searchController.clear();
                              ref.read(_browseProvider(categoryId).notifier).clearSearch();
                            },
                    ),
                  );
                },
              ),
              Expanded(
                child: feedAsync.when(
                  skipLoadingOnReload: true,
                  loading: () =>
                      const LoadingView(message: 'Cargando materiales...'),
                  error: (error, _) => ErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(_browseProvider(categoryId)),
                  ),
                  data: (feed) {
                    if (feed.products.isEmpty) {
                      final subcategories =
                          subcategoriesAsync.valueOrNull ?? const [];
                      return Column(
                        children: [
                          if (feed.searchSuggestions.isNotEmpty)
                            _SearchSuggestionsBar(
                              suggestions: feed.searchSuggestions,
                              onSubcategoryTap: (subcategoryId) {
                                ref.read(_browseProvider(categoryId).notifier).selectSubcategory(subcategoryId);
                              },
                            ),
                          Expanded(
                            child: EmptyView(
                              message: buildCatalogEmptyMessage(
                                searchQuery: feed.search,
                                subcategoryLabel: resolveSubcategoryLabel(
                                  subcategories,
                                  feed.selectedSubcategoryId,
                                ),
                                entityLabel: 'materiales',
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        if (feed.searchSuggestions.isNotEmpty)
                          _SearchSuggestionsBar(
                            suggestions: feed.searchSuggestions,
                            onSubcategoryTap: (subcategoryId) {
                              ref.read(_browseProvider(categoryId).notifier).selectSubcategory(subcategoryId);
                            },
                          ),
                        Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  childAspectRatio:
                                      ProductGridCard.gridAspectRatio(),
                                ),
                            itemCount:
                                feed.products.length +
                                (feed.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= feed.products.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }

                              final product = feed.products[index];
                              return ProductGridCard(
                                product: product,
                                onTap: () => context.push(
                                  RoutePaths.sellerCatalogPath(
                                    product.sellerId,
                                    currentProductId: product.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
}

class _SearchSuggestionsBar extends StatelessWidget {
  const _SearchSuggestionsBar({
    required this.suggestions,
    required this.onSubcategoryTap,
  });

  final List<ProductSearchSuggestionModel> suggestions;
  final ValueChanged<int> onSubcategoryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sugerencias del catálogo',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((item) {
              final label = item.isSubcategory
                  ? item.name
                  : '${item.subcategoryName ?? item.name} · ${item.name}';

              return ActionChip(
                label: Text(label),
                onPressed: () {
                  final subcategoryId = item.isSubcategory
                      ? item.id
                      : item.subcategoryId;
                  if (subcategoryId != null) {
                    onSubcategoryTap(subcategoryId);
                  }
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
