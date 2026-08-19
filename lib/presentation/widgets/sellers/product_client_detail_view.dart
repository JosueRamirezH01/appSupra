import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../../models/seller_product_preview_model.dart';
import 'product_client_image_source.dart';
import 'product_detail_image_gallery.dart';
import 'product_referential_pricing_fields.dart';
import 'product_seller_profile_section.dart';

class ProductClientDetailContent {
  const ProductClientDetailContent({
    required this.title,
    required this.subcategoryName,
    this.description,
    this.price,
    this.compareAtPrice,
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
      price: product.price,
      compareAtPrice: product.compareAtPrice,
      materialLabels: product.materialLabels,
      images: product.images
          .map((image) => ProductClientImageSource.network(image.imageUrl))
          .toList(),
      sellerId: product.sellerId,
      sellerBusinessName: product.seller?.businessName,
      sellerLogoUrl: product.seller?.logoUrl,
      sellerVerified: product.seller?.verified ?? false,
      distanceKm: product.distanceKm,
    );
  }

  factory ProductClientDetailContent.fromPreview(
    SellerProductPreviewModel preview,
  ) {
    return ProductClientDetailContent(
      title: preview.title,
      subcategoryName: preview.subcategoryName,
      description: preview.description,
      price: preview.price,
      compareAtPrice: preview.compareAtPrice,
      materialLabels: preview.materialLabels,
      images: preview.images
          .map(
            (image) => image.file != null
                ? ProductClientImageSource.local(image.file!)
                : ProductClientImageSource.network(image.url!),
          )
          .toList(),
      sellerBusinessName: preview.sellerBusinessName,
      sellerLogoUrl: preview.sellerLogoUrl,
      sellerVerified: preview.sellerVerified,
    );
  }

  final String title;
  final String subcategoryName;
  final String? description;
  final double? price;
  final double? compareAtPrice;
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

/// Detalle de producto (cliente / preview).
/// Jerarquía: hero híbrido → título → chips → descripción → materiales → vendedor.
/// CTA de contacto vive en [bottomBar] (fuera del scroll).
class ProductClientDetailView extends StatelessWidget {
  const ProductClientDetailView({
    super.key,
    required this.content,
    this.isPreview = false,
    this.isOwner = false,
    this.bottomBar,
    this.onViewCatalog,
    this.appBarTitle = 'Detalle del producto',
    this.onBack,
    this.leadingIcon = Icons.arrow_back_ios_new_rounded,
    this.actions,
    this.onEditPhoto,
    this.onEditName,
    this.onEditPrice,
    this.onEditDescription,
  });

  final ProductClientDetailContent content;
  final bool isPreview;
  final bool isOwner;
  final Widget? bottomBar;
  final VoidCallback? onViewCatalog;
  final String appBarTitle;
  final VoidCallback? onBack;
  final IconData leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? onEditPhoto;
  final VoidCallback? onEditName;
  final VoidCallback? onEditPrice;
  final VoidCallback? onEditDescription;

  static const _heroChrome = Color(0xFF0B1C15);
  static const _heroSideInset = 16.0;
  static const _heroTopGap = 8.0;
  static const _heroBottomGap = 14.0;
  static const _heroRadius = 20.0;
  static const _sheetOverlap = 18.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final topInset = media.padding.top;
    final galleryWidth = screenWidth - (_heroSideInset * 2);
    final galleryHeight =
        galleryWidth / ProductDetailImageGallery.aspectRatio;
    // AppBar sólido + imagen debajo (como la referencia), no detrás del título.
    final expandedHeight = topInset + kToolbarHeight + _heroTopGap + galleryHeight + _heroBottomGap;
    final description = content.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final galleryTop = topInset + kToolbarHeight + _heroTopGap;

