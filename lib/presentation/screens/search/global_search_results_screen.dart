import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/search/search_model.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/search/global_search_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/products/product_grid_card.dart';
import '../../widgets/professionals/professional_grid_card.dart';
import '../../widgets/technicians/technician_horizontal_card.dart';

class GlobalSearchResultsScreen extends ConsumerStatefulWidget {
  const GlobalSearchResultsScreen({
    super.key,
    required this.initialQuery,
  });

  final String initialQuery;

  @override
  ConsumerState<GlobalSearchResultsScreen> createState() =>
      _GlobalSearchResultsScreenState();
}

class _GlobalSearchResultsScreenState
    extends ConsumerState<GlobalSearchResultsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _searchController;
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery.trim();
    _searchController = TextEditingController(text: _query);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _runSearch() {
    final value = _searchController.text.trim();
    if (value.isEmpty) return;
    setState(() => _query = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: AppBrandColors.textDark,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _runSearch(),
            style: GoogleFonts.poppins(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Buscar profesionales y productos',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: AppBrandColors.textMuted,
              ),
              border: AppBrandColors.outlineInput(radius: 12),
              enabledBorder: AppBrandColors.outlineInput(radius: 12),
              focusedBorder: AppBrandColors.outlineInput(
                radius: 12,
                color: AppBrandColors.primaryGreen,
                width: 1.8,
              ),
              filled: true,
              fillColor: AppBrandColors.inputFill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 10,
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: _runSearch,
            icon: const Icon(Icons.search_rounded),
            color: AppBrandColors.primaryGreen,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppBrandColors.primaryGreen,
          unselectedLabelColor: AppBrandColors.textMuted,
          indicatorColor: AppBrandColors.primaryGreen,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(text: 'Todo'),
            Tab(text: 'Profesionales'),
            Tab(text: 'Productos'),
          ],
        ),
      ),
      body: _query.isEmpty
          ? const EmptyView(message: 'Escribe algo para buscar.')
          : TabBarView(
              controller: _tabController,
              children: [
                _AllResultsTab(query: _query),
                _TypedResultsTab(
                  query: _query,
                  type: SearchResultType.technicians,
                ),
                _TypedResultsTab(
                  query: _query,
                  type: SearchResultType.products,
                ),
              ],
            ),
    );
  }
}

class _AllResultsTab extends ConsumerWidget {
  const _AllResultsTab({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(
      globalSearchResultsProvider(query, SearchResultType.all),
    );

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(
          globalSearchResultsProvider(query, SearchResultType.all),
        ),
      ),
      data: (data) {
        final technicians = data.technicians;
        final products = data.products;

        if (technicians.isEmpty && products.isEmpty) {
          return EmptyView(message: 'Sin resultados para «$query».');
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            if (technicians.isNotEmpty) ...[
              _SectionHeader(
                title: 'Profesionales',
                count: technicians.length,
              ),
              const SizedBox(height: 8),
              _ProfessionalsPreviewGrid(
                technicians: technicians.take(4).toList(),
              ),
              if (products.isNotEmpty) const SizedBox(height: 20),
            ],
            if (products.isNotEmpty) ...[
              _SectionHeader(
                title: 'Productos',
                count: products.length,
              ),
              const SizedBox(height: 8),
              _ProductsPreviewGrid(products: products.take(4).toList()),
            ],
          ],
        );
      },
    );
  }
}

class _TypedResultsTab extends ConsumerWidget {
  const _TypedResultsTab({
    required this.query,
    required this.type,
  });

  final String query;
  final SearchResultType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(globalSearchResultsProvider(query, type));

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(globalSearchResultsProvider(query, type)),
      ),
      data: (data) {
        if (type == SearchResultType.technicians) {
          if (data.technicians.isEmpty) {
            return EmptyView(message: 'No hay profesionales para «$query».');
          }

          return _ProfessionalsGrid(technicians: data.technicians);
        }

        if (data.products.isEmpty) {
          return EmptyView(message: 'No hay productos para «$query».');
        }

        return _ProductsGrid(products: data.products);
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$title ($count)',
      style: GoogleFonts.montserrat(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppBrandColors.textDark,
      ),
    );
  }
}

class _ProfessionalsGrid extends StatelessWidget {
  const _ProfessionalsGrid({required this.technicians});

  final List<TechnicianPublicModel> technicians;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisSpacing = 12.0;
        const horizontalPadding = 32.0;
        final aspect = TechnicianHorizontalCard.gridAspectRatio(
          gridInnerWidth: constraints.maxWidth - horizontalPadding,
          crossAxisSpacing: crossAxisSpacing,
          verification: TechnicianCardVerification.seal,
        );

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: aspect,
          ),
          itemCount: technicians.length,
          itemBuilder: (context, index) {
            final technician = technicians[index];
            return ProfessionalGridCard(
              technician: technician,
              onTap: () =>
                  context.push(RoutePaths.technicianDetailPath(technician.id)),
            );
          },
        );
      },
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid({required this.products});

  final List<ProductPublicModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: ProductGridCard.gridAspectRatio(),
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
    );
  }
}

class _ProfessionalsPreviewGrid extends StatelessWidget {
  const _ProfessionalsPreviewGrid({required this.technicians});

  final List<TechnicianPublicModel> technicians;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const crossAxisSpacing = 12.0;
        final aspect = TechnicianHorizontalCard.gridAspectRatio(
          gridInnerWidth: constraints.maxWidth,
          crossAxisSpacing: crossAxisSpacing,
          verification: TechnicianCardVerification.seal,
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: crossAxisSpacing,
            childAspectRatio: aspect,
          ),
          itemCount: technicians.length,
          itemBuilder: (context, index) {
            final technician = technicians[index];
            return ProfessionalGridCard(
              technician: technician,
              onTap: () =>
                  context.push(RoutePaths.technicianDetailPath(technician.id)),
            );
          },
        );
      },
    );
  }
}

class _ProductsPreviewGrid extends StatelessWidget {
  const _ProductsPreviewGrid({required this.products});

  final List<ProductPublicModel> products;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: ProductGridCard.gridAspectRatio(),
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
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
    );
  }
}
