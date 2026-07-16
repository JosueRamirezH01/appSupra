import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/catalog_constants.dart';
import '../../core/constants/service_constants.dart';
import '../../data/models/categories/category_model.dart';
import 'auth/auth_ui.dart';

Future<List<SubcategoryModel>?> showSubcategoryMultiPicker(
  BuildContext context, {
  required List<SubcategoryModel> subcategories,
  required Set<int> selectedIds,
  String? flowStepLabel,
  String? confirmLabel,
}) {
  return showModalBottomSheet<List<SubcategoryModel>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _SubcategoryMultiPickerSheet(
      subcategories: subcategories
          .where((item) => CatalogConstants.isClientVisibleSubcategory(item.name))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name)),
      selectedIds: Set<int>.from(selectedIds),
      flowStepLabel: flowStepLabel,
      confirmLabel: confirmLabel,
    ),
  );
}

class _SubcategoryMultiPickerSheet extends StatefulWidget {
  const _SubcategoryMultiPickerSheet({
    required this.subcategories,
    required this.selectedIds,
    this.flowStepLabel,
    this.confirmLabel,
  });

  final List<SubcategoryModel> subcategories;
  final Set<int> selectedIds;
  final String? flowStepLabel;
  final String? confirmLabel;

  @override
  State<_SubcategoryMultiPickerSheet> createState() =>
      _SubcategoryMultiPickerSheetState();
}

class _SubcategoryMultiPickerSheetState extends State<_SubcategoryMultiPickerSheet> {
  final _searchController = TextEditingController();
  late Set<int> _selectedIds;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<int>.from(widget.selectedIds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<SubcategoryModel> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.subcategories;
    return widget.subcategories
        .where((item) => item.name.toLowerCase().contains(q))
        .toList();
  }

  void _toggle(SubcategoryModel item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else if (_selectedIds.length < ServiceConstants.maxRegistrationSpecialties) {
        _selectedIds.add(item.id);
      }
    });
  }

  void _confirm() {
    final selected = widget.subcategories
        .where((item) => _selectedIds.contains(item.id))
        .toList();
    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    final max = ServiceConstants.maxRegistrationSpecialties;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (widget.flowStepLabel != null) ...[
              Text(
                widget.flowStepLabel!,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              'Especialidades',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Elige entre ${ServiceConstants.minRegistrationSpecialties} y $max rubros.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_selectedIds.length}/$max seleccionadas',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: authDropdownDecoration('Buscar especialidad').copyWith(
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.45,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _filtered.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = _filtered[index];
                  final selected = _selectedIds.contains(item.id);
                  final disabled =
                      !selected && _selectedIds.length >= max;
        
                  return CheckboxListTile(
                    value: selected,
                    onChanged: disabled ? null : (_) => _toggle(item),
                    title: Text(
                      item.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: disabled
                            ? AppBrandColors.textMuted
                            : AppBrandColors.textDark,
                      ),
                    ),
                    activeColor: AppBrandColors.primaryGreen,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            AuthPrimaryButton(
              label: widget.confirmLabel ?? 'Confirmar selección',
              isLoading: false,
              onPressed: _selectedIds.isEmpty ? null : _confirm,
            ),
          ],
        ),
      ),
    );
  }
}
