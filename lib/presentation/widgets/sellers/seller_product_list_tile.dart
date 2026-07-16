import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../utils/seller_product_publish_status.dart';
import '../home/home_media_image.dart';
import 'seller_panel_widgets.dart';

class SellerProductListTile extends StatelessWidget {
  const SellerProductListTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  final ProductPublicModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImageUrl;
    final meta = SellerProductStatusMeta.of(product.status);
    final isPublished = isSellerProductPublished(product.status);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: meta.color, width: 4),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 72,
                        height: 72,
                        child: imageUrl == null
                            ? ColoredBox(
                                color: const Color(0xFFF3F4F6),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: Colors.grey.shade500,
                                ),
                              )
                            : ColorFiltered(
                                colorFilter: isPublished
                                    ? const ColorFilter.mode(
                                        Colors.transparent,
                                        BlendMode.dst,
                                      )
                                    : ColorFilter.mode(
                                        Colors.black.withValues(alpha: 0.08),
                                        BlendMode.darken,
                                      ),
                                child: HomeMediaImage.workGalleryThumb(
                                  context: context,
                                  imageUrl: MediaUrlUtils.resolve(imageUrl)!,
                                  width: 72,
                                  height: 72,
                                ),
                              ),
                      ),
                    ),
                    if (!isPublished)
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: CircleAvatar(
                          radius: 11,
                          backgroundColor: meta.color,
                          child: Icon(meta.icon, size: 12, color: Colors.white),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SellerProductStatusChip(status: product.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.subcategoryName,
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meta.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          color: meta.color,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (product.description != null &&
                          product.description!.trim().isNotEmpty)
                        Text(
                          product.description!.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: const Color(0xFF4B5563),
                            height: 1.3,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
