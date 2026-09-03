import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/product_sale_unit.dart';
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
    this.saleUnit,
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
      saleUnit: product.saleUnit,
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
      saleUnit: preview.saleUnit,
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
  final String? saleUnit;
  final List<String> materialLabels;
  final List<ProductClientImageSource> images;
  final int? sellerId;
  final String? sellerBusinessName;
  final String? sellerLogoUrl;
  final bool sellerVerified;
  final double? distanceKm;

  bool get hasOffer =>
      price != null && compareAtPrice != null && compareAtPrice! > price!;

  int? get discountPercent {
    if (!hasOffer) return null;
    final pct = (((compareAtPrice! - price!) / compareAtPrice!) * 100).round();
    return pct > 0 ? pct : null;
  }

  ProductSellerProfileData get sellerProfileFallback => ProductSellerProfileData(
        businessName: sellerBusinessName ?? 'Vendedor',
        logoUrl: sellerLogoUrl,
        verified: sellerVerified,
      );
}

/// Ficha de producto (cliente / preview / dueño).
/// Orden: foto → categoría → título → precio → materiales → descripción → vendedor.
class ProductClientDetailView extends StatelessWidget {
  const ProductClientDetailView({
    super.key,
    required this.content,
    this.isPreview = false,
    this.isOwner = false,
    this.bottomBar,
    this.onViewCatalog,
    this.appBarTitle,
    this.onBack,
    this.leadingIcon = Icons.arrow_back_ios_new_rounded,
    this.actions,
    this.onEditPhoto,
    this.onEditName,
    this.onEditPrice,
    this.onEditDescription,
    this.isStarred = false,
    this.onToggleStarred,
  });

  final ProductClientDetailContent content;
  final bool isPreview;
  final bool isOwner;
  final Widget? bottomBar;
  final VoidCallback? onViewCatalog;
  final String? appBarTitle;
  final VoidCallback? onBack;
  final IconData leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? onEditPhoto;
  final VoidCallback? onEditName;
  final VoidCallback? onEditPrice;
  final VoidCallback? onEditDescription;
  final bool isStarred;
  final VoidCallback? onToggleStarred;

  @override
  Widget build(BuildContext context) {
    final description = content.description?.trim();
    final hasDescription = description != null && description.isNotEmpty;
    final materials = content.materialLabels
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .toList(growable: false);

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
                  backgroundColor: AppBrandColors.scaffoldBackground,
                  foregroundColor: AppBrandColors.textDark,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  centerTitle: false,
                  titleSpacing: 4,
                  leading: IconButton(
                    tooltip: 'Volver',
                    icon: Icon(leadingIcon, size: 20),
                    onPressed:
                        onBack ?? () => Navigator.of(context).maybePop(),
                  ),
                  title: appBarTitle == null
                      ? null
                      : Text(
                          appBarTitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                  actions: actions,
                ),
                SliverToBoxAdapter(
                  child: _ProductHero(
                    images: content.images,
                    discountPercent: content.discountPercent,
                    onAddPhotos: isOwner ? onEditPhoto : null,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          content.subcategoryName,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppBrandColors.primaryGreen,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _EditableBlock(
                          onEdit: isOwner ? onEditName : null,
                          child: Text(
                            content.title,
                            style: GoogleFonts.montserrat(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppBrandColors.textDark,
                              height: 1.2,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (content.price != null)
                          _EditableBlock(
                            onEdit: isOwner ? onEditPrice : null,
                            child: _ProductDetailPrice(
                              price: content.price!,
                              compareAtPrice: content.compareAtPrice,
                              saleUnit: content.saleUnit,
                              discountPercent: content.discountPercent,
                            ),
                          )
                        else if (isOwner && onEditPrice != null)
                          _TextAction(
                            icon: Icons.sell_outlined,
                            label: 'Agregar precio referencial',
                            onPressed: onEditPrice!,
                          )
                        else
                          Text(
                            'Consultar precio con el vendedor',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppBrandColors.textMuted,
                            ),
                          ),
                        if (isOwner && onToggleStarred != null) ...[
                          const SizedBox(height: 16),
                          _OwnerStarredToggle(
                            isStarred: isStarred,
                            onTap: onToggleStarred!,
                          ),
                        ],
                        if (materials.isNotEmpty) ...[
                          const SizedBox(height: 22),
                          const _SectionLabel('Materiales'),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final label in materials)
                                _ToneChip(label: label),
                            ],
                          ),
                        ],
                        if (hasDescription) ...[
                          const SizedBox(height: 22),
                          _EditableBlock(
                            onEdit: isOwner ? onEditDescription : null,
                            child: _ExpandableDescription(text: description),
                          ),
                        ] else if (isOwner && onEditDescription != null) ...[
                          const SizedBox(height: 18),
                          _TextAction(
                            icon: Icons.notes_outlined,
                            label: 'Agregar descripción',
                            onPressed: onEditDescription!,
                          ),
                        ],
                        if (content.sellerBusinessName != null) ...[
                          const SizedBox(height: 24),
                          const _SectionLabel('Vendedor'),
                          const SizedBox(height: 10),
                          ProductSellerProfileSection(
                            sellerId: isPreview ? null : content.sellerId,
                            fallback: content.sellerProfileFallback,
                            onViewCatalog: isPreview ? null : onViewCatalog,
                            compact: true,
                          ),
                        ],
                      ],
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

class _ProductHero extends StatelessWidget {
  const _ProductHero({
    required this.images,
    this.discountPercent,
    this.onAddPhotos,
  });

  final List<ProductClientImageSource> images;
  final int? discountPercent;
  final VoidCallback? onAddPhotos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = width / ProductDetailImageGallery.aspectRatio;

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductDetailImageGallery(
                images: images,
                viewportWidth: width,
                heroMode: true,
              ),
              if (discountPercent != null)
                Positioned(
                  left: 12,
                  top: 12,
                  child: _DiscountBadge(percent: discountPercent!),
                ),
              if (onAddPhotos != null)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Material(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      onTap: onAddPhotos,
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.add_a_photo_outlined,
                              size: 15,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              images.isEmpty ? 'Agregar fotos' : 'Agregar foto',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EditableBlock extends StatelessWidget {
  const _EditableBlock({required this.child, this.onEdit});

  final Widget child;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    if (onEdit == null) return child;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onEdit,
            behavior: HitTestBehavior.opaque,
            child: child,
          ),
        ),
        IconButton(
          tooltip: 'Editar',
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          color: AppBrandColors.primaryGreen,
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined, size: 18),
        ),
      ],
    );
  }
}

