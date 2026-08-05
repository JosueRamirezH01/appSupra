import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/seller_model.dart';

class SellerCatalogHeader extends StatelessWidget {
  const SellerCatalogHeader({
    super.key,
    required this.seller,
    this.productCount,
    this.onCall,
    this.onWhatsApp,
  });

  final SellerPublicModel seller;
  final int? productCount;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;

  @override
  Widget build(BuildContext context) {
    final count = productCount ?? seller.productCount;
    final showContact = onCall != null || onWhatsApp != null;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EAED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080B1C15),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SellerLogo(logoUrl: seller.logoUrl),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Catálogo de',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      seller.businessName,
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (seller.verified) const _VerifiedBadge(),

                    if (seller.description?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 10),
                      Text(
                        seller.description!.trim(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          height: 1.45,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (showContact) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                if (onCall != null)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCall,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppBrandColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(
                          color: AppBrandColors.primaryGreen.withValues(
                            alpha: 0.45,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.phone_outlined, size: 18),
                      label: Text(
                        'Llamar',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                if (onCall != null && onWhatsApp != null)
                  const SizedBox(width: 10),
                if (onWhatsApp != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onWhatsApp,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppBrandColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.chat_outlined, size: 18),
                      label: Text(
                        'WhatsApp',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SellerLogo extends StatelessWidget {
  const _SellerLogo({this.logoUrl});

  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Builder(
        builder: (context) {
          if (logoUrl == null) {
            return Icon(
              Icons.storefront_rounded,
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.85),
              size: 26,
            );
          }

          final image = MediaUrlUtils.networkImage(logoUrl);
          if (image == null) {
            return Icon(
              Icons.storefront_rounded,
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.85),
              size: 26,
            );
          }

          return Image(image: image, fit: BoxFit.cover);
        },
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 13, color: Color(0xFF16A34A)),
          const SizedBox(width: 4),
          Text(
            'Verificado',
            style: GoogleFonts.montserrat(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 220),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppBrandColors.textMuted),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
