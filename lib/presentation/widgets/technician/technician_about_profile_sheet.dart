import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import 'maps_launch_actions.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../models/client_technician_profile_ui_model.dart';
import '../../utils/technician_pricing_utils.dart';
import '../auth/auth_ui.dart';

enum _AboutInlineEdit { none, about, experience, quote }

const _experienceYearOptions = [
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 25, 30,
];

Future<void> showTechnicianAboutProfileSheet(
  BuildContext context, {
  required TechnicianPublicModel technician,
  required ClientTechnicianProfileUiModel ui,
  required bool canEdit,
  VoidCallback? onEditAbout,
  VoidCallback? onEditExperience,
  VoidCallback? onEditServiceArea,
  Future<void> Function(String description)? onSaveAboutDescription,
  Future<void> Function(int years)? onSaveExperienceYears,
  Future<void> Function(String minimumQuoteText)? onSaveMinimumQuote,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppBrandColors.scaffoldBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _TechnicianAboutProfileSheet(
      technician: technician,
      ui: ui,
      canEdit: canEdit,
      onEditAbout: onEditAbout,
      onEditExperience: onEditExperience,
      onEditServiceArea: onEditServiceArea,
      onSaveAboutDescription: onSaveAboutDescription,
      onSaveExperienceYears: onSaveExperienceYears,
      onSaveMinimumQuote: onSaveMinimumQuote,
    ),
  );
}

class _TechnicianAboutProfileSheet extends StatefulWidget {
  const _TechnicianAboutProfileSheet({
    required this.technician,
    required this.ui,
    required this.canEdit,
    this.onEditAbout,
    this.onEditExperience,
    this.onEditServiceArea,
    this.onSaveAboutDescription,
    this.onSaveExperienceYears,
    this.onSaveMinimumQuote,
  });

  final TechnicianPublicModel technician;
  final ClientTechnicianProfileUiModel ui;
  final bool canEdit;
  final VoidCallback? onEditAbout;
  final VoidCallback? onEditExperience;
  final VoidCallback? onEditServiceArea;
  final Future<void> Function(String description)? onSaveAboutDescription;
  final Future<void> Function(int years)? onSaveExperienceYears;
  final Future<void> Function(String minimumQuoteText)? onSaveMinimumQuote;

  @override
  State<_TechnicianAboutProfileSheet> createState() =>
      _TechnicianAboutProfileSheetState();
}

