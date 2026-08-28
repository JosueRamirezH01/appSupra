import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/sellers/related_products_provider.dart';
import '../sellers/product_horizontal_card.dart';

/// Materiales sugeridos para el servicio.
///
/// Tope 6 productos. Si hay 4 o más, la card Ver más va al final (7.ª si hay 6).
/// Diseño igual a la isla de productos del home.
class ServiceRelatedProductsRail extends ConsumerWidget {
  const ServiceRelatedProductsRail({
    super.key,
    required this.technicianUserId,
    required this.professionSubSubCategoryId,
    required this.professionSubSubCategoryName,
  });

  final int technicianUserId;
  final int professionSubSubCategoryId;
  final String professionSubSubCategoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(
      relatedProductsForSubSubProvider(professionSubSubCategoryId),
    );

    return asyncProducts.when(
      skipLoadingOnReload: true,
      loading: () => const _RelatedProductsChapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: _RelatedProductsSkeleton(),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (result) {
        if (result.isEmpty) return const SizedBox.shrink();

        final products = result.products.isNotEmpty
            ? result.products
            : result.groups.expand((group) => group.products).toList();
        final preview = products
            .take(CatalogConstants.relatedMaterialsPreviewCount)
            .toList();

        return _RelatedProductsChapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: _RelatedProductsIsland(
              title: 'Materiales relacionados',
              subtitle: professionSubSubCategoryName.trim().isEmpty
                  ? 'Sugeridos para este servicio.'
                  : 'Sugeridos para $professionSubSubCategoryName.',
              products: preview,
              onSeeMore:
                  preview.length >= CatalogConstants.relatedMaterialsSeeMoreFrom
                      ? () => context.push(
                            RoutePaths.technicianServiceMaterialsPath(
                              technicianUserId,
                              professionSubSubCategoryId,
                              title: professionSubSubCategoryName,
                            ),
                          )
                      : null,
            ),
          ),
        );
      },
    );
  }
}

class _RelatedProductsChapter extends StatelessWidget {
  const _RelatedProductsChapter({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 28),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
        ),
        const SizedBox(height: 20),
        child,
      ],
    );
  }
}

class _RelatedProductsIsland extends StatelessWidget {
  const _RelatedProductsIsland({
    required this.title,
    required this.subtitle,
    required this.products,
    this.onSeeMore,
  });

  final String title;
  final String subtitle;
  final List<ProductPublicModel> products;
  final VoidCallback? onSeeMore;

  static const _radius = 20.0;
  static const _topRightRadius = 70.0;
  static const _pad = 16.0;
  static const _topGap = 24.0;
  static const _bottomGap = 32.0;

  static const _islandRadius = BorderRadius.only(
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
              borderRadius: _islandRadius,
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
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppBrandColors.textDark,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
            _RelatedProductsRail(
              products: products,
              onSeeMore: onSeeMore,
            ),
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
  static const peekFraction = 0.25;
  static const overflowRight = 10.0;

  static double cardWidthFor(double viewportWidth) {
    return (viewportWidth - pad - visibleCards * gap) /
        (visibleCards + peekFraction);
  }
}

class _RelatedProductsRail extends StatelessWidget {
  const _RelatedProductsRail({
    required this.products,
    this.onSeeMore,
  });

  final List<ProductPublicModel> products;
  final VoidCallback? onSeeMore;

  @override
  Widget build(BuildContext context) {
    final showSeeMore = onSeeMore != null;
    final itemCount = products.length + (showSeeMore ? 1 : 0);

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
              itemCount: itemCount,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: _IslandPeek.gap),
              itemBuilder: (context, index) {
                if (showSeeMore && index == products.length) {
                  return _SeeMoreCard(
                    width: cardWidth,
                    height: cardHeight,
                    onTap: onSeeMore!,
                  );
                }

                final product = products[index];
                return ProductHorizontalCard(
                  product: product,
                  width: cardWidth,
                  onTap: () => context.push(
                    RoutePaths.productDetailPath(product.id),
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

class _RelatedProductsSkeleton extends StatelessWidget {
  const _RelatedProductsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppBrandColors.islaHomePromo,
              borderRadius: _RelatedProductsIsland._islandRadius,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: _RelatedProductsIsland._topGap),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                _RelatedProductsIsland._pad,
                0,
                _RelatedProductsIsland._pad,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 200,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 160,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = _IslandPeek.cardWidthFor(constraints.maxWidth);
                final cardHeight =
                    ProductHorizontalCard.cardHeightFor(cardWidth);

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
                      padding: const EdgeInsets.fromLTRB(
                        _IslandPeek.pad,
                        0,
                        0,
                        0,
                      ),
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
            const SizedBox(height: _RelatedProductsIsland._bottomGap),
          ],
        ),
      ],
    );
  }
}
