import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/categories/category_model.dart';
import '../../core/constants/catalog_constants.dart';
import 'auth/auth_ui.dart';

Future<SubcategoryModel?> showSubcategorySearchPicker(
  BuildContext context, {
  required List<SubcategoryModel> subcategories,
  SubcategoryModel? selected,
}) {
  return showModalBottomSheet<SubcategoryModel>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _SubcategorySearchPickerSheet(
      subcategories: subcategories,
      selected: selected,
    ),
  );
}

class _SubcategorySearchPickerSheet extends StatefulWidget {
  const _SubcategorySearchPickerSheet({
    required this.subcategories,
    this.selected,
  });

  final List<SubcategoryModel> subcategories;
  final SubcategoryModel? selected;

  @override
  State<_SubcategorySearchPickerSheet> createState() =>
      _SubcategorySearchPickerSheetState();
}

class _SubcategorySearchPickerSheetState
    extends State<_SubcategorySearchPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SubcategoryModel> get _regularSubcategories =>
      widget.subcategories
          .where((item) => !CatalogConstants.isOtrosSubcategoryName(item.name))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  SubcategoryModel? get _otrosSubcategory {
    for (final item in widget.subcategories) {
      if (CatalogConstants.isOtrosSubcategoryName(item.name)) {
        return item;
      }
    }
    return null;
  }

  List<SubcategoryModel> get _filteredRegular {
    final normalized = _query.trim().toLowerCase();
    if (normalized.isEmpty) return _regularSubcategories;

    return _regularSubcategories
        .where((item) => item.name.toLowerCase().contains(normalized))
        .toList();
  }

  bool get _showOtros => _otrosSubcategory != null;

  bool get _hasSearchQuery => _query.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredRegular;
    final otros = _otrosSubcategory;
    final showOtros = _showOtros;

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.72,
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE3D6),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Busca tu rubro',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppBrandColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Si no encuentras tu oficio, elige "Otros servicios técnicos".',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppBrandColors.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _searchController,
              autofocus: true,
              decoration: authDropdownDecoration('Buscar subcategoría').copyWith(
                prefixIcon: const Icon(Icons.search_rounded),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  if (filtered.isEmpty && _hasSearchQuery)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No encontramos "${_query.trim()}" en el catálogo.',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppBrandColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ...filtered.map(
                    (item) => Column(
                      children: [
                        _SubcategoryOptionTile(
                          label: item.name,
                          selected: widget.selected?.id == item.id,
                          onTap: () => Navigator.pop(context, item),
                        ),
                        const Divider(height: 1),
                      ],
                    ),
                  ),
                  if (showOtros && otros != null) ...[
                    if (filtered.isNotEmpty) const Divider(height: 1),
                    _SubcategoryOptionTile(
                      label: otros.name,
                      subtitle: filtered.isEmpty && _hasSearchQuery
                          ? '¿No está en la lista? Describe tu oficio'
                          : 'Describe tu oficio manualmente',
                      selected: widget.selected?.id == otros.id,
                      onTap: () => Navigator.pop(context, otros),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubcategoryOptionTile extends StatelessWidget {
  const _SubcategoryOptionTile({
    required this.label,
    required this.onTap,
    this.subtitle,
    this.selected = false,
  });

  final String label;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: AppBrandColors.textDark,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppBrandColors.textMuted,
              ),
            ),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: AppBrandColors.primaryGreen)
          : null,
      onTap: onTap,
    );
  }
}
