import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/products/home_product_offers_provider.dart';
import '../sellers/product_horizontal_card.dart';

/// Isla de ofertas del home (entre técnicos y productos).
///
/// Misma forma que materiales relacionados: bandeja recortada, esquina
/// superior derecha más abierta y peek del siguiente producto.
class HomeProductOffersIsland extends ConsumerWidget {
  const HomeProductOffersIsland({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncOffers = ref.watch(homeProductOffersProvider);

    return asyncOffers.when(
      skipError: true,
      skipLoadingOnReload: true,
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 24),
        child: _OffersIslandSkeleton(),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (result) {
        if (result.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _OffersIsland(
            products: result.products,
            onSeeMore: result.hasMore
                ? () => context.push(RoutePaths.productOffers)
                : null,
          ),
        );
      },
    );
  }
}

class _OffersIsland extends StatelessWidget {
  const _OffersIsland({
    required this.products,
    this.onSeeMore,
  });

  final List<ProductPublicModel> products;
  final VoidCallback? onSeeMore;

  static const _radius = 20.0;
  static const _topRightRadius = 70.0;
  static const _pad = 16.0;
  static const _endPeek = 12.0;

  static const _islandRadius = BorderRadius.only(
    topLeft: Radius.circular(_radius),
    topRight: Radius.circular(_topRightRadius),
    bottomLeft: Radius.circular(_radius),
    bottomRight: Radius.circular(_radius),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _islandRadius,
      child: ColoredBox(
        color: AppBrandColors.islaHomePromo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(_pad, 16, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ofertas',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppBrandColors.textDark,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Productos con descuento.',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            height: 1.3,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onSeeMore != null)
                    TextButton(
                      onPressed: onSeeMore,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppBrandColors.textDark,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ver más',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, size: 22),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: ProductHorizontalCard.cardHeight + _pad,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(_pad, 0, _endPeek, _pad),
                itemCount: products.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductHorizontalCard(
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
            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

class _OffersIslandSkeleton extends StatelessWidget {
  const _OffersIslandSkeleton();

  static const _radius = 20.0;
  static const _topRightRadius = 80.0;
  static const _pad = 16.0;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(_radius),
        topRight: Radius.circular(_topRightRadius),
        bottomLeft: Radius.circular(_radius),
        bottomRight: Radius.circular(_radius),
      ),
      child: ColoredBox(
        color: AppBrandColors.islaHomePromo,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(_pad, 16, _pad, _pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _bar(width: 110, height: 18),
              const SizedBox(height: 8),
              _bar(width: 168, height: 12),
              const SizedBox(height: 14),
              SizedBox(
                height: ProductHorizontalCard.cardHeight,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, _) => Container(
                    width: ProductHorizontalCard.cardWidth,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
