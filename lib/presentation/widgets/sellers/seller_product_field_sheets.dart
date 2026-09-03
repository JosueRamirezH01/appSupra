import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/product_sale_unit.dart';
import '../../../core/errors/app_exception.dart';
import '../../../data/models/sellers/seller_product_subcategory_model.dart';
import '../auth/auth_ui.dart';
import 'product_referential_pricing_fields.dart';
import '../technician/technician_panel_widgets.dart';

List<String> suggestionsForSubcategory(
  List<SellerProductSubcategoryModel> items,
  int? subcategoryId,
) {
  if (subcategoryId == null) return const [];
  for (final item in items) {
    if (item.id == subcategoryId) return item.suggestions;
  }
  return const [];
}

String? nameForSubcategory(
  List<SellerProductSubcategoryModel> items,
  int? subcategoryId,
) {
  if (subcategoryId == null) return null;
  for (final item in items) {
    if (item.id == subcategoryId) {
      final name = item.name.trim();
      return name.isEmpty ? null : name;
    }
  }
  return null;
}

Future<int?> showSubcategoryPickSheet(
  BuildContext context, {
  required List<SellerProductSubcategoryModel> items,
  Set<int> ownedSubcategoryIds = const {},
  Future<SellerProductSubcategoryModel> Function(String name)? onCreateCustom,
  int customLimit = kSellerCustomProductSubcategoryLimit,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _RubroPickSheet(
      items: items,
      ownedSubcategoryIds: ownedSubcategoryIds,
      onCreateCustom: onCreateCustom,
      customLimit: customLimit,
    ),
  );
}

class _RubroPickSheet extends StatefulWidget {
  const _RubroPickSheet({
    required this.items,
    required this.ownedSubcategoryIds,
    this.onCreateCustom,
    this.customLimit = kSellerCustomProductSubcategoryLimit,
  });

  final List<SellerProductSubcategoryModel> items;
  final Set<int> ownedSubcategoryIds;
  final Future<SellerProductSubcategoryModel> Function(String name)?
      onCreateCustom;
  final int customLimit;

  @override
  State<_RubroPickSheet> createState() => _RubroPickSheetState();
}

class _RubroPickSheetState extends State<_RubroPickSheet> {
  late List<SellerProductSubcategoryModel> _items;

  @override
  void initState() {
    super.initState();
    _items = List<SellerProductSubcategoryModel>.from(widget.items);
  }

  List<SellerProductSubcategoryModel> get _catalogItems =>
      _items.where((item) => !item.isSellerOwned).toList();

  /// Propios primero (más recientes arriba) para que se vean al abrir el sheet.
  List<SellerProductSubcategoryModel> get _ownItems {
    final own = _items.where((item) => item.isSellerOwned).toList();
    own.sort((left, right) => right.id.compareTo(left.id));
    return own;
  }

  int get _ownCount => _ownItems.length;

  bool get _canCreate =>
      widget.onCreateCustom != null && _ownCount < widget.customLimit;

  Future<void> _openCreateRubro() async {
    if (!_canCreate || widget.onCreateCustom == null) return;

    final selectedId = await showCreateCustomRubroSheet(
      context,
      ownItems: _ownItems,
      onCreate: widget.onCreateCustom!,
    );
    if (selectedId == null || !mounted) return;
    HapticFeedback.lightImpact();
    Navigator.of(context).pop(selectedId);
  }

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;
    final catalog = _catalogItems;
    final own = _ownItems;

    return SizedBox(
      height: maxHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¿Qué vas a vender?',
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Elige un anaquel del catálogo o crea el tuyo si no está en la lista.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.4,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              children: [
                if (own.isNotEmpty) ...[
                  const _RubroSectionLabel('Tus rubros'),
                  for (var i = 0; i < own.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFE8ECE9),
                      ),
                    _RubroPickTile(
                      item: own[i],
                      alreadyOwned:
                          widget.ownedSubcategoryIds.contains(own[i].id),
                      badgeLabel: 'Solo en tu tienda',
                      onSelect: () => Navigator.of(context).pop(own[i].id),
                    ),
                  ],
                  if (catalog.isNotEmpty) const SizedBox(height: 12),
                ],
                if (catalog.isNotEmpty) ...[
                  const _RubroSectionLabel('Del catálogo'),
                  for (var i = 0; i < catalog.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFE8ECE9),
                      ),
                    _RubroPickTile(
                      item: catalog[i],
                      alreadyOwned:
                          widget.ownedSubcategoryIds.contains(catalog[i].id),
                      onSelect: () => Navigator.of(context).pop(catalog[i].id),
                    ),
                  ],
                ],
              ],
            ),
          ),
          if (widget.onCreateCustom != null)
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _canCreate ? _openCreateRubro : null,
                      icon: const Icon(Icons.add_rounded, size: 20),
                      label: Text(
                        'Crear mi rubro',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppBrandColors.primaryGreen,
                        disabledForegroundColor: AppBrandColors.textMuted,
                        side: BorderSide(
                          color: _canCreate
                              ? AppBrandColors.primaryGreen
                              : const Color(0xFFD1D5DB),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _canCreate
                          ? 'Si no está en la lista. Solo tú lo usas al publicar.'
                          : 'Llegaste al máximo (${widget.customLimit}).',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        height: 1.35,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RubroSectionLabel extends StatelessWidget {
  const _RubroSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
          color: AppBrandColors.textMuted,
        ),
      ),
    );
  }
}

