import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/categories/category_model.dart';
import '../auth/auth_ui.dart';
import 'product_referential_pricing_fields.dart';
import '../technician/technician_panel_widgets.dart';

List<String> suggestionsForSubcategory(
  List<SubcategoryModel> items,
  int? subcategoryId,
) {
  if (subcategoryId == null) return const [];
  for (final item in items) {
    if (item.id == subcategoryId) return item.suggestions;
  }
  return const [];
}

Future<int?> showSubcategoryPickSheet(
  BuildContext context, {
  required List<SubcategoryModel> items,
}) {
  return showModalBottomSheet<int>(
    context: context,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Text(
              '¿En qué rubro lo agregas?',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppBrandColors.textDark,
              ),
            ),
          ),
          for (final item in items)
            ListTile(
              title: Text(
                item.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              onTap: () => Navigator.of(ctx).pop(item.id),
            ),
        ],
      );
    },
  );
}

Future<String?> showProductNameSheet(
  BuildContext context, {
  String? initialName,
  List<String> suggestions = const [],
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _NameSheet(
      initialName: initialName,
      suggestions: suggestions,
    ),
  );
}

Future<({double? price, double? compareAt})?> showProductPriceSheet(
  BuildContext context, {
  double? initialPrice,
  double? initialCompareAt,
}) {
  return showModalBottomSheet<({double? price, double? compareAt})>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _PriceSheet(
      initialPrice: initialPrice,
      initialCompareAt: initialCompareAt,
    ),
  );
}

Future<String?> showProductDescriptionSheet(
  BuildContext context, {
  String? initialDescription,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _DescriptionSheet(
      initialDescription: initialDescription,
    ),
  );
}

class _NameSheet extends StatefulWidget {
  const _NameSheet({this.initialName, this.suggestions = const []});

  final String? initialName;
  final List<String> suggestions;

  @override
  State<_NameSheet> createState() => _NameSheetState();
}

class _NameSheetState extends State<_NameSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName ?? '');
    _controller.addListener(_onNameChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onNameChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Form(
        key: _formKey,
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
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Nombre del producto',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Así lo verá el cliente en la vitrina.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              AuthRoundedField(
                controller: _controller,
                label: 'Nombre *',
                autofocus: true,
                maxLength: 150,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.length < 3) {
                    return 'Escribe al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              ProductNameSuggestionChips(
                suggestions: widget.suggestions,
                currentName: _controller.text,
                onSelected: (value) {
                  HapticFeedback.selectionClick();
                  _controller.value = TextEditingValue(
                    text: value,
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                },
              ),
              const SizedBox(height: 16),
              TechnicianPanelPrimaryButton(
                label: 'Listo',
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop(_controller.text.trim());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Chips informativos del rubro. Tocar rellena el nombre; no se persiste la elección.
class ProductNameSuggestionChips extends StatelessWidget {
  const ProductNameSuggestionChips({
    super.key,
    required this.suggestions,
    required this.currentName,
    required this.onSelected,
  });

  final List<String> suggestions;
  final String currentName;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final selectedKey = currentName.trim().toLowerCase();

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sugerencias de este rubro',
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Toca una para usarla. Puedes editarla.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              height: 1.35,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final suggestion in suggestions)
                _SuggestionChip(
                  label: suggestion,
                  selected: suggestion.toLowerCase() == selectedKey,
                  onTap: () => onSelected(suggestion),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({
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
      color: selected
          ? AppBrandColors.primaryGreen.withValues(alpha: 0.12)
          : const Color(0xFFF3F6F1),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
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

class _DescriptionSheet extends StatefulWidget {
  const _DescriptionSheet({this.initialDescription});

  final String? initialDescription;

  @override
  State<_DescriptionSheet> createState() => _DescriptionSheetState();
}

class _DescriptionSheetState extends State<_DescriptionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialDescription ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD1D5DB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Descripción',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppBrandColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Lo verá el cliente en la vitrina.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            AuthRoundedField(
              controller: _controller,
              label: 'Descripción',
              autofocus: true,
              minLines: 4,
              maxLines: 6,
              maxLength: 1000,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 16),
            TechnicianPanelPrimaryButton(
              label: 'Listo',
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                Navigator.of(context).pop(_controller.text.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceSheet extends StatefulWidget {
  const _PriceSheet({this.initialPrice, this.initialCompareAt});

  final double? initialPrice;
  final double? initialCompareAt;

  @override
  State<_PriceSheet> createState() => _PriceSheetState();
}

class _PriceSheetState extends State<_PriceSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _compareAtController;
  late bool _showCompareAt;

  @override
  void initState() {
    super.initState();
    _showCompareAt = widget.initialCompareAt != null;
    _priceController = TextEditingController(
      text: _moneyText(widget.initialPrice),
    );
    _compareAtController = TextEditingController(
      text: _moneyText(widget.initialCompareAt),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _compareAtController.dispose();
    super.dispose();
  }

  String _moneyText(double? value) {
    if (value == null) return '';
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
      child: Form(
        key: _formKey,
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
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Precio',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              ProductReferentialPricingFields(
                priceController: _priceController,
                compareAtController: _compareAtController,
                showCompareAt: _showCompareAt,
                onShowCompareAtChanged: (value) {
                  setState(() {
                    _showCompareAt = value;
                    if (!value) _compareAtController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),
              TechnicianPanelPrimaryButton(
                label: 'Listo',
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  Navigator.of(context).pop((
                    price: parseProductMoney(_priceController.text),
                    compareAt: _showCompareAt
                        ? parseProductMoney(_compareAtController.text)
                        : null,
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
