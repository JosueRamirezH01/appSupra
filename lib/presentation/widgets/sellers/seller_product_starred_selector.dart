import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../technician/technician_panel_theme.dart';

class SellerProductStarredSelector extends StatelessWidget {
  const SellerProductStarredSelector({
    super.key,
    required this.isStarred,
    required this.starredCount,
    required this.onChanged,
    this.enabled = true,
  });

  final bool isStarred;
  final int starredCount;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  static const _limit = CatalogConstants.sellerStarredProductLimit;

  bool get _atCap => !isStarred && starredCount >= _limit;

  @override
  Widget build(BuildContext context) {
    final canToggle = enabled && !_atCap;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Producto estrella',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Solo tú lo ves en Mi tienda. El cliente no ve ninguna diferencia.',
          style: TechnicianPanelTheme.subtitle,
        ),
        const SizedBox(height: 12),
        Material(
          color: isStarred
              ? const Color(0xFFFFF7ED)
              : TechnicianPanelColors.surface,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: canToggle ? () => onChanged(!isStarred) : null,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isStarred
                      ? AppBrandColors.promoAmber.withValues(alpha: 0.45)
                      : TechnicianPanelColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isStarred
                        ? AppBrandColors.promoAmber
                        : TechnicianPanelColors.inkSoft,
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
                            color: TechnicianPanelColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _atCap
                              ? 'Ya tienes $_limit productos estrella. Quita uno para destacar este.'
                              : '$starredCount de $_limit',
                          style: TechnicianPanelTheme.subtitle.copyWith(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: isStarred,
                    onChanged: canToggle ? onChanged : null,
                    activeTrackColor: AppBrandColors.promoAmber,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
