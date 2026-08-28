import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/location/client_location_provider.dart';
import '../../providers/products/home_featured_products_provider.dart';
import '../sellers/product_horizontal_card.dart';

/// Isla de productos del home (bajo oficios).
///
/// Siempre visible. Hasta 6 cards + Ver más. Carrusel tipo PedidosYa:
/// bandeja de color recortada abajo de las cards; el carrusel flota
/// encima y se sale a la derecha (2 cards + 1/4).
class HomeFeaturedProductsIsland extends ConsumerWidget {
  const HomeFeaturedProductsIsland({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(homeFeaturedProductsProvider);
    final hasLocation =
        ref.watch(activeClientLocationProvider).valueOrNull != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: asyncProducts.when(
        skipLoadingOnReload: true,
        loading: () => const _ProductsIslandSkeleton(),
        error: (_, _) => _ProductsIslandFrame(
          child: _IslandMessage(
            text: 'No se pudieron cargar los productos.',
            actionLabel: 'Reintentar',
            onAction: () => ref.invalidate(homeFeaturedProductsProvider),
          ),
        ),
        data: (products) {
          if (products.isEmpty) {
            return _ProductsIslandFrame(
              child: _IslandMessage(
                text: hasLocation
                    ? 'No hay materiales de negocios cerca de tu ubicación.'
                    : 'Aún no hay productos publicados.',
              ),
            );
          }

          return _ProductsIslandFrame(
            child: _ProductsIslandRail(
              products: products,
              onSeeMore: () => context.go(RoutePaths.productsBrowse),
            ),
          );
        },
      ),
    );
  }
}

class _ProductsIslandFrame extends StatelessWidget {
  const _ProductsIslandFrame({required this.child});

  final Widget child;

  static const _radius = 20.0;
  static const _topRightRadius = 70.0;
  static const _pad = 16.0;
  static const _topGap = 24.0;
  /// Color de la isla por debajo de las cards (la bandeja queda abajo).
  static const _bottomGap = 32.0;

  static const islandRadius = BorderRadius.only(
    topLeft: Radius.circular(_radius),
    topRight: Radius.circular(_topRightRadius),
    bottomLeft: Radius.circular(_radius),
    bottomRight: Radius.circular(_radius),
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppBrandColors.islaHomePromo,
              borderRadius: islandRadius,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: _topGap),
            Padding(
              padding: const EdgeInsets.fromLTRB(_pad, 0, _pad, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Productos',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppBrandColors.textDark,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Materiales de negocios cerca de ti.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.3,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            child,
            const SizedBox(height: _bottomGap),
          ],
        ),
      ],
    );
  }
}

class _IslandPeek {
  static const pad = 16.0;
  static const gap = 10.0;
  static const visibleCards = 2.0;
  /// Cuarto de la siguiente card, recortada al borde de la isla.
  static const peekFraction = 0.25;
  static const overflowRight = 10.0;

  static double cardWidthFor(double viewportWidth) {
    return (viewportWidth - pad - visibleCards * gap) /
        (visibleCards + peekFraction);
  }
}

class _ProductsIslandRail extends StatelessWidget {
  const _ProductsIslandRail({
    required this.products,
    required this.onSeeMore,
  });

  final List<ProductPublicModel> products;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = _IslandPeek.cardWidthFor(constraints.maxWidth);
        final cardHeight = ProductHorizontalCard.cardHeightFor(cardWidth);

        return SizedBox(
          height: cardHeight,
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth + _IslandPeek.overflowRight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                _IslandPeek.pad,
                0,
                _IslandPeek.pad,
                0,
              ),
              itemCount: products.length + 1,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: _IslandPeek.gap),
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return _SeeMoreCard(
                    width: cardWidth,
                    height: cardHeight,
                    onTap: onSeeMore,
                  );
                }

                final product = products[index];
                return ProductHorizontalCard(
                  product: product,
                  width: cardWidth,
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
        );
      },
    );
  }
}

class _SeeMoreCard extends StatelessWidget {
  const _SeeMoreCard({
    required this.width,
    required this.height,
    required this.onTap,
  });

  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppBrandColors.primaryGreen.withValues(alpha: 0.16),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 26,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ver más',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IslandMessage extends StatelessWidget {
  const _IslandMessage({
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13.5,
              height: 1.35,
              color: AppBrandColors.textDark,
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppBrandColors.primaryGreen,
              ),
              child: Text(
                actionLabel!,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductsIslandSkeleton extends StatelessWidget {
  const _ProductsIslandSkeleton();

  @override
  Widget build(BuildContext context) {
    return _ProductsIslandFrame(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = _IslandPeek.cardWidthFor(constraints.maxWidth);
          final cardHeight = ProductHorizontalCard.cardHeightFor(cardWidth);

          return SizedBox(
            height: cardHeight,
            child: OverflowBox(
              alignment: Alignment.centerLeft,
              minWidth: constraints.maxWidth,
              maxWidth: constraints.maxWidth + _IslandPeek.overflowRight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(_IslandPeek.pad, 0, 0, 0),
                itemCount: 2,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: _IslandPeek.gap),
                itemBuilder: (_, _) => Container(
                  width: cardWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
