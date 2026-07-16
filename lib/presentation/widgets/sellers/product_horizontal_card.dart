import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../auth/auth_ui.dart';
import '../home/home_media_image.dart';
import 'seller_panel_widgets.dart';

class ProductHorizontalCard extends StatelessWidget {
  const ProductHorizontalCard({
    super.key,
    required this.product,
    required this.onTap,
    this.width = cardWidth,
    this.showStatusBadge = false,
  });

  static const double cardWidth = 168;

  /// Altura proporcional al ancho para evitar overflow en distintos DPI / text scale.
  static double cardHeightFor(double width) => width * 1.4;

  static double get cardHeight => cardHeightFor(cardWidth);

  final ProductPublicModel product;
  final VoidCallback onTap;
  final double width;
  final bool showStatusBadge;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImageUrl;
    final height = cardHeightFor(width);

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8EAED)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final padH = constraints.maxWidth * 0.06;
                final padTop = constraints.maxHeight * 0.04;
                final padBottom = constraints.maxHeight * 0.05;
                final gap = constraints.maxHeight * 0.03;
                final imageWidth = constraints.maxWidth - (padH * 2);

                return Padding(
                  padding: EdgeInsets.fromLTRB(padH, padTop, padH, padBottom),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 52,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: imageUrl == null
                                    ? ColoredBox(
                                        color: const Color(0xFFF3F4F6),
                                        child: Icon(
                                          Icons.inventory_2_outlined,
                                          size: imageWidth * 0.28,
                                        ),
                                      )
                                    : HomeMediaImage.workGalleryThumb(
                                        context: context,
                                        imageUrl:
                                            MediaUrlUtils.resolve(imageUrl)!,
                                        width: imageWidth,
                                        height: imageWidth,
                                      ),
                              ),
                            ),
                            if (showStatusBadge)
                              Positioned(
                                left: 6,
                                top: 6,
                                child: SellerProductStatusChip(
                                  status: product.status,
                                  compact: true,
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: gap),
                      Expanded(
                        flex: 48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: constraints.maxWidth * 0.078,
                                  fontWeight: FontWeight.w700,
                                  height: 1.15,
                                ),
                              ),
                            ),

                            SizedBox(height: constraints.maxHeight * 0.02),

                            _SellerVerifiedLabel(
                              verified: product.seller?.verified ?? false,
                            ),
                            if (product.seller != null) ...[
                              SizedBox(height: constraints.maxHeight * 0.012),
                              Text(
                                product.seller!.businessName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
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
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SellerVerifiedLabel extends StatelessWidget {
  const _SellerVerifiedLabel({required this.verified});

  final bool verified;

  @override
  Widget build(BuildContext context) {
    final color =
        verified ? AppBrandColors.primaryGreen : AppBrandColors.textMuted;

    return Row(
      children: [
        Icon(
          verified ? Icons.verified_rounded : Icons.info_outline_rounded,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            verified ? 'Vendedor verificado' : 'Sin verificar',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
