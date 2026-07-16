import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/seller_catalog_provider.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/products/product_grid_card.dart';
import '../../widgets/sellers/seller_catalog_header.dart';

class SellerCatalogScreen extends ConsumerStatefulWidget {
  const SellerCatalogScreen({
    super.key,
    required this.sellerId,
    this.currentProductId,
  });

  final int sellerId;
  final int? currentProductId;

  @override
  ConsumerState<SellerCatalogScreen> createState() =>
      _SellerCatalogScreenState();
}

class _SellerCatalogScreenState extends ConsumerState<SellerCatalogScreen> {
  final _scrollController = ScrollController();

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
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 280) {
      ref
          .read(sellerCatalogControllerProvider(widget.sellerId).notifier)
          .loadNextPage();
    }
  }

  void _openProduct(BuildContext context, int productId) {
    if (productId == widget.currentProductId) {
      context.pop();
      return;
    }
    context.push(RoutePaths.productDetailPath(productId));
  }

  @override
  Widget build(BuildContext context) {
    final sellerAsync = ref.watch(sellerPublicProfileProvider(widget.sellerId));
    final catalogAsync =
        ref.watch(sellerCatalogControllerProvider(widget.sellerId));

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      appBar: AppBar(
        title: Text(
          'Catálogo del vendedor',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: Color(0xFF0B1C15),
        leading: IconButton(onPressed: () => context.pop(), icon: Icon(Icons.arrow_back_ios_new_rounded), color: Colors.white,),
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: sellerAsync.when(
        loading: () => const LoadingView(message: 'Cargando vendedor...'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () =>
              ref.invalidate(sellerPublicProfileProvider(widget.sellerId)),
        ),
        data: (seller) {
          return catalogAsync.when(
            loading: () => Column(
              children: [
                SellerCatalogHeader(seller: seller),
                const Expanded(
                  child: LoadingView(message: 'Cargando catálogo...'),
                ),
              ],
            ),
            error: (error, _) => Column(
              children: [
                SellerCatalogHeader(seller: seller),
                Expanded(
                  child: ErrorView(
                    error: error,
                    onRetry: () => ref.invalidate(
                      sellerCatalogControllerProvider(widget.sellerId),
                    ),
                  ),
                ),
              ],
            ),
            data: (catalog) {
              if (catalog.products.isEmpty) {
                return Column(
                  children: [
                    SellerCatalogHeader(seller: seller),
                    const Expanded(
                      child: EmptyView(
                        message:
                            'Este vendedor aún no tiene productos publicados.',
                      ),
                    ),
                  ],
                );
              }

              return RefreshIndicator(
                color: AppBrandColors.primaryGreen,
                onRefresh: () => ref
                    .read(
                      sellerCatalogControllerProvider(widget.sellerId).notifier,
                    )
                    .refresh(),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SellerCatalogHeader(
                        seller: seller,
                        productCount: catalog.pagination.total,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Productos disponibles',
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppBrandColors.textDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Text(
                                '${catalog.pagination.total} en total',
                                style: GoogleFonts.montserrat(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppBrandColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                      sliver: SliverGrid(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: ProductGridCard.gridAspectRatio(
                            showSellerInfo: false,
                          ),
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = catalog.products[index];

                            return ProductGridCard(
                              product: product,
                              showSellerInfo: false,
                              isHighlighted:
                                  product.id == widget.currentProductId,
                              onTap: () => _openProduct(
                                context,
                                product.id,
                              ),
                            );
                          },
                          childCount: catalog.products.length,
                        ),
                      ),
                    ),
                    if (catalog.isLoadingMore)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
