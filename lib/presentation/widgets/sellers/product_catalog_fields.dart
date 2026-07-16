import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/categories/categories_notifier.dart';
import '../common/panel_select_field.dart';
import '../technician/technician_panel_theme.dart';

class ProductCatalogFields extends ConsumerWidget {
  const ProductCatalogFields({
    super.key,
    required this.subcategoryId,
    required this.selectedSubSubId,
    required this.onSubSubChanged,
    this.enabled = true,
  });

  final int? subcategoryId;
  final int? selectedSubSubId;
  final ValueChanged<int?> onSubSubChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (subcategoryId == null) {
      return Text(
        'Selecciona primero una subcategoría para ver los materiales disponibles.',
        style: TechnicianPanelTheme.subtitle,
      );
    }

    final subSubAsync = ref.watch(subSubCategoriesListProvider(subcategoryId!));

    return subSubAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(minHeight: 2),
      ),
      error: (_, __) => Text(
        'No se pudieron cargar los materiales del catálogo.',
        style: TechnicianPanelTheme.subtitle.copyWith(color: Colors.red[700]),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Text(
            'Esta subcategoría no tiene materiales en el catálogo. Contacta al administrador.',
            style: TechnicianPanelTheme.subtitle,
          );
        }

        return PanelSelectField<int>(
          key: ValueKey('material-$subcategoryId-$selectedSubSubId'),
          label: 'Material del catálogo *',
          hintText: 'Elegir material',
          helperText: 'Solo materiales registrados por el administrador.',
          enabled: enabled,
          leadingIcon: Icons.inventory_2_outlined,
          sheetTitle: 'Material del catálogo',
          initialValue: selectedSubSubId,
          options: items
              .map(
                (item) => PanelSelectOption<int>(
                  value: item.id,
                  label: item.name,
                ),
              )
              .toList(),
          onChanged: onSubSubChanged,
          validator: (value) =>
              value == null ? 'Selecciona un material del catálogo' : null,
        );
      },
    );
  }
}

class ProductMaterialChips extends StatelessWidget {
  const ProductMaterialChips({
    super.key,
    required this.labels,
    this.maxVisible = 12,
  });

  final List<String> labels;
  final int maxVisible;

  @override
  Widget build(BuildContext context) {
    if (labels.isEmpty) return const SizedBox.shrink();

    final visible = labels.take(maxVisible).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...visible.map(
          (label) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              label,
              style: TechnicianPanelTheme.chip,
            ),
          ),
        ),
        if (labels.length > maxVisible)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '+${labels.length - maxVisible}',
              style: TechnicianPanelTheme.chip.copyWith(
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
      ],
    );
  }
}

class ProductSubcategoryChip extends StatelessWidget {
  const ProductSubcategoryChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TechnicianPanelTheme.chip.copyWith(
          color: const Color(0xFF166534),
        ),
      ),
    );
  }
}