    return ColoredBox(
      color: AppBrandColors.scaffoldBackground,
      child: Column(
        children: [
          if (isPreview) const _PreviewBanner(),
          Expanded(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  stretch: false,
                  expandedHeight: expandedHeight,
                  backgroundColor: _heroChrome,
                  foregroundColor: Colors.white,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  forceElevated: false,
                  centerTitle: false,
                  titleSpacing: 4,
                  leadingWidth: 60,
                  leading: _CircleBackButton(
                    icon: leadingIcon,
                    onPressed:
                        onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                  title: Text(
                    appBarTitle,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFF3F4F6),
                      fontSize: 16,
                      letterSpacing: -0.15,
                    ),
                  ),
                  actions: actions,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: ColoredBox(
                      color: _heroChrome,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            left: _heroSideInset,
                            right: _heroSideInset,
                            top: galleryTop,
                            bottom: _heroBottomGap,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(_heroRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.28),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(_heroRadius),
                                child: ProductDetailImageGallery(
                                  images: content.images,
                                  viewportWidth: galleryWidth,
                                  heroMode: true,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Hoja de contenido: se “engancha” bajo el hero (como la mock).
                // Transform.translate no mueve el layout del sliver; el overlap
                // visual viene del padding negativo vía margin top negativo
                // en un contenedor con clip.
                // Usamos padding top pequeño + radio superior para transición.
                SliverToBoxAdapter(
                  child: Transform.translate(
                    offset: const Offset(0, -_sheetOverlap),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: AppBrandColors.scaffoldBackground,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isOwner && onEditName != null) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: onEditName,
                                    behavior: HitTestBehavior.opaque,
                                    child: Text(
                                      content.title,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w800,
                                        color: AppBrandColors.textDark,
                                        height: 1.18,
                                        letterSpacing: -0.35,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  color: AppBrandColors.primaryGreen,
                                  onPressed: onEditName, icon:  Icon(Icons.edit_outlined),
                                ),
                              ],
                            )
                          ]
                          else
                            Text(
                              content.title,
                              style: GoogleFonts.montserrat(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                color: AppBrandColors.textDark,
                                height: 1.18,
                                letterSpacing: -0.35,
                              ),
                            ),

                          if (isOwner && onEditPhoto != null) ...[
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: onEditPhoto,
                              icon: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 18,
                              ),
                              label: Text(
                                'Agregar fotos',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: AppBrandColors.primaryGreen,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppBrandColors.primaryGreen
                                      .withValues(alpha: 0.45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],

                          if (content.price != null) ...[
                            const SizedBox(height: 10),
                            if (isOwner && onEditPrice != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: onEditPrice,
                                      behavior: HitTestBehavior.opaque,
                                      child: _ProductDetailPrice(
                                        price: content.price!,
                                        compareAtPrice: content.compareAtPrice,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    color: AppBrandColors.primaryGreen,
                                    onPressed: onEditPrice, icon: Icon(Icons.edit_outlined),
                                  ),
                                ],
                              )
                            else
                              _ProductDetailPrice(
                                price: content.price!,
                                compareAtPrice: content.compareAtPrice,
                              ),
                          ],
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _ToneChip(
                                label: content.subcategoryName,
                                foreground: const Color(0xFF166534),
                                background: AppBrandColors.fieldFill,
                              ),
                              if (content.sellerVerified)
                                const _ToneChip(
                                  label: 'Verificado',
                                  icon: Icons.verified_rounded,
                                  foreground: Color(0xFF15803D),
                                  background: Color(0xFFDCFCE7),
                                ),
                              /*if (content.distanceKm != null)
                                _ToneChip(
                                  label:
                                      '${content.distanceKm!.toStringAsFixed(1)} km',
                                  icon: Icons.near_me_outlined,
                                  foreground: AppBrandColors.textMuted,
                                  background: const Color(0xFFEEF2F0),
                                ),*/
                            ],
                          ),
                          if (hasDescription) ...[
                            const SizedBox(height: 18),
                            if (isOwner && onEditDescription != null)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: onEditDescription,
                                      behavior: HitTestBehavior.opaque,
                                      child: Text(
                                        description,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 15,
                                          height: 1.6,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF374151),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    color: AppBrandColors.primaryGreen,
                                    onPressed: onEditDescription, icon: Icon(Icons.edit_outlined)
                                  ),
                                ],
                              )
                            else
                              Text(
                                description,
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  height: 1.6,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                          ] else if (isOwner && onEditDescription != null) ...[
                            OutlinedButton.icon(
                              onPressed: onEditDescription,
                              icon: const Icon(
                                Icons.add_rounded,
                                size: 18,
                              ),
                              label: Text(
                                'Agregar descripción',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  color: AppBrandColors.primaryGreen,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: AppBrandColors.primaryGreen
                                      .withValues(alpha: 0.45),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                          if (content.sellerBusinessName != null) ...[
                            const SizedBox(height: 24),
                            ProductSellerProfileSection(
                              sellerId: isPreview ? null : content.sellerId,
                              fallback: content.sellerProfileFallback,
                              onViewCatalog:
                                  isPreview ? null : onViewCatalog,
                              compact: true,
                            ),
                          ],
                          // Compensa el translate para no cortar el final.
                          const SizedBox(height: _sheetOverlap),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (bottomBar != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  top: BorderSide(color: Color(0xFFE8EAED)),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 14,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: bottomBar!,
              ),
            ),
        ],
      ),
    );
  }
}

class _CircleBackButton extends StatelessWidget {
  const _CircleBackButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: const Color(0xFF1A2E24),
        shape: const CircleBorder(
          side: BorderSide(color: Color(0x33FFFFFF)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, color: const Color(0xFFF3F4F6), size: 17),
          ),
        ),
      ),
    );
  }
}

class _ToneChip extends StatelessWidget {
  const _ToneChip({
    required this.label,
    required this.foreground,
    required this.background,
    this.icon,
  });

  final String label;
  final Color foreground;
  final Color background;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
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
          const Icon(
            Icons.visibility_outlined,
            color: Color(0xFF2563EB),
            size: 20,
          ),
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

class _ProductDetailPrice extends StatelessWidget {
  const _ProductDetailPrice({
    required this.price,
    this.compareAtPrice,
  });

  final double price;
  final double? compareAtPrice;

  @override
  Widget build(BuildContext context) {
    final hasOffer = compareAtPrice != null && compareAtPrice! > price;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasOffer)
          Text(
            formatProductSoles(compareAtPrice!),
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppBrandColors.textMuted,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppBrandColors.textMuted,
            ),
          ),
        Text(
          formatProductSoles(price),
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Precio referencial · Cotizar ahora',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppBrandColors.textMuted,
          ),
        ),
      ],
    );
  }
}
