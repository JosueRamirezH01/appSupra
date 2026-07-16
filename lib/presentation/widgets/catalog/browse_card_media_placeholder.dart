import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum BrowseCardMediaKind { professional, product }

class BrowseCardMediaPlaceholder extends StatelessWidget {
  const BrowseCardMediaPlaceholder({
    super.key,
    required this.kind,
  });

  final BrowseCardMediaKind kind;

  @override
  Widget build(BuildContext context) {
    final icon = kind == BrowseCardMediaKind.professional
        ? Icons.engineering_outlined
        : Icons.inventory_2_outlined;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppBrandColors.fieldFill,
            AppBrandColors.fieldFill.withValues(alpha: 0.55),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 44,
          color: AppBrandColors.primaryGreen.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}

String formatBrowseDistanceKm(double? distanceKm) {
  if (distanceKm == null) return '';
  return '${distanceKm.toStringAsFixed(1)} km';
}

String formatBrowseRating(double? averageRating, int ratingCount) {
  if (averageRating == null || ratingCount <= 0) return '';
  return averageRating.toStringAsFixed(1);
}
