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

  bool get _hasChanges {
    if (_selectedIds.length != widget.selectedIds.length) return true;
    for (final id in _selectedIds) {
      if (!widget.selectedIds.contains(id)) return true;
    }
    return false;
  }

  Future<void> _handleCloseAttempt() async {
    if (!_hasChanges) {
      Navigator.of(context).pop();
      return;
    }

    final discard = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Salir sin guardar?',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Tienes cambios en la selección de especialidades.',
          style: GoogleFonts.poppins(fontSize: 13.5, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Seguir eligiendo'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );

    if (discard == true && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final max = ServiceConstants.maxRegistrationSpecialties;
    // Relleno inferior seguro: si hay teclado, lo respetamos; si no, dejamos el
    // margen de la barra de navegación del sistema (no basta con `useSafeArea`).
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final navBarInset = MediaQuery.viewPaddingOf(context).bottom;
    final safeBottom = keyboardInset > 0 ? keyboardInset : navBarInset;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleCloseAttempt();
      },
      child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
          // La lista es lo único que se desplaza; ocupa el espacio disponible.
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = _filtered[index];
                final selected = _selectedIds.contains(item.id);
                final disabled = !selected && _selectedIds.length >= max;

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
          // Botón fijo: siempre visible, nunca tapado por la barra ni el teclado.
          Padding(
            padding: EdgeInsets.only(top: 12, bottom: 16 + safeBottom),
            child: AuthPrimaryButton(
              label: widget.confirmLabel ?? 'Confirmar selección',
              isLoading: false,
              onPressed: _selectedIds.isEmpty ? null : _confirm,
            ),
          ),
        ],
      ),
    ),
    );
  }
}
