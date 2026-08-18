import 'package:flutter/material.dart';

import '../../../data/models/sellers/product_model.dart';
import '../products/product_grid_card.dart';

/// Card compacta para carruseles del home.
///
/// Reutiliza el diseño unificado de [ProductCard] (`ProductCardLayout.compact`).
class ProductHorizontalCard extends StatelessWidget {
  const ProductHorizontalCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width = cardWidth,
    this.showStatusBadge = false,
    this.showSellerInfo = true,
    this.isHighlighted = false,
  });

  static const double cardWidth = ProductCard.compactWidth;

  static double cardHeightFor(double width) => ProductCard.compactHeightFor(width);

  static double get cardHeight => ProductCard.compactHeight;

  final ProductPublicModel product;
  final VoidCallback onTap;
  final double width;
  final bool showStatusBadge;
  final bool showSellerInfo;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      product: product,
      onTap: onTap,
      layout: ProductCardLayout.compact,
      width: width,
      showSellerInfo: showSellerInfo,
      showStatusBadge: showStatusBadge,
      isHighlighted: isHighlighted,
    );
  }
}
