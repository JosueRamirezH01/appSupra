import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/route_paths.dart';
import '../../providers/products/home_product_offers_provider.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/products/product_grid_card.dart';

/// Todas las ofertas, mismo orden que la isla del home (mayor descuento primero).
class ProductOffersScreen extends ConsumerStatefulWidget {
  const ProductOffersScreen({super.key});

  @override
  ConsumerState<ProductOffersScreen> createState() => _ProductOffersScreenState();
}

class _ProductOffersScreenState extends ConsumerState<ProductOffersScreen> {
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
      ref.read(productOffersCatalogProvider.notifier).loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(productOffersCatalogProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0F1F3),
      appBar: AppBar(
        backgroundColor: AppBrandColors.scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppBrandColors.textDark,
        title: Text(
          'Ofertas',
          style: GoogleFonts.montserrat(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: feedAsync.when(
        loading: () => const LoadingView(message: 'Cargando ofertas...'),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.read(productOffersCatalogProvider.notifier).retry(),
        ),
        data: (feed) {
          if (feed.products.isEmpty) {
            return const EmptyView(
              message: 'Aún no hay productos con descuento.',
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Text(
                  feed.total == 1
                      ? '1 producto en oferta'
                      : '${feed.total} productos en oferta',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: ProductGridCard.gridAspectRatio(),
                  ),
                  itemCount: feed.products.length + (feed.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= feed.products.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
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
    );
  }
}
