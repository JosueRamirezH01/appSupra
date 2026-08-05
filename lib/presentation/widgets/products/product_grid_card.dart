import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_browse_constants.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../auth/auth_ui.dart';
import '../catalog/browse_card_media_placeholder.dart';
import '../home/home_media_image.dart';
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
/// Sin precio público: la señal de acción es "Cotizar".
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
    // Título (2 líneas) + Cotizar + Vendedor + gaps.
    const textBlock = 70.0;
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
    required this.imageAspectRatio,
  });

  final ProductPublicModel product;
  final bool showSellerInfo;
  final bool isHighlighted;
  final bool showStatusBadge;
  final bool useHomeMedia;
  final double imageAspectRatio;

  @override
  Widget build(BuildContext context) {
    final imageUrl = MediaUrlUtils.resolve(product.primaryImageUrl);
    //final materials = product.materialsPreview;
    final sellerName = product.seller?.businessName.trim();
    final verified = product.seller?.verified ?? false;
    final hasSellerLine = showSellerInfo && sellerName != null && sellerName.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: imageAspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _ProductCardImage(
                    imageUrl: imageUrl,
                    useHomeMedia: useHomeMedia,
                  ),
                ),
                if (isHighlighted)
                  Positioned(
                    top: 8,
                    left: 8,
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
                    left: 6,
                    top: isHighlighted ? 34 : 6,
                    child: SellerProductStatusChip(
                      status: product.status,
                      compact: true,
                    ),
                  ),
                if (showSellerInfo && verified)
                  const Positioned(
                    right: 7,
                    top: 7,
                    child: _SellerVerifiedSeal(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                /*if (materials != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    materials,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      height: 1.2,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],*/
                const SizedBox(height: 6),
                Text(
                  'Cotizar',
                  maxLines: 1,
                  style: GoogleFonts.poppins(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
                if (hasSellerLine) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Vendedor: $sellerName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerVerifiedSeal extends StatelessWidget {
  const _SellerVerifiedSeal();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xE60F766E),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(5),
        child: Icon(
          Icons.verified_rounded,
          size: 14,
          color: Colors.white,
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
