import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/seller_model.dart';

class SellerCatalogHeader extends StatelessWidget {
  const SellerCatalogHeader({
    super.key,
    required this.seller,
    this.categoryLabels = const [],
    this.onCall,
    this.onWhatsApp,
    this.onInfoTap,
    this.onEditLogo,
    this.updatingLogo = false,
  });

  final SellerPublicModel seller;
  final List<String> categoryLabels;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;
  final VoidCallback? onInfoTap;
  final VoidCallback? onEditLogo;
  final bool updatingLogo;

  @override
  Widget build(BuildContext context) {
    final showContact = onCall != null || onWhatsApp != null;
    final categories = categoryLabels.map((item) => item.trim()).where((item) => item.isNotEmpty).toList();
    final categoryLine = categories.isEmpty ? null
        : categories.length <= 2 ? categories.join(', ') : '${categories.take(2).join(', ')}…';

    return Material(
      color: Colors.white,
      elevation: 3,
      shadowColor: const Color(0x330B1C15),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _SellerLogo(
                  logoUrl: seller.logoUrl,
                  onEdit: onEditLogo,
                  updating: updatingLogo,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onInfoTap,
                      borderRadius: BorderRadius.circular(12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  seller.businessName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppBrandColors.textDark,
                                    height: 1.2,
                                  ),
                                ),
                                if (categoryLine != null || seller.verified) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (categoryLine != null)
                                        Expanded(
                                          child: Text(
                                            categoryLine,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: AppBrandColors.textMuted,
                                            ),
                                          ),
                                        )
                                      else
                                        const Spacer(),
                                      if (seller.verified) ...[
                                        const SizedBox(width: 8),
                                        const _VerifiedBadge(),
                                      ],
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (onInfoTap != null)
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.chevron_right_rounded,
                                color: AppBrandColors.textMuted,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (showContact) ...[
              const SizedBox(height: 12),
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
      ),
    );
  }
}

class _SellerLogo extends StatelessWidget {
  const _SellerLogo({
    this.logoUrl,
    this.onEdit,
    this.updating = false,
  });

  final String? logoUrl;
  final VoidCallback? onEdit;
  final bool updating;

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: updating
          ? const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : Builder(
              builder: (context) {
                if (logoUrl == null) {
                  return Icon(
                    Icons.storefront_rounded,
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.85),
                    size: 24,
                  );
                }

                final image = MediaUrlUtils.networkImage(logoUrl);
                if (image == null) {
                  return Icon(
                    Icons.storefront_rounded,
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.85),
                    size: 24,
                  );
                }

                return Image(image: image, fit: BoxFit.cover);
              },
            ),
    );

    if (onEdit == null) return logo;

    return GestureDetector(
      onTap: updating ? null : onEdit,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(top: 0, left: 0, child: logo),
            Positioned(
              right: 0,
              bottom: 0,
              child: Material(
                color: AppBrandColors.primaryGreen,
                shape: const CircleBorder(),
                elevation: 2,
                child: const Padding(
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