class _TechnicianAboutProfileSheetState
    extends State<_TechnicianAboutProfileSheet> {
  final _sheetController = DraggableScrollableController();
  final _formKey = GlobalKey<FormState>();

  late String? _description;
  late int? _experienceYears;
  late double? _minimumQuote;

  _AboutInlineEdit _editing = _AboutInlineEdit.none;
  bool _saving = false;
  TextEditingController? _aboutController;
  TextEditingController? _quoteController;
  int? _draftYears;

  ClientTechnicianProfileTheme get _theme => widget.ui.theme;
  bool get _canInlineAbout =>
      widget.canEdit && widget.onSaveAboutDescription != null;
  bool get _canInlineExperience =>
      widget.canEdit && widget.onSaveExperienceYears != null;
  bool get _canInlineQuote =>
      widget.canEdit && widget.onSaveMinimumQuote != null;

  bool get _hasAbout =>
      _description != null && _description!.trim().isNotEmpty;
  bool get _hasExperience => _experienceYears != null;
  bool get _showAbout => _hasAbout || widget.canEdit;
  bool get _showExperience =>
      _hasExperience || (widget.canEdit && (widget.onEditExperience != null || _canInlineExperience));
  bool get _hasServiceAreaContent =>
      widget.ui.serviceArea != null ||
      widget.technician.coversAllPeru ||
      widget.technician.coverageDistricts.isNotEmpty;
  bool get _showServiceArea => _hasServiceAreaContent || widget.canEdit;
  bool get _showQuote =>
      _minimumQuote != null || widget.canEdit;

  @override
  void initState() {
    super.initState();
    _description = widget.technician.description?.trim();
    if (_description != null && _description!.isEmpty) _description = null;
    _experienceYears = widget.technician.experienceYears;
    _minimumQuote = widget.technician.minimumQuote;
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _aboutController?.dispose();
    _quoteController?.dispose();
    super.dispose();
  }

  void _openLegacyEdit(VoidCallback? action) {
    Navigator.of(context).pop();
    if (action == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }

  void _expandSheet() {
    if (!_sheetController.isAttached) return;
    _sheetController.animateTo(
      0.92,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _disposeDetachedControllers({
    TextEditingController? about,
    TextEditingController? quote,
  }) {
    about?.dispose();
    quote?.dispose();
  }

  String _quoteDraftText(double? quote) {
    if (quote == null) return '';
    return quote % 1 == 0 ? quote.toInt().toString() : quote.toString();
  }

  String _experienceLabel(int years) {
    if (years == 0) return 'Menos de 1 año';
    if (years >= 20) return '$years+ años';
    return years == 1 ? '1 año' : '$years años';
  }

  void _startEdit(_AboutInlineEdit target) {
    if (_saving || _editing == target) return;
    final previousAbout = _aboutController;
    final previousQuote = _quoteController;
    setState(() {
      _aboutController = null;
      _quoteController = null;
      _draftYears = null;
      _editing = target;
      if (target == _AboutInlineEdit.about) {
        _aboutController = TextEditingController(text: _description ?? '');
      } else if (target == _AboutInlineEdit.quote) {
        _quoteController = TextEditingController(
          text: _quoteDraftText(_minimumQuote),
        );
      } else if (target == _AboutInlineEdit.experience) {
        _draftYears = _experienceYears;
      }
    });
    _disposeDetachedControllers(about: previousAbout, quote: previousQuote);
    if (target == _AboutInlineEdit.about || target == _AboutInlineEdit.quote) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _expandSheet();
      });
    }
  }

  void _cancelEdit() {
    if (_saving) return;
    final previousAbout = _aboutController;
    final previousQuote = _quoteController;
    setState(() {
      _aboutController = null;
      _quoteController = null;
      _draftYears = null;
      _editing = _AboutInlineEdit.none;
    });
    _disposeDetachedControllers(about: previousAbout, quote: previousQuote);
  }

  Future<void> _saveAbout() async {
    final save = widget.onSaveAboutDescription;
    final controller = _aboutController;
    if (save == null || controller == null) return;
    if (_formKey.currentState?.validate() == false) return;

    final text = controller.text.trim();
    setState(() => _saving = true);
    try {
      await save(text);
      if (!mounted) return;
      final previousAbout = _aboutController;
      final previousQuote = _quoteController;
      setState(() {
        _aboutController = null;
        _quoteController = null;
        _description = text.isEmpty ? null : text;
        _editing = _AboutInlineEdit.none;
        _saving = false;
      });
      _disposeDetachedControllers(about: previousAbout, quote: previousQuote);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackBar(context, e);
    }
  }

  Future<void> _saveExperience() async {
    final save = widget.onSaveExperienceYears;
    final years = _draftYears;
    if (save == null || years == null) return;

    setState(() => _saving = true);
    try {
      await save(years);
      if (!mounted) return;
      setState(() {
        _draftYears = null;
        _experienceYears = years;
        _editing = _AboutInlineEdit.none;
        _saving = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackBar(context, e);
    }
  }

  Future<void> _saveQuote() async {
    final save = widget.onSaveMinimumQuote;
    final controller = _quoteController;
    if (save == null || controller == null) return;
    if (_formKey.currentState?.validate() == false) return;

    final text = controller.text.trim();
    setState(() => _saving = true);
    try {
      await save(text);
      if (!mounted) return;
      final previousAbout = _aboutController;
      final previousQuote = _quoteController;
      setState(() {
        _aboutController = null;
        _quoteController = null;
        _minimumQuote = parsePriceInput(text);
        _editing = _AboutInlineEdit.none;
        _saving = false;
      });
      _disposeDetachedControllers(about: previousAbout, quote: previousQuote);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnackBar(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      controller: _sheetController,
      expand: false,
      initialChildSize: 0.62,
      minChildSize: 0.42,
      maxChildSize: 0.92,
      builder: (context, scrollController) {
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _theme.isEmpresa
                          ? 'Más sobre la empresa'
                          : 'Más sobre mí',
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppBrandColors.textMuted,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(16, 4, 16, 28 + bottomInset),
                  children: [
                    if (_showAbout) _buildAboutCard(),
                    if (_showExperience) _buildExperienceCard(),
                    if (_showQuote) _buildQuoteCard(),
                    if (_showServiceArea) _buildServiceAreaCard(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutCard() {
    final editing = _editing == _AboutInlineEdit.about;
    return _ProfileSectionCard(
      title: widget.ui.aboutTitle,
      icon: Icons.person_outline_rounded,
      theme: _theme,
      highlighted: editing,
      onEdit: widget.canEdit && !editing && !_saving
          ? () => _canInlineAbout
              ? _startEdit(_AboutInlineEdit.about)
              : _openLegacyEdit(widget.onEditAbout)
          : null,
      child: editing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthRoundedField(
                  controller: _aboutController!,
                  label: _theme.isEmpresa
                      ? 'Descripción de la empresa'
                      : 'Descripción',
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 2000,
                ),
                const SizedBox(height: 8),
                Text(
                  _theme.isEmpresa
                      ? 'Así verán la empresa tus clientes.'
                      : 'Así te verán tus clientes en el perfil.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.35,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 14),
                _InlineEditActions(
                  theme: _theme,
                  saving: _saving,
                  onCancel: _cancelEdit,
                  onSave: _saveAbout,
                ),
              ],
            )
          : _hasAbout
          ? Text(
              _description!.trim(),
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: AppBrandColors.textDark,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _OwnerEmptyPlaceholder(
                  text: _theme.isEmpresa
                      ? 'Cuenta quiénes son y qué los diferencia.'
                      : 'Cuéntale a tus clientes quién eres y cómo trabajas.',
                ),
                if (widget.canEdit) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _canInlineAbout
                        ? _startEdit(_AboutInlineEdit.about)
                        : _openLegacyEdit(widget.onEditAbout),
                    icon: Icon(Icons.edit_outlined, color: _theme.accent),
                    label: Text(
                      'Escribir ahora',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: _theme.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildExperienceCard() {
    final editing = _editing == _AboutInlineEdit.experience;
    return _ProfileSectionCard(
      title: 'Experiencia',
      icon: Icons.workspace_premium_outlined,
      theme: _theme,
      highlighted: editing,
      onEdit: widget.canEdit && !editing && !_saving
          ? () => _canInlineExperience
              ? _startEdit(_AboutInlineEdit.experience)
              : _openLegacyEdit(widget.onEditExperience)
          : null,
      child: editing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selecciona cuántos años llevas ejerciendo tu profesión.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _experienceYearOptions.map((years) {
                    final selected = _draftYears == years;
                    return ChoiceChip(
                      label: Text(_experienceLabel(years)),
                      selected: selected,
                      onSelected: _saving
                          ? null
                          : (_) => setState(() => _draftYears = years),
                      selectedColor: _theme.accent.withValues(alpha: 0.15),
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? _theme.accent
                            : AppBrandColors.textDark,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                _InlineEditActions(
                  theme: _theme,
                  saving: _saving,
                  saveEnabled: _draftYears != null,
                  onCancel: _cancelEdit,
                  onSave: _saveExperience,
                ),
              ],
            )
          : _hasExperience
          ? Text(
              _experienceLabel(_experienceYears!),
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textDark,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _OwnerEmptyPlaceholder(
                  text:
                      'Indica cuántos años llevas ejerciendo tu profesión.',
                ),
                if (widget.canEdit) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _canInlineExperience
                        ? _startEdit(_AboutInlineEdit.experience)
                        : _openLegacyEdit(widget.onEditExperience),
                    icon: Icon(Icons.edit_outlined, color: _theme.accent),
                    label: Text(
                      'Agregar experiencia',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: _theme.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _buildQuoteCard() {
    final editing = _editing == _AboutInlineEdit.quote;
    final quoteLabel = formatMinimumQuoteLabel(
      _minimumQuote,
      compact: false,
    );
    return _ProfileSectionCard(
      title: 'Cotización mínima',
      icon: Icons.payments_outlined,
      theme: _theme,
      highlighted: editing,
      onEdit: widget.canEdit && !editing && !_saving
          ? () => _canInlineQuote
              ? _startEdit(_AboutInlineEdit.quote)
              : _openLegacyEdit(widget.onEditAbout)
          : null,
      child: editing
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Opcional. Monto mínimo desde el que aceptas trabajos.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.35,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                AuthRoundedField(
                  controller: _quoteController!,
                  label: 'Desde (S/)',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) => validateMinimumQuoteInput(v ?? ''),
                ),
                const SizedBox(height: 14),
                _InlineEditActions(
                  theme: _theme,
                  saving: _saving,
                  onCancel: _cancelEdit,
                  onSave: _saveQuote,
                ),
              ],
            )
          : quoteLabel != null
          ? Text(
              quoteLabel,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textDark,
              ),
            )
          : const _OwnerEmptyPlaceholder(
              text:
                  'Indica desde qué monto aceptas trabajos. '
                  'Ejemplo: S/ 100',
            ),
    );
  }

  Widget _buildServiceAreaCard() {
    return _ProfileSectionCard(
      title: 'Zona de servicio',
      icon: Icons.map_outlined,
      theme: _theme,
      onEdit: widget.canEdit && !_saving && widget.onEditServiceArea != null
          ? () => _openLegacyEdit(widget.onEditServiceArea)
          : null,
      child: _hasServiceAreaContent
          ? _ServiceAreaBlock(
              address: widget.ui.serviceArea,
              lat: widget.technician.location?.lat,
              lng: widget.technician.location?.lng,
              distanceKm: widget.technician.distanceKm,
              coversAllPeru: widget.technician.coversAllPeru,
              coverageDistricts: widget.technician.coverageDistricts,
              theme: _theme,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _OwnerEmptyPlaceholder(
                  text: 'Configura tu ubicación y dónde atiendes.',
                ),
                if (widget.canEdit && widget.onEditServiceArea != null) ...[
                  const SizedBox(height: 10),
                  TextButton.icon(
                    onPressed: () => _openLegacyEdit(widget.onEditServiceArea),
                    icon: Icon(Icons.map_outlined, color: _theme.accent),
                    label: Text(
                      'Configurar zona',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: _theme.accent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

class _InlineEditActions extends StatelessWidget {
  const _InlineEditActions({
    required this.theme,
    required this.saving,
    required this.onCancel,
    required this.onSave,
    this.saveEnabled = true,
  });

  final ClientTechnicianProfileTheme theme;
  final bool saving;
  final bool saveEnabled;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: saving ? null : onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppBrandColors.textDark,
              side: const BorderSide(color: Color(0xFFE5E7EB)),
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: saving || !saveEnabled ? null : onSave,
            style: FilledButton.styleFrom(
              backgroundColor: theme.accent,
              disabledBackgroundColor: theme.accent.withValues(alpha: 0.45),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Guardar',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
          ),
        ),
      ],
    );
  }
}

class _OwnerEmptyPlaceholder extends StatelessWidget {
  const _OwnerEmptyPlaceholder({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        height: 1.45,
        color: AppBrandColors.textMuted,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

class _ProfileSectionCard extends StatelessWidget {
  const _ProfileSectionCard({
    required this.title,
    required this.child,
    required this.theme,
    this.icon,
    this.onEdit,
    this.highlighted = false,
  });

  final String title;
  final Widget child;
  final ClientTechnicianProfileTheme theme;
  final IconData? icon;
  final VoidCallback? onEdit;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: highlighted ? theme.accent : const Color(0xFFE8EAED),
            width: highlighted ? 1.6 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080B1C15),
              blurRadius: 14,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
              decoration: BoxDecoration(
                color: theme.accentSoft.withValues(alpha: 0.55),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.accentBorder),
                      ),
                      child: Icon(icon, size: 17, color: theme.accent),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                  ),
                  if (onEdit != null)
                    TextButton.icon(
                      onPressed: onEdit,
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 16,
                        color: theme.accent,
                      ),
                      label: Text(
                        'Editar',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: theme.accent,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceAreaBlock extends StatelessWidget {
  const _ServiceAreaBlock({
    this.address,
    this.lat,
    this.lng,
    this.distanceKm,
    this.coversAllPeru = false,
    this.coverageDistricts = const [],
    required this.theme,
  });

  final String? address;
  final double? lat;
  final double? lng;
  final double? distanceKm;
  final bool coversAllPeru;
  final List<TechnicianCoverageDistrictModel> coverageDistricts;
  final ClientTechnicianProfileTheme theme;

  String _shortDistrictLabel(String label) {
    if (label.toLowerCase().startsWith('toda la provincia')) {
      return label;
    }
    final parts = label.split(',');
    return parts.first.trim();
  }

  bool get _hasAddress {
    final text = address?.trim();
    return text != null && text.isNotEmpty;
  }

  bool get _canOpenMaps =>
      MapsLaunchActions.canOpen(lat: lat, lng: lng, address: address);

  bool get _hasLocation => _hasAddress || distanceKm != null;

  bool get _hasCoverage => coversAllPeru || coverageDistricts.isNotEmpty;

  Future<void> _openMaps(BuildContext context) {
    return MapsLaunchActions.openLocation(
      context,
      lat: lat,
      lng: lng,
      address: address,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_hasLocation) ...[
          _ServiceAreaLabeledRow(
            label: 'Ubicación',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_hasAddress)
                  _canOpenMaps
                      ? _MapsAddressRow(
                          address: address!.trim(),
                          accent: theme.accent,
                          accentSoft: theme.accentSoft,
                          onTap: () => _openMaps(context),
                        )
                      : Text(
                          address!.trim(),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w600,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                if (distanceKm != null) ...[
                  if (_hasAddress) const SizedBox(height: 6),
                  Text(
                    'A ${distanceKm!.toStringAsFixed(1)} km de ti',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        if (_hasLocation && _hasCoverage) const SizedBox(height: 14),
        if (_hasCoverage)
          _ServiceAreaLabeledRow(
            label: 'Atiende en',
            child: coversAllPeru
                ? Text(
                    'Todo el Perú',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: theme.accent,
                    ),
                  )
                : Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: coverageDistricts.map((district) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: theme.accentSoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _shortDistrictLabel(district.label),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: district.isPrimary
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: AppBrandColors.textDark,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
      ],
    );
  }
}

class _MapsAddressRow extends StatelessWidget {
  const _MapsAddressRow({
    required this.address,
    required this.accent,
    required this.accentSoft,
    required this.onTap,
  });

  final String address;
  final Color accent;
  final Color accentSoft;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Abrir ubicación en Maps',
      child: Material(
        color: accentSoft,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_rounded, size: 20, color: accent),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 16,
                  color: accent.withValues(alpha: 0.85),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ServiceAreaLabeledRow extends StatelessWidget {
  const _ServiceAreaLabeledRow({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppBrandColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}
