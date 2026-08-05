import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/sellers/seller_catalog_provider.dart';

/// Chips: Todos (N) + subcategorías del vendedor.
class SellerCatalogFilterChips extends StatelessWidget {
  const SellerCatalogFilterChips({
    super.key,
    required this.allTotal,
    required this.facets,
    required this.selectedSubcategoryId,
    required this.onSelected,
  });

  final int allTotal;
  final List<SellerCatalogFacet> facets;
  final int? selectedSubcategoryId;
  final ValueChanged<int?> onSelected;

  @override
  Widget build(BuildContext context) {
    if (allTotal <= 0 && facets.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        children: [
          _FilterChip(
            label: 'Todos ($allTotal)',
            selected: selectedSubcategoryId == null,
            onTap: () => onSelected(null),
          ),
          ...facets.map(
            (facet) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: facet.count > 0
                    ? '${facet.name} (${facet.count})'
                    : facet.name,
                selected: selectedSubcategoryId == facet.subcategoryId,
                onTap: () => onSelected(facet.subcategoryId),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : const Color(0xFFF3F6F1),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected
                  ? AppBrandColors.primaryGreen
                  : const Color(0xFFE2E8F0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected
                  ? const Color(0xFF166534)
                  : AppBrandColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
