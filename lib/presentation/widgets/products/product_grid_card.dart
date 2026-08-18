import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_browse_constants.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../auth/auth_ui.dart';
import '../catalog/browse_card_media_placeholder.dart';
import '../home/home_media_image.dart';
import '../sellers/product_referential_pricing_fields.dart';
import '../sellers/seller_panel_widgets.dart';

/// Layout del card de producto unificado.
enum ProductCardLayout {
  /// Browse / búsqueda / catálogo (llena la celda del grid).
  grid,

  /// Home / carrusel horizontal (ancho fijo).
  compact,
}

/// Card unificada de producto (home y listados).
///
/// Foto + logo + nombre + precio referencial (oferta si aplica) + Cotizar ahora.
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    this.layout = ProductCardLayout.grid,
    this.width = compactWidth,
    this.showSellerInfo = true,
    this.isHighlighted = false,
    this.showStatusBadge = false,
  });

  static const double compactWidth = 160;

  final ProductPublicModel product;
  final VoidCallback onTap;
  final ProductCardLayout layout;
  final double width;
  final bool showSellerInfo;
  final bool isHighlighted;
  final bool showStatusBadge;

  static double compactHeightFor(double width) {
    const pad = 20.0;
    const gap = 8.0;
    // Título 2 líneas + precio anterior tachado + precio + Cotizar ahora.
    const textBlock = 90.0;
    final imageW = width - pad;
    final imageH =
        imageW / CatalogBrowseConstants.productCardImageAspectRatio;
    return pad + imageH + gap + textBlock;
  }

  static double get compactHeight => compactHeightFor(compactWidth);

  static double gridAspectRatio({bool showSellerInfo = true}) {
    return CatalogBrowseConstants.productGridAspectRatio(
      showSellerInfo: showSellerInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (layout == ProductCardLayout.compact) {
      return SizedBox(
        width: width,
        height: compactHeightFor(width),
        child: _ProductCardShell(
          onTap: onTap,
          isHighlighted: isHighlighted,
          child: _ProductCardBody(
            product: product,
            showSellerInfo: showSellerInfo,
            isHighlighted: isHighlighted,
            showStatusBadge: showStatusBadge,
            useHomeMedia: true,
            expandFooter: false,
            imageAspectRatio:
                CatalogBrowseConstants.productCardImageAspectRatio,
          ),
        ),
      );
    }

    return _ProductCardShell(
      onTap: onTap,
      isHighlighted: isHighlighted,
      child: _ProductCardBody(
        product: product,
        showSellerInfo: showSellerInfo,
        isHighlighted: isHighlighted,
        showStatusBadge: showStatusBadge,
        useHomeMedia: false,
        expandFooter: true,
        imageAspectRatio: CatalogBrowseConstants.productCardImageAspectRatio,
      ),
    );
  }
}

/// Compat: listados / browse / búsqueda.
class ProductGridCard extends StatelessWidget {
  const ProductGridCard({
    super.key,
    required this.product,
    required this.onTap,
    this.showSellerInfo = true,
    this.isHighlighted = false,
  });

  final ProductPublicModel product;
  final VoidCallback onTap;
  final bool showSellerInfo;
  final bool isHighlighted;

  static double gridAspectRatio({bool showSellerInfo = true}) =>
      ProductCard.gridAspectRatio(showSellerInfo: showSellerInfo);

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      product: product,
      onTap: onTap,
      layout: ProductCardLayout.grid,
      showSellerInfo: showSellerInfo,
      isHighlighted: isHighlighted,
    );
  }
}

