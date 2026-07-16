import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/media_url_utils.dart';
import '../auth/auth_ui.dart';
import 'home_layout_metrics.dart';
import 'home_media_image.dart';
import 'home_media_placeholder.dart';

class HomeCategoryCircle extends StatelessWidget {
  const HomeCategoryCircle({
    super.key,
    required this.label,
    this.icon = defaultIcon,
    this.imageUrl,
    this.onTap,
    this.size,
    this.selected = false,
    this.labelColor,
    this.selectedBorderColor,
  });

  /// Fallback cuando la subcategoría no tiene `imageUrl` en el catálogo.
  static const IconData defaultIcon = Icons.category_outlined;

  final String label;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback? onTap;

  /// Tope manual opcional; si es null, se calcula con [HomeLayoutMetrics].
  final double? size;
  final bool selected;
  final Color? labelColor;
  final Color? selectedBorderColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final metrics = _resolveMetrics(
          context,
          maxHeight: constraints.maxHeight,
        );
        final labelWidth = metrics.avatarSize + 12;

        final column = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvatar(context, metrics.avatarSize, metrics.cornerRadius),
            SizedBox(height: metrics.spacing),
            SizedBox(
              width: labelWidth,
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: metrics.fontSize,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  height: 1.15,
                  color: labelColor ?? AppBrandColors.textDark,
                ),
              ),
            ),
          ],
        );

        final body = constraints.maxHeight.isFinite
            ? SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth.isFinite ? constraints.maxWidth : null,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.topCenter,
                  child: column,
                ),
              )
            : column;

        if (onTap == null) return body;

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: body,
        );
      },
    );
  }

  ({
    double avatarSize,
    double spacing,
    double fontSize,
    double cornerRadius,
  }) _resolveMetrics(
    BuildContext context, {
    required double maxHeight,
  }) {
    final avatarSize = HomeLayoutMetrics.categoryAvatarSize(
      context,
      maxHeight: maxHeight.isFinite ? maxHeight : null,
      maxSize: size,
    );

    return (
      avatarSize: avatarSize,
      spacing: HomeLayoutMetrics.categoryLabelSpacing(context),
      fontSize: HomeLayoutMetrics.categoryLabelFontSize(context),
      cornerRadius: HomeLayoutMetrics.categoryCornerRadius(avatarSize),
    );
  }

  Widget _buildAvatar(
    BuildContext context,
    double avatarSize,
    double cornerRadius,
  ) {
    final resolvedUrl = MediaUrlUtils.resolve(imageUrl);

    if (resolvedUrl == null || resolvedUrl.isEmpty) {
      return _avatarFrame(
        size: avatarSize,
        cornerRadius: cornerRadius,
        child: HomeMediaPlaceholder.category(icon: icon, size: avatarSize),
      );
    }

    return _avatarFrame(
      size: avatarSize,
      cornerRadius: cornerRadius,
      child: HomeMediaImage.categoryCircle(
        context: context,
        imageUrl: imageUrl,
        size: avatarSize,
        fallbackIcon: icon,
      ),
    );
  }

  Widget _avatarFrame({
    required double size,
    required double cornerRadius,
    required Widget child,
  }) {
    final borderColor = selected
        ? (selectedBorderColor ?? Colors.white)
        : const Color(0xFFE8EAED);
    final borderWidth = selected ? 2.5 : 1.0;
    final highlight = selectedBorderColor ?? AppBrandColors.primaryGreen;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cornerRadius),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: highlight.withValues(alpha: 0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x0F000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius),
            child: child,
          ),
          IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cornerRadius),
                border: Border.all(
                  color: borderColor,
                  width: borderWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeSeeMoreCircle extends StatelessWidget {
  const HomeSeeMoreCircle({
    super.key,
    required this.onTap,
    this.size,
  });

  final VoidCallback onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = HomeLayoutMetrics.categoryAvatarSize(
          context,
          maxHeight: constraints.maxHeight.isFinite ? constraints.maxHeight : null,
          maxSize: size,
        );
        final fontSize = HomeLayoutMetrics.categoryLabelFontSize(context);
        final spacing = HomeLayoutMetrics.categoryLabelSpacing(context);

        final content = _SeeMoreContent(
          size: circleSize,
          fontSize: fontSize,
          spacing: spacing,
        );

        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: constraints.maxHeight.isFinite
              ? SizedBox(
                  height: constraints.maxHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: content,
                  ),
                )
              : content,
        );
      },
    );
  }
}

class _SeeMoreContent extends StatelessWidget {
  const _SeeMoreContent({
    required this.size,
    required this.fontSize,
    required this.spacing,
  });

  final double size;
  final double fontSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF3F4F6),
            border: Border.all(color: const Color(0xFFE8EAED)),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: size * 0.3,
            color: AppBrandColors.primaryGreen,
          ),
        ),
        SizedBox(height: spacing),
        SizedBox(
          width: size + 8,
          child: Text(
            'Ver más',
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.primaryGreen,
            ),
          ),
        ),
      ],
    );
  }
}