class _OwnerStarredToggle extends StatelessWidget {
  const _OwnerStarredToggle({
    required this.isStarred,
    required this.onTap,
  });

  final bool isStarred;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isStarred ? const Color(0xFFFFF7ED) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isStarred
                    ? AppBrandColors.promoAmber
                    : AppBrandColors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isStarred
                          ? 'Destacado en tu tienda'
                          : 'Destacar en tu tienda',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    Text(
                      'Solo tú lo ves. El cliente no ve diferencia.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppBrandColors.primaryGreen,
        padding: EdgeInsets.zero,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: AppBrandColors.textDark,
        letterSpacing: 0.15,
      ),
    );
  }
}

class _ToneChip extends StatelessWidget {
  const _ToneChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF166534),
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppBrandColors.promoAmber,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '-$percent%',
        style: GoogleFonts.montserrat(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.white,
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
          const Icon(
            Icons.visibility_outlined,
            color: Color(0xFF2563EB),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Así lo verá el cliente. El contacto se activa al publicar.',
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
    this.saleUnit,
    this.discountPercent,
  });

  final double price;
  final double? compareAtPrice;
  final String? saleUnit;
  final int? discountPercent;

  @override
  Widget build(BuildContext context) {
    final hasOffer = compareAtPrice != null && compareAtPrice! > price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasOffer) ...[
          Row(
            children: [
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
              if (discountPercent != null) ...[
                const SizedBox(width: 8),
                Text(
                  '-$discountPercent%',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.promoAmber,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 2),
        ],
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: formatProductSoles(price),
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppBrandColors.textDark,
                  height: 1.1,
                ),
              ),
              TextSpan(
                text: ' / ${productSaleUnitCardSuffix(saleUnit)}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppBrandColors.textMuted,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${formatProductSaleUnitPhrase(saleUnit)} · precio referencial · cotiza con el vendedor',
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

class _ExpandableDescription extends StatefulWidget {
  const _ExpandableDescription({required this.text});

  final String text;

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  static const _collapsedLines = 5;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionLabel('Descripción'),
        const SizedBox(height: 8),
        Text(
          widget.text,
          maxLines: _expanded ? null : _collapsedLines,
          overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            height: 1.55,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF374151),
          ),
        ),
        if (widget.text.length > 180) ...[
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Ver menos' : 'Ver más',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppBrandColors.primaryGreen,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