class _RubroPickTile extends StatefulWidget {
  const _RubroPickTile({
    required this.item,
    required this.alreadyOwned,
    required this.onSelect,
    this.badgeLabel,
  });

  final SellerProductSubcategoryModel item;
  final bool alreadyOwned;
  final VoidCallback onSelect;
  final String? badgeLabel;

  @override
  State<_RubroPickTile> createState() => _RubroPickTileState();
}

class _RubroPickTileState extends State<_RubroPickTile> {
  var _expanded = false;

  static List<String> _suggestionLines(List<String> suggestions) {
    final lines = <String>[];
    for (final raw in suggestions) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty) continue;
      for (final part in trimmed.split(RegExp(r'(?<=\.)\s+'))) {
        final line = part.trim();
        if (line.isNotEmpty) lines.add(line);
      }
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final lines = _suggestionLines(widget.item.suggestions);
    final canToggle = lines.length > 1 || (lines.isNotEmpty && lines.first.length > 72);
    final visibleLines = !_expanded && canToggle ? lines.take(1).toList() : lines;
    final exampleStyle = GoogleFonts.poppins(
      fontSize: 12.5,
      height: 1.45,
      color: AppBrandColors.textMuted,
    );
    final badge = widget.alreadyOwned
        ? 'Ya lo tienes'
        : widget.badgeLabel;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: widget.onSelect,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.item.name,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppBrandColors.primaryGreen.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppBrandColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppBrandColors.textMuted,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
          if (lines.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < visibleLines.length; i++) ...[
                    if (i > 0) const SizedBox(height: 6),
                    Text(
                      visibleLines[i],
                      maxLines: _expanded ? null : 2,
                      overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: exampleStyle,
                    ),
                  ],
                  if (canToggle)
                    GestureDetector(
                      onTap: () => setState(() => _expanded = !_expanded),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _expanded ? 'Ocultar' : 'Ver ejemplos',
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppBrandColors.primaryGreen,
                              ),
                            ),
                            Icon(
                              _expanded
                                  ? Icons.expand_less_rounded
                                  : Icons.expand_more_rounded,
                              size: 18,
                              color: AppBrandColors.primaryGreen,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

Future<int?> showCreateCustomRubroSheet(
  BuildContext context, {
  required List<SellerProductSubcategoryModel> ownItems,
  required Future<SellerProductSubcategoryModel> Function(String name) onCreate,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _CreateCustomRubroSheet(
      ownItems: ownItems,
      onCreate: onCreate,
    ),
  );
}

SellerProductSubcategoryModel? findOwnRubroByName(
  List<SellerProductSubcategoryModel> ownItems,
  String name,
) {
  final key = name.trim().toLowerCase();
  if (key.isEmpty) return null;
  for (final item in ownItems) {
    if (item.name.trim().toLowerCase() == key) return item;
  }
  return null;
}

bool _isDuplicateRubroError(Object error) {
  if (error is! AppException) return false;
  final message = error.message.toLowerCase();
  return message.contains('already have') ||
      message.contains('ya tienes') ||
      message.contains('with this name') ||
      message.contains('este nombre');
}

class _CreateCustomRubroSheet extends StatefulWidget {
  const _CreateCustomRubroSheet({
    required this.ownItems,
    required this.onCreate,
  });

  final List<SellerProductSubcategoryModel> ownItems;
  final Future<SellerProductSubcategoryModel> Function(String name) onCreate;

  @override
  State<_CreateCustomRubroSheet> createState() => _CreateCustomRubroSheetState();
}

class _CreateCustomRubroSheetState extends State<_CreateCustomRubroSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;
  var _submitting = false;
  String? _inlineError;
  SellerProductSubcategoryModel? _duplicate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_clearDuplicateState);
  }

  @override
  void dispose() {
    _controller.removeListener(_clearDuplicateState);
    _controller.dispose();
    super.dispose();
  }

  void _clearDuplicateState() {
    if (_inlineError == null && _duplicate == null) return;
    setState(() {
      _inlineError = null;
      _duplicate = null;
    });
  }

  void _showDuplicate(SellerProductSubcategoryModel existing) {
    setState(() {
      _duplicate = existing;
      _inlineError = 'Ya tienes este rubro: “${existing.name}”.';
    });
  }

  Future<void> _submit() async {
    if (_submitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _controller.text.trim();
    final existing = findOwnRubroByName(widget.ownItems, name);
    if (existing != null) {
      _showDuplicate(existing);
      return;
    }

    setState(() {
      _submitting = true;
      _inlineError = null;
      _duplicate = null;
    });

    try {
      final created = await widget.onCreate(name);
      if (!mounted) return;
      Navigator.of(context).pop(created.id);
    } catch (error) {
      if (!mounted) return;
      if (_isDuplicateRubroError(error)) {
        final fromList = findOwnRubroByName(widget.ownItems, name);
        if (fromList != null) {
          _showDuplicate(fromList);
        } else {
          setState(() {
            _inlineError =
                'Ya tienes un rubro con ese nombre. Ábrelo en “Tus rubros”.';
          });
        }
      } else {
        setState(() {
          _inlineError = error is AppException
              ? error.message
              : 'No se pudo crear el rubro. Intenta de nuevo.';
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _useExisting() {
    final duplicate = _duplicate;
    if (duplicate == null) return;
    Navigator.of(context).pop(duplicate.id);
  }

  void _tryAnotherName() {
    setState(() {
      _inlineError = null;
      _duplicate = null;
    });
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
                'Nombre de tu rubro',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ejemplo: Cables especiales. Solo tú lo verás al publicar.',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.4,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller,
                autofocus: true,
                enabled: !_submitting,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 100,
                decoration: InputDecoration(
                  hintText: 'Escribe el nombre del rubro',
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFF8FAF9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _inlineError != null
                          ? Colors.redAccent
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: _inlineError != null
                          ? Colors.redAccent
                          : AppBrandColors.primaryGreen,
                      width: 1.6,
                    ),
                  ),
                ),
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppBrandColors.textDark,
                ),
                validator: (value) {
                  final trimmed = value?.trim() ?? '';
                  if (trimmed.length < 2) {
                    return 'Usa al menos 2 caracteres';
                  }
                  return null;
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_inlineError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _inlineError!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                ),
              ],
              if (_duplicate != null) ...[
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: _submitting ? null : _useExisting,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppBrandColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Usar “${_duplicate!.name}”',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: _submitting ? null : _tryAnotherName,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppBrandColors.textDark,
                    side: const BorderSide(color: Color(0xFFD1D5DB)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Probar otro nombre',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppBrandColors.primaryGreen,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        AppBrandColors.primaryGreen.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Crear y usar',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        ),
                ),
              ],
              TextButton(
                onPressed: _submitting ? null : () => Navigator.of(context).pop(),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> showProductNameSheet(
  BuildContext context, {
  String? initialName,
  String? subcategoryName,
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
      subcategoryName: subcategoryName,
      suggestions: suggestions,
    ),
  );
}

Future<({double? price, double? compareAt, String? saleUnit})?>
    showProductPriceSheet(
  BuildContext context, {
  double? initialPrice,
  double? initialCompareAt,
  String? initialSaleUnit,
}) {
  return showModalBottomSheet<({double? price, double? compareAt, String? saleUnit})>(
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
      initialSaleUnit: initialSaleUnit,
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
  const _NameSheet({
    this.initialName,
    this.subcategoryName,
    this.suggestions = const [],
  });

  final String? initialName;
  final String? subcategoryName;
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
    final rubro = widget.subcategoryName?.trim() ?? '';
    final title = rubro.isEmpty ? 'Nombre del producto' : 'Nombre en $rubro';
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
                title,
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
  const _PriceSheet({
    this.initialPrice,
    this.initialCompareAt,
    this.initialSaleUnit,
  });

  final double? initialPrice;
  final double? initialCompareAt;
  final String? initialSaleUnit;

  @override
  State<_PriceSheet> createState() => _PriceSheetState();
}

class _PriceSheetState extends State<_PriceSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _priceController;
  late final TextEditingController _compareAtController;
  late bool _showCompareAt;
  String? _saleUnit;

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
    _saleUnit = widget.initialPrice == null
        ? null
        : (normalizeProductSaleUnit(widget.initialSaleUnit) ??
            kDefaultProductSaleUnit);
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
                saleUnit: _saleUnit,
                onSaleUnitChanged: (value) {
                  setState(() => _saleUnit = value);
                },
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
                  final price = parseProductMoney(_priceController.text);
                  Navigator.of(context).pop((
                    price: price,
                    compareAt: _showCompareAt
                        ? parseProductMoney(_compareAtController.text)
                        : null,
                    saleUnit: price == null
                        ? null
                        : (normalizeProductSaleUnit(_saleUnit) ??
                            kDefaultProductSaleUnit),
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
