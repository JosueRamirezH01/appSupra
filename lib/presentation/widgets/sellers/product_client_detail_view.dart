
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../models/seller_product_preview_model.dart';
import 'product_catalog_fields.dart';
import 'product_client_image_source.dart';
import 'product_detail_image_gallery.dart';
import 'product_seller_profile_section.dart';

class ProductClientDetailContent {
  const ProductClientDetailContent({
    required this.title,
    required this.subcategoryName,
    this.description,
    this.materialLabels = const [],
    required this.images,
    this.sellerId,
    this.sellerBusinessName,
    this.sellerLogoUrl,
    this.sellerVerified = false,
    this.distanceKm,
  });

  factory ProductClientDetailContent.fromProduct(ProductPublicModel product) {
    return ProductClientDetailContent(
      title: product.title,
      subcategoryName: product.subcategoryName,
      description: product.description,
      materialLabels: product.materialLabels,
      images: product.images.map((image) => ProductClientImageSource.network(image.imageUrl),).toList(),
      sellerId: product.sellerId,
      sellerBusinessName: product.seller?.businessName,
      sellerLogoUrl: product.seller?.logoUrl,
      sellerVerified: product.seller?.verified ?? false,
      distanceKm: product.distanceKm,
    );
  }

  factory ProductClientDetailContent.fromPreview(SellerProductPreviewModel preview) {
    return ProductClientDetailContent(
      title: preview.title,
      subcategoryName: preview.subcategoryName,
      description: preview.description,
      materialLabels: preview.materialLabels,
      images: preview.images.map((image) => image.file != null ? ProductClientImageSource.local(image.file!) : ProductClientImageSource.network(image.url!),).toList(),
      sellerBusinessName: preview.sellerBusinessName,
      sellerLogoUrl: preview.sellerLogoUrl,
      sellerVerified: preview.sellerVerified,
    );
  }

  final String title;
  final String subcategoryName;
  final String? description;
  final List<String> materialLabels;
  final List<ProductClientImageSource> images;
  final int? sellerId;
  final String? sellerBusinessName;
  final String? sellerLogoUrl;
  final bool sellerVerified;
  final double? distanceKm;

  ProductSellerProfileData get sellerProfileFallback => ProductSellerProfileData(
        businessName: sellerBusinessName ?? 'Vendedor',
        logoUrl: sellerLogoUrl,
        verified: sellerVerified,
      );
}

class ProductClientDetailView extends StatefulWidget {
  const ProductClientDetailView({
    super.key,
    required this.content,
    this.isPreview = false,
    this.bottomBar,
    this.onViewCatalog,
  });

  final ProductClientDetailContent content;
  final bool isPreview;
  final Widget? bottomBar;
  final VoidCallback? onViewCatalog;

  @override
  State<ProductClientDetailView> createState() => _ProductClientDetailViewState();
}

class _ProductClientDetailViewState extends State<ProductClientDetailView> {
  @override
  Widget build(BuildContext context) {
    final content = widget.content;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return ColoredBox(
      color: AppBrandColors.scaffoldBackground,
      child: Column(
        children: [
          if (widget.isPreview) const _PreviewBanner(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ProductDetailImageGallery(
                  images: content.images,
                  viewportWidth: screenWidth,
                ),
                Transform.translate(
                  offset: const Offset(0, -18),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        _ProductHeroCard(content: content),
                        const SizedBox(height: 14),
                        if (content.materialLabels.isNotEmpty)
                          _ProductSectionCard(
                            title: 'Materiales que comercializa',
                            icon: Icons.category_outlined,
                            child: ProductMaterialChips(labels: content.materialLabels),
                          ),
                        _ProductSectionCard(
                          title: 'Cómo comprar',
                          icon: Icons.support_agent_outlined,
                          child: const _ConsultationBanner(),
                        ),
                        if (content.description != null &&
                            content.description!.trim().isNotEmpty)
                          _ProductSectionCard(
                            title: 'Descripción del producto',
                            icon: Icons.description_outlined,
                            child: Text(
                              content.description!.trim(),
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                height: 1.6,
                                color: AppBrandColors.textDark,
                              ),
                            ),
                          ),
                        if (content.sellerBusinessName != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Sobre el vendedor',
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppBrandColors.textMuted,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ProductSellerProfileSection(
                            sellerId: widget.isPreview ? null : content.sellerId,
                            fallback: content.sellerProfileFallback,
                            onViewCatalog: widget.isPreview ? null : widget.onViewCatalog,
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.bottomBar != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: widget.bottomBar!,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductHeroCard extends StatelessWidget {
  const _ProductHeroCard({required this.content});

  final ProductClientDetailContent content;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EAED)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ProductSubcategoryChip(label: content.subcategoryName),
              if (content.sellerVerified)
                const _HeroMetaChip(
                  icon: Icons.verified_rounded,
                  label: 'Vendedor verificado',
                  color: Color(0xFF16A34A),
                  background: Color(0xFFDCFCE7),
                ),
              if (content.materialLabels.isNotEmpty)
                _HeroMetaChip(
                  icon: Icons.layers_outlined,
                  label:
                      '${content.materialLabels.length} material${content.materialLabels.length == 1 ? '' : 'es'}',
                  color: const Color(0xFF2563EB),
                  background: const Color(0xFFEFF6FF),
                ),
              if (content.distanceKm != null)
                _HeroMetaChip(
                  icon: Icons.near_me_outlined,
                  label: '${content.distanceKm!.toStringAsFixed(1)} km',
                  color: AppBrandColors.textMuted,
                  background: const Color(0xFFF3F4F6),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content.title,
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppBrandColors.textDark,
              height: 1.2,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Material de construcción disponible con asesoría directa del vendedor.',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              height: 1.45,
              color: AppBrandColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetaChip extends StatelessWidget {
  const _HeroMetaChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSectionCard extends StatelessWidget {
  const _ProductSectionCard({
    required this.title,
    required this.child,
    this.icon,
  });

  final String title;
  final Widget child;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              decoration: BoxDecoration(
                color: AppBrandColors.fieldFill.withValues(alpha: 0.45),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppBrandColors.primaryGreen.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 17,
                        color: AppBrandColors.primaryGreen,
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewBanner extends StatelessWidget {
  const _PreviewBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEFF6FF),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.visibility_outlined, color: Color(0xFF2563EB), size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Vista previa del cliente. Así verán tu catálogo de materiales.',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1D4ED8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsultationBanner extends StatelessWidget {
  const _ConsultationBanner();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFF16A34A),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Consulta directa con el vendedor',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Pregunta por disponibilidad, marcas, medidas y cotización sin compromiso.',
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      height: 1.45,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _ConsultationStepChip(label: 'Disponibilidad'),
            _ConsultationStepChip(label: 'Marcas'),
            _ConsultationStepChip(label: 'Cotización'),
          ],
        ),
      ],
    );
  }
}

class _ConsultationStepChip extends StatelessWidget {
  const _ConsultationStepChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF166534),
        ),
      ),
    );
  }
}
