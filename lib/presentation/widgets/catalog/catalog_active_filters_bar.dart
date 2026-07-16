import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

class CatalogActiveFiltersBar extends StatelessWidget {
  const CatalogActiveFiltersBar({
    super.key,
    this.subcategoryLabel,
    this.subSubCategoryLabel,
    this.searchQuery,
    this.onClearSubcategory,
    this.onClearSubSubCategory,
    this.onClearSearch,
    this.onOpenSubSubCategoryPicker,
  });

  final String? subcategoryLabel;
  final String? subSubCategoryLabel;
  final String? searchQuery;
  final VoidCallback? onClearSubcategory;
  final VoidCallback? onClearSubSubCategory;
  final VoidCallback? onClearSearch;
  final VoidCallback? onOpenSubSubCategoryPicker;

  bool get _hasFilters =>
      (subcategoryLabel != null && subcategoryLabel!.trim().isNotEmpty) ||
      (subSubCategoryLabel != null && subSubCategoryLabel!.trim().isNotEmpty) ||
      (searchQuery != null && searchQuery!.trim().isNotEmpty) ||
      onOpenSubSubCategoryPicker != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasFilters) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Row(
          children: [
            Text(
              'Viendo:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (subcategoryLabel != null &&
                      subcategoryLabel!.trim().isNotEmpty)
                    _FilterChip(
                      label: subcategoryLabel!,
                      onClear: onClearSubcategory,
                    ),
                  if (subSubCategoryLabel != null &&
                      subSubCategoryLabel!.trim().isNotEmpty)
                    _FilterChip(
                      label: subSubCategoryLabel!,
                      onClear: onClearSubSubCategory,
                    ),
                  if (searchQuery != null && searchQuery!.trim().isNotEmpty)
                    _FilterChip(
                      label: '«${searchQuery!.trim()}»',
                      onClear: onClearSearch,
                    ),
                ],
              ),
            ),
            if (onOpenSubSubCategoryPicker != null) ...[
              const SizedBox(width: 4),
              _ServiceFilterButton(onPressed: onOpenSubSubCategoryPicker!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ServiceFilterButton extends StatelessWidget {
  const _ServiceFilterButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Tooltip(
          message: 'Refinar por servicio',
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(
              Icons.tune_rounded,
              size: 18,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.onClear,
  });

  final String label;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppBrandColors.textDark,
        ),
      ),
      onDeleted: onClear,
      deleteIcon: const Icon(Icons.close_rounded, size: 16),
      backgroundColor: const Color(0xFFF0FDF4),
      side: const BorderSide(color: Color(0xFFBBF7D0)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 2),
    );
  }
}

String buildCatalogEmptyMessage({
  String? searchQuery,
  String? subcategoryLabel,
  String? subSubCategoryLabel,
  required String entityLabel,
}) {
  final search = searchQuery?.trim();
  final subcategory = subcategoryLabel?.trim();
  final service = subSubCategoryLabel?.trim();

  if (search != null && search.isNotEmpty && service != null) {
    return 'No hay $entityLabel para «$search» con el servicio $service.';
  }
  if (search != null && search.isNotEmpty && subcategory != null) {
    return 'No hay $entityLabel para «$search» en $subcategory.';
  }
  if (search != null && search.isNotEmpty) {
    return 'No hay $entityLabel para «$search».';
  }
  if (service != null && subcategory != null) {
    return 'No hay $entityLabel para $service en $subcategory por ahora.';
  }
  if (subcategory != null && subcategory.isNotEmpty) {
    return 'No hay $entityLabel en $subcategory por ahora.';
  }
  return 'No hay $entityLabel disponibles por ahora.';
}
