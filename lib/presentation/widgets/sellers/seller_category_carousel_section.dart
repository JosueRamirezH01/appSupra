import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import 'product_horizontal_card.dart';

class SellerCategoryCarouselSection extends StatelessWidget {
  const SellerCategoryCarouselSection({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    this.highlightedProductId,
    this.onAdd,
  });

  final String title;
  final List<ProductPublicModel> products;
  final ValueChanged<int> onProductTap;
  final int? highlightedProductId;
  final VoidCallback? onAdd;

  static const _cardWidth = 145.0;
  static const _shadowTop = 4.0;
  static const _shadowBottom = 14.0;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty && onAdd == null) return const SizedBox.shrink();

    final cardHeight = ProductHorizontalCard.cardHeightFor(_cardWidth);
    final itemCount = products.length + (onAdd == null ? 0 : 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: cardHeight + _shadowTop + _shadowBottom,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: const EdgeInsets.fromLTRB(16, _shadowTop, 16, _shadowBottom),
            itemCount: itemCount,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (onAdd != null && index >= products.length) {
                return _AddProductTile(
                  width: _cardWidth,
                  height: cardHeight,
                  onTap: onAdd!,
                );
              }

              final product = products[index];
              return ProductHorizontalCard(
                product: product,
                width: _cardWidth,
                showSellerInfo: false,
                isHighlighted: product.id == highlightedProductId,
                onTap: () => onProductTap(product.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AddProductTile extends StatelessWidget {
  const _AddProductTile({
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
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.06),
              border: Border.all(
                color: AppBrandColors.primaryGreen.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Agregar',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'en este rubro',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
