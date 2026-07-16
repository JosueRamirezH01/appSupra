import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../providers/sellers/sellers_notifier.dart';

class ProductSellerProfileData {
  const ProductSellerProfileData({
    required this.businessName,
    this.logoUrl,
    this.verified = false,
    this.description,
    this.locationAddress,
    this.ruc,
    this.productCount,
    this.legalRepresentativeName,
  });

  factory ProductSellerProfileData.fromSeller(SellerPublicModel seller) {
    return ProductSellerProfileData(
      businessName: seller.businessName,
      logoUrl: seller.logoUrl,
      verified: seller.verified,
      description: seller.description,
      locationAddress: seller.locationAddress,
      ruc: seller.ruc,
      productCount: seller.productCount,
      legalRepresentativeName: seller.legalRepresentativeName,
    );
  }

  final String businessName;
  final String? logoUrl;
  final bool verified;
  final String? description;
  final String? locationAddress;
  final String? ruc;
  final int? productCount;
  final String? legalRepresentativeName;
}

class ProductSellerProfileSection extends ConsumerWidget {
  const ProductSellerProfileSection({
    super.key,
    this.sellerId,
    required this.fallback,
    this.onViewCatalog,
  });

  final int? sellerId;
  final ProductSellerProfileData fallback;
  final VoidCallback? onViewCatalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sellerId == null) {
      return _SellerProfileCard(
        data: fallback,
        onViewCatalog: onViewCatalog,
      );
    }

    final sellerAsync = ref.watch(sellerPublicProfileProvider(sellerId!));

    return sellerAsync.when(
      loading: () => const _SellerProfileCardSkeleton(),
      error: (_, _) => _SellerProfileCard(
        data: fallback,
        onViewCatalog: onViewCatalog,
      ),
      data: (seller) => _SellerProfileCard(
        data: ProductSellerProfileData.fromSeller(seller),
        onViewCatalog: onViewCatalog,
      ),
    );
  }
}

class _SellerProfileCard extends StatelessWidget {
  const _SellerProfileCard({
    required this.data,
    this.onViewCatalog,
  });

  final ProductSellerProfileData data;
  final VoidCallback? onViewCatalog;

  @override
  Widget build(BuildContext context) {
    final details = <_SellerDetailItem>[
      if (data.ruc != null && data.ruc!.trim().isNotEmpty)
        _SellerDetailItem(
          icon: Icons.badge_outlined,
          label: 'RUC',
          value: data.ruc!,
        ),
      if (data.locationAddress != null && data.locationAddress!.trim().isNotEmpty)
        _SellerDetailItem(
          icon: Icons.location_on_outlined,
          label: 'Ubicación',
          value: data.locationAddress!,
        ),
      if (data.productCount != null && data.productCount! > 0)
        _SellerDetailItem(
          icon: Icons.inventory_2_outlined,
          label: 'Catálogo',
          value:
              '${data.productCount} producto${data.productCount == 1 ? '' : 's'}',
        ),
      if (data.legalRepresentativeName != null &&
          data.legalRepresentativeName!.trim().isNotEmpty)
        _SellerDetailItem(
          icon: Icons.person_outline_rounded,
          label: 'Representante',
          value: data.legalRepresentativeName!,
        ),
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EAED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080B1C15),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppBrandColors.primaryGreen.withValues(alpha: 0.14),
                  AppBrandColors.fieldFill.withValues(alpha: 0.55),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SellerLogo(logoUrl: data.logoUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vendido por',
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppBrandColors.textMuted,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.businessName,
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppBrandColors.textDark,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (data.verified) const _VerifiedBadge(),
                          _TrustPill(
                            icon: Icons.storefront_rounded,
                            label: 'Empresa en Supra',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (details.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: details
                    .map((item) => _SellerDetailTile(item: item))
                    .toList(),
              ),
            ),
          if (data.description != null && data.description!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                data.description!.trim(),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  height: 1.55,
                  color: AppBrandColors.textDark,
                ),
              ),
            ),
          if (onViewCatalog != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.tonalIcon(
                  onPressed: onViewCatalog,
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        AppBrandColors.primaryGreen.withValues(alpha: 0.12),
                    foregroundColor: const Color(0xFF166534),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.storefront_outlined, size: 20),
                  label: Text(
                    'Ver catálogo del vendedor',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(16, onViewCatalog != null ? 12 : 14, 16, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.handshake_outlined,
                    size: 18,
                    color: AppBrandColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Contacta directamente para cotización, marcas y disponibilidad.',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Builder(
        builder: (context) {
          if (logoUrl == null) {
            return Icon(
              Icons.storefront_rounded,
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.8),
              size: 28,
            );
          }

          final image = MediaUrlUtils.networkImage(logoUrl);
          if (image == null) {
            return Icon(
              Icons.storefront_rounded,
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.8),
              size: 28,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF16A34A)),
          const SizedBox(width: 4),
          Text(
            'Verificado',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF15803D),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustPill extends StatelessWidget {
  const _TrustPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppBrandColors.textMuted),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerDetailItem {
  const _SellerDetailItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

class _SellerDetailTile extends StatelessWidget {
  const _SellerDetailTile({required this.item});

  final _SellerDetailItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 156,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(item.icon, size: 15, color: AppBrandColors.primaryGreen),
              const SizedBox(width: 6),
              Text(
                item.label,
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            item.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textDark,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerProfileCardSkeleton extends StatelessWidget {
  const _SellerProfileCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EAED)),
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
