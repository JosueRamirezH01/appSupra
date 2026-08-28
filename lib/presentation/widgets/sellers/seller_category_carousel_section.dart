import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/sellers/product_model.dart';
import '../products/product_grid_card.dart';
import 'product_horizontal_card.dart';

class SellerCategoryCarouselSection extends StatefulWidget {
  const SellerCategoryCarouselSection({
    super.key,
    required this.title,
    required this.products,
    required this.onProductTap,
    this.highlightedProductId,
    this.onAdd,
    this.onEditPhoto,
    this.onEditName,
    this.onEditPrice,
    this.onToggleStarred,
    this.uploadingProductId,
  });

  final String title;
  final List<ProductPublicModel> products;
  final ValueChanged<int> onProductTap;
  final int? highlightedProductId;
  final VoidCallback? onAdd;
  final ValueChanged<ProductPublicModel>? onEditPhoto;
  final ValueChanged<ProductPublicModel>? onEditName;
  final ValueChanged<ProductPublicModel>? onEditPrice;
  final ValueChanged<ProductPublicModel>? onToggleStarred;
  final int? uploadingProductId;

  static const cardWidth = 145.0;
  static const _shadowTop = 4.0;
  static const _shadowBottom = 14.0;

  @override
  State<SellerCategoryCarouselSection> createState() =>
      _SellerCategoryCarouselSectionState();
}

class _SellerCategoryCarouselSectionState
    extends State<SellerCategoryCarouselSection> {
  final _listController = ScrollController();

  bool get _ownerEdit =>
      widget.onEditPhoto != null &&
      widget.onEditName != null &&
      widget.onEditPrice != null;

  @override
  void didUpdateWidget(covariant SellerCategoryCarouselSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.products.length < widget.products.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_listController.hasClients) return;
        _listController.animateTo(
          _listController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty && widget.onAdd == null) {
      return const SizedBox.shrink();
    }

    final showOwnerStar = widget.onToggleStarred != null && _ownerEdit;
    final cardHeight = ProductHorizontalCard.cardHeightFor(
      SellerCategoryCarouselSection.cardWidth,
      showOwnerStar: showOwnerStar,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Text(
            widget.title,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppBrandColors.textDark,
              letterSpacing: -0.3,
            ),
          ),
        ),
        if (_ownerEdit)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
            child: Text(
              widget.products.isEmpty
                  ? 'Saca una foto y ponle nombre. El precio lo puedes agregar después.'
                  : 'Toca la card para ver · lápiz para editar · estrella abajo para destacar',
              style: GoogleFonts.poppins(
                fontSize: 11.5,
                height: 1.3,
                color: AppBrandColors.textMuted,
              ),
            ),
          )
        else
          const SizedBox(height: 8),
        if (widget.products.isEmpty && widget.onAdd != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _EmptyCategoryCard(onAdd: widget.onAdd!),
          )
        else
          SizedBox(
            height: cardHeight +
                SellerCategoryCarouselSection._shadowTop +
                SellerCategoryCarouselSection._shadowBottom,
            child: ListView.separated(
              controller: _listController,
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                16,
                SellerCategoryCarouselSection._shadowTop,
                16,
                SellerCategoryCarouselSection._shadowBottom,
              ),
              itemCount: widget.products.length + (widget.onAdd != null ? 1 : 0),
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                if (index >= widget.products.length) {
                  return _AddProductTile(
                    width: SellerCategoryCarouselSection.cardWidth,
                    height: cardHeight,
                    onTap: widget.onAdd!,
                  );
                }

                final product = widget.products[index];
                return ProductHorizontalCard(
                  product: product,
                  width: SellerCategoryCarouselSection.cardWidth,
                  showSellerInfo: false,
                  isHighlighted: product.id == widget.highlightedProductId,
                  onTap: () => widget.onProductTap(product.id),
                  ownerActions: _ownerEdit
                      ? ProductCardOwnerActions(
                          onEditPhoto: () => widget.onEditPhoto!(product),
                          onEditName: () => widget.onEditName!(product),
                          onEditPrice: () => widget.onEditPrice!(product),
                          onToggleStarred: widget.onToggleStarred == null
                              ? null
                              : () => widget.onToggleStarred!(product),
                          isUploadingPhoto:
                              widget.uploadingProductId == product.id,
                        )
                      : null,
                );
              },
            ),
          ),
      ],
    );
  }
}

class _EmptyCategoryCard extends StatelessWidget {
  const _EmptyCategoryCard({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppBrandColors.primaryGreen.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          HapticFeedback.selectionClick();
          onAdd();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppBrandColors.primaryGreen.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aún no hay productos',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Foto y nombre para publicarlo en este rubro.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.35,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppBrandColors.primaryGreen,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddProductTile extends StatelessWidget {
  const _AddProductTile({
    required this.width,
    required this.height,
    required this.onTap,
  });

  final double width;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppBrandColors.primaryGreen.withValues(alpha: 0.06),
                    border: Border.all(
                      color: AppBrandColors.primaryGreen.withValues(alpha: 0.35),
                      width: 1.4,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppBrandColors.primaryGreen.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Agregar\nproducto',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppBrandColors.primaryGreen,
                          height: 1.2,
                        ),
                      ),
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