class _ProductCardShell extends StatelessWidget {
  const _ProductCardShell({
    required this.onTap,
    required this.child,
    this.isHighlighted = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: isHighlighted
            ? Border.all(color: AppBrandColors.primaryGreen, width: 2)
            : Border.all(color: const Color(0xFFE8EAED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}

class _ProductCardBody extends StatelessWidget {
  const _ProductCardBody({
    required this.product,
    required this.showSellerInfo,
    required this.isHighlighted,
    required this.showStatusBadge,
    required this.useHomeMedia,
    required this.expandFooter,
    required this.imageAspectRatio,
  });

  final ProductPublicModel product;
  final bool showSellerInfo;
  final bool isHighlighted;
  final bool showStatusBadge;
  final bool useHomeMedia;
  final bool expandFooter;
  final double imageAspectRatio;

  bool get _hasOffer {
    final price = product.price;
    final compareAt = product.compareAtPrice;
    return price != null && compareAt != null && compareAt > price;
  }

  int? get _discountPercent {
    if (!_hasOffer) return null;
    final price = product.price!;
    final compareAt = product.compareAtPrice!;
    final pct = (((compareAt - price) / compareAt) * 100).round();
    return pct > 0 ? pct : null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = MediaUrlUtils.resolve(product.primaryImageUrl);
    final sellerName = product.seller?.businessName.trim();
    final logoUrl = MediaUrlUtils.resolve(product.seller?.logoUrl);
    final verified = product.seller?.verified ?? false;
    final showLogo = showSellerInfo &&
        ((logoUrl != null && logoUrl.isNotEmpty) ||
            (sellerName != null && sellerName.isNotEmpty));
    final discount = _discountPercent;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: imageAspectRatio,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _ProductCardImage(
                    imageUrl: imageUrl,
                    useHomeMedia: useHomeMedia,
                  ),
                  if (showLogo)
                    Positioned(
                      top: 7,
                      left: 7,
                      child: _SellerLogoBadge(
                        logoUrl: logoUrl,
                        businessName: sellerName ?? 'V',
                        verified: verified,
                      ),
                    ),
                  if (isHighlighted)
                    Positioned(
                      top: 7,
                      right: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppBrandColors.primaryGreen,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Viendo ahora',
                          style: GoogleFonts.montserrat(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (showStatusBadge)
                    Positioned(
                      left: showLogo ? 44 : 6,
                      top: 6,
                      child: SellerProductStatusChip(
                        status: product.status,
                        compact: true,
                      ),
                    ),
                  if (discount != null)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _DiscountStripe(percent: discount),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          _ProductCardFooter(
            product: product,
            expand: expandFooter,
          ),
        ],
      ),
    );
  }
}

class _ProductCardFooter extends StatelessWidget {
  const _ProductCardFooter({
    required this.product,
    required this.expand,
  });

  final ProductPublicModel product;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.2,
            color: AppBrandColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        _ProductPriceColumn(
          price: product.price,
          compareAtPrice: product.compareAtPrice,
        ),
        const SizedBox(height: 4),
        Text(
          'Cotizar ahora',
          maxLines: 1,
          style: GoogleFonts.poppins(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppBrandColors.primaryGreen,
          ),
        ),
      ],
    );

    if (!expand) return content;
    return Expanded(child: content);
  }
}

class _ProductPriceColumn extends StatelessWidget {
  const _ProductPriceColumn({
    required this.price,
    required this.compareAtPrice,
  });

  final double? price;
  final double? compareAtPrice;

  @override
  Widget build(BuildContext context) {
    if (price == null) {
      return Text(
        'Consultar precio',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppBrandColors.textMuted,
        ),
      );
    }

    final hasOffer = compareAtPrice != null && compareAtPrice! > price!;
    final currentPrice = Text(
      formatProductSoles(price!),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        color: AppBrandColors.textDark,
      ),
    );

    if (!hasOffer) return currentPrice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatProductSoles(compareAtPrice!),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppBrandColors.textMuted,
            decoration: TextDecoration.lineThrough,
            decorationColor: AppBrandColors.textMuted,
            decorationThickness: 1.6,
          ),
        ),
        const SizedBox(height: 2),
        currentPrice,
      ],
    );
  }
}

class _SellerLogoBadge extends StatelessWidget {
  const _SellerLogoBadge({
    required this.logoUrl,
    required this.businessName,
    required this.verified,
  });

  final String? logoUrl;
  final String businessName;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    final trimmed = businessName.trim();
    final initial = trimmed.isEmpty ? 'V' : trimmed.substring(0, 1).toUpperCase();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: logoUrl != null && logoUrl!.isNotEmpty
              ? Image(
                  image: MediaUrlUtils.networkImage(logoUrl)!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _InitialAvatar(initial: initial),
                )
              : _InitialAvatar(initial: initial),
        ),
        if (verified)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_rounded,
                size: 12,
                color: Color(0xFF0F766E),
              ),
            ),
          ),
      ],
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  const _InitialAvatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFECFDF5),
      child: Center(
        child: Text(
          initial,
          style: GoogleFonts.montserrat(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.primaryGreen,
          ),
        ),
      ),
    );
  }
}

class _DiscountStripe extends StatelessWidget {
  const _DiscountStripe({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppBrandColors.primaryGreen.withValues(alpha: 0.92),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          '-$percent%',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _ProductCardImage extends StatelessWidget {
  const _ProductCardImage({
    required this.imageUrl,
    required this.useHomeMedia,
  });

  final String? imageUrl;
  final bool useHomeMedia;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const BrowseCardMediaPlaceholder(
        kind: BrowseCardMediaKind.product,
      );
    }

    if (useHomeMedia) {
      return HomeMediaImage.workGalleryThumb(
        context: context,
        imageUrl: imageUrl!,
        width: 200,
        height: 200,
      );
    }

    return Image(
      image: MediaUrlUtils.networkImage(imageUrl)!,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const BrowseCardMediaPlaceholder(
        kind: BrowseCardMediaKind.product,
      ),
    );
  }
}
