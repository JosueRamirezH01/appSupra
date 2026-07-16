import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_browse_constants.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../auth/auth_ui.dart';
import '../catalog/browse_card_media_placeholder.dart';

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

  /// Aspect ratio del grid acorde al contenido del card.
  static double gridAspectRatio({bool showSellerInfo = true}) {
    return CatalogBrowseConstants.productGridAspectRatio(
      showSellerInfo: showSellerInfo,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = MediaUrlUtils.resolve(product.primaryImageUrl);
    final description = product.materialsPreview ??
        (product.description?.trim().isNotEmpty == true
            ? product.description!.trim()
            : product.subcategoryName);
    final verified = product.seller?.verified ?? false;

    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: const Color(0x1A000000),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: isHighlighted
                ? Border.all(
                    color: AppBrandColors.primaryGreen,
                    width: 2,
                  )
                : null,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: CatalogBrowseConstants.productCardImageAspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _CardImage(imageUrl: imageUrl),
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
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4,),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.subcategoryName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (showSellerInfo) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              verified
                                  ? Icons.verified_rounded
                                  : Icons.info_outline_rounded,
                              size: 14,
                              color: verified
                                  ? AppBrandColors.primaryGreen
                                  : AppBrandColors.textMuted,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                verified ? 'Verificado' : 'Sin verificar',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: verified
                                      ? AppBrandColors.primaryGreen
                                      : AppBrandColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (product.seller != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              product.seller!.businessName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return const BrowseCardMediaPlaceholder(
        kind: BrowseCardMediaKind.product,
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
