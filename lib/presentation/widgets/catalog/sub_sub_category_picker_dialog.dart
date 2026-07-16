import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/categories/category_model.dart';

const _visibleItemCount = 6;
const _itemHeight = 48.0;

Future<int?> showSubSubCategoryPickerDialog({
  required BuildContext context,
  required String subcategoryName,
  required List<SubSubCategoryModel> options,
  int? selectedId,
}) {
  return showDialog<int?>(
    context: context,
    builder: (context) => _SubSubCategoryPickerDialog(
      subcategoryName: subcategoryName,
      options: options,
      selectedId: selectedId,
    ),
  );
}

class _SubSubCategoryPickerDialog extends StatefulWidget {
  const _SubSubCategoryPickerDialog({
    required this.subcategoryName,
    required this.options,
    required this.selectedId,
  });

  final String subcategoryName;
  final List<SubSubCategoryModel> options;
  final int? selectedId;

  @override
  State<_SubSubCategoryPickerDialog> createState() =>
      _SubSubCategoryPickerDialogState();
}

class _SubSubCategoryPickerDialogState extends State<_SubSubCategoryPickerDialog> {
  late int? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedId;
  }

  void _select(int? id) {
    setState(() => _selectedId = id);
    Navigator.of(context).pop(id);
  }

  @override
  Widget build(BuildContext context) {
    final listHeight = (_visibleItemCount * _itemHeight).clamp(
      _itemHeight,
      _visibleItemCount * _itemHeight,
    );

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Servicios de ${widget.subcategoryName}',
            style: GoogleFonts.poppins(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppBrandColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Los que coincidan aparecerán primero en la lista.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppBrandColors.textMuted,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: widget.options.isEmpty ? 72 : listHeight,
        child: widget.options.isEmpty
            ? Center(
                child: Text(
                  'Aún no hay servicios registrados para este oficio.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              )
            : Scrollbar(
                thumbVisibility: widget.options.length > _visibleItemCount,
                child: ListView(
                  children: [
                    _PickerTile(
                      label: 'Todos los servicios',
                      selected: _selectedId == null,
                      onTap: () => _select(null),
                    ),
                    ...widget.options.map(
                      (option) => _PickerTile(
                        label: option.name,
                        selected: _selectedId == option.id,
                        onTap: () => _select(option.id),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cerrar',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: Icon(
        selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
        color: selected ? AppBrandColors.primaryGreen : AppBrandColors.textMuted,
        size: 20,
      ),
      title: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: AppBrandColors.textDark,
        ),
      ),
      onTap: onTap,
    );
  }
}

String? resolveSubSubCategoryLabel(
  List<SubSubCategoryModel> options,
  int? selectedId,
) {
  if (selectedId == null) return null;
  for (final option in options) {
    if (option.id == selectedId) return option.name;
  }
  return null;
}
