import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/service_constants.dart';
import '../../data/models/categories/category_model.dart';
import 'auth/auth_ui.dart';

class SubSubPickerItem {
  const SubSubPickerItem({
    required this.subSub,
    required this.subcategoryName,
    required this.subcategoryId,
  });

  final SubSubCategoryModel subSub;
  final String subcategoryName;
  final int subcategoryId;

  int get id => subSub.id;
  String get name => subSub.name;
}

Future<List<SubSubCategoryModel>?> showSubSubCategoryMultiPicker(
  BuildContext context, {
  required List<SubcategoryModel> subcategories,
  required Map<int, List<SubSubCategoryModel>> catalogBySubcategory,
  required Set<int> selectedIds,
}) {
  final items = <SubSubPickerItem>[];
  for (final subcategory in subcategories) {
    final catalog = catalogBySubcategory[subcategory.id] ?? const [];
    for (final subSub in catalog) {
      if (!subSub.status) continue;
      items.add(
        SubSubPickerItem(
          subSub: subSub,
          subcategoryName: subcategory.name,
          subcategoryId: subcategory.id,
        ),
      );
    }
  }

  return showModalBottomSheet<List<SubSubCategoryModel>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _SubSubCategoryMultiPickerSheet(
      items: items,
      subcategories: subcategories,
      selectedIds: Set<int>.from(selectedIds),
    ),
  );
}

class _SubSubCategoryMultiPickerSheet extends StatefulWidget {
  const _SubSubCategoryMultiPickerSheet({
    required this.items,
    required this.subcategories,
    required this.selectedIds,
  });

  final List<SubSubPickerItem> items;
  final List<SubcategoryModel> subcategories;
  final Set<int> selectedIds;

  @override
  State<_SubSubCategoryMultiPickerSheet> createState() =>
      _SubSubCategoryMultiPickerSheetState();
}

class _SubSubCategoryMultiPickerSheetState
    extends State<_SubSubCategoryMultiPickerSheet> {
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

  List<SubSubPickerItem> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items
        .where(
          (item) =>
              item.name.toLowerCase().contains(q) ||
              item.subcategoryName.toLowerCase().contains(q),
        )
        .toList();
  }

  Map<String, List<SubSubPickerItem>> get _groupedFiltered {
    final map = <String, List<SubSubPickerItem>>{};
    for (final item in _filtered) {
      map.putIfAbsent(item.subcategoryName, () => []).add(item);
    }
    return map;
  }

  int _countForSubcategory(int subcategoryId) {
    return widget.items
        .where(
          (item) =>
              item.subcategoryId == subcategoryId &&
              _selectedIds.contains(item.id),
        )
        .length;
  }

  bool _hasCatalogForSubcategory(int subcategoryId) {
    return widget.items.any((item) => item.subcategoryId == subcategoryId);
  }

  bool get _canConfirm {
    if (_selectedIds.isEmpty) return false;

    for (final subcategory in widget.subcategories) {
      if (!_hasCatalogForSubcategory(subcategory.id)) continue;
      if (_countForSubcategory(subcategory.id) <
          ServiceConstants.minServicesPerSpecialty) {
        return false;
      }
    }

    return true;
  }

  void _toggle(SubSubPickerItem item) {
    setState(() {
      if (_selectedIds.contains(item.id)) {
        _selectedIds.remove(item.id);
      } else if (_countForSubcategory(item.subcategoryId) <
          ServiceConstants.maxServicesPerSpecialty) {
        _selectedIds.add(item.id);
      }
    });
  }

  void _confirm() {
    if (!_canConfirm) return;

    final selected = widget.items
        .where((item) => _selectedIds.contains(item.id))
        .map((item) => item.subSub)
        .toList();
    Navigator.of(context).pop(selected);
  }

  String? get _confirmHint {
    if (_selectedIds.isEmpty) {
      return 'Selecciona al menos un servicio en cada especialidad';
    }

    final pending = <String>[];
    for (final subcategory in widget.subcategories) {
      if (!_hasCatalogForSubcategory(subcategory.id)) continue;
      final count = _countForSubcategory(subcategory.id);
      if (count < ServiceConstants.minServicesPerSpecialty) {
        pending.add(subcategory.name);
      }
    }

    if (pending.isEmpty) return null;
    if (pending.length == 1) {
      return 'Falta elegir servicios en ${pending.first}';
    }
    return 'Faltan servicios en: ${pending.join(', ')}';
  }

  @override
  Widget build(BuildContext context) {
    final maxPerSpecialty = ServiceConstants.maxServicesPerSpecialty;
    final minPerSpecialty = ServiceConstants.minServicesPerSpecialty;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final grouped = _groupedFiltered;
    final groupNames = grouped.keys.toList()..sort();

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
            Text(
              'Servicios',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Elige entre $minPerSpecialty y $maxPerSpecialty servicios por cada especialidad.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_selectedIds.length}/${ServiceConstants.maxTotalServicesForSpecialtyCount(widget.subcategories.length)} seleccionados',
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
              decoration: authDropdownDecoration('Buscar servicio').copyWith(
                prefixIcon: const Icon(Icons.search_rounded),
              ),
            ),
            const SizedBox(height: 12),
            if (widget.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'No hay servicios publicados para las especialidades elegidas.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final groupName in groupNames) ...[
                      Builder(
                        builder: (context) {
                          final groupItems = grouped[groupName]!;
                          final subcategoryId = groupItems.first.subcategoryId;
                          final groupCount = _countForSubcategory(subcategoryId);
        
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6, top: 4),
                                child: Row(
                                  children: [
                                    Icon(
                                      groupCount >= minPerSpecialty
                                          ? Icons.check_circle_rounded
                                          : Icons.error_outline_rounded,
                                      size: 16,
                                      color: groupCount >= minPerSpecialty
                                          ? AppBrandColors.primaryGreen
                                          : const Color(0xFFD97706),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        groupName,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppBrandColors.primaryGreen,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '$groupCount/$maxPerSpecialty',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: groupCount >= minPerSpecialty
                                            ? AppBrandColors.primaryGreen
                                            : const Color(0xFFD97706),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ...groupItems.map((item) {
                                final selected = _selectedIds.contains(item.id);
                                final disabled = !selected &&
                                    _countForSubcategory(item.subcategoryId) >=
                                        maxPerSpecialty;
        
                                return CheckboxListTile(
                                  value: selected,
                                  onChanged:
                                      disabled ? null : (_) => _toggle(item),
                                  title: Text(
                                    item.name,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: disabled
                                          ? AppBrandColors.textMuted
                                          : AppBrandColors.textDark,
                                    ),
                                  ),
                                  activeColor: AppBrandColors.primaryGreen,
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                );
                              }),
                              const Divider(height: 20),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 12),
            if (!_canConfirm && _confirmHint != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _confirmHint!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: const Color(0xFFD97706),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            AuthPrimaryButton(
              label: 'Confirmar selección',
              isLoading: false,
              onPressed: _canConfirm ? _confirm : null,
            ),
          ],
        ),
      ),
    );
  }
}
