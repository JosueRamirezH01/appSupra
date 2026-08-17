import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
import '../../../core/utils/work_portfolio_upload_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../data/models/uploads/upload_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../providers/repository_providers.dart';
import '../../utils/technician_pricing_utils.dart';
import '../auth/auth_ui.dart';

Future<void> showEditAboutSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _EditAboutSheet(
      profile: profile,
      onSave: (phone, description, minimumQuoteText) async {
        await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
              UpdateTechnicianProfileRequest(
                phone: phone,
                description: description,
                // '' limpia; monto como texto (entero o decimal).
                minimumQuote: minimumQuoteText,
              ),
            );
        ref.invalidate(technicianDetailProvider(userId));
      },
    ),
  );
}

Future<void> showEditExperienceSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _EditExperienceSheet(
      profile: profile,
      onSave: (years) async {
        await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
              UpdateTechnicianProfileRequest(
                experienceYears: years,
              ),
            );
        ref.invalidate(technicianDetailProvider(userId));
      },
    ),
  );
}

Future<void> pickAndUpdateProfilePhoto(
  BuildContext context,
  WidgetRef ref, {
  required int userId,
}) async {
  final file = await ImagePickerUtils.pickPublicCatalogImage(context);
  if (file == null || !context.mounted) return;

  try {
    final upload = await ref.read(uploadsRepositoryProvider).uploadTechnicianFile(
          category: UploadCategory.profilePhoto,
          file: file,
        );

    await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
          UpdateTechnicianProfileRequest(
            profilePhotoUrl: upload.file.url,
          ),
        );
    ref.invalidate(technicianDetailProvider(userId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Foto actualizada', style: GoogleFonts.poppins()),
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}

/// Sube la portada de la card del servicio (`cardImageServiceUrl`).
Future<void> pickAndUpdateServiceCardImage(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianSubSubCategoryModel service,
  required int userId,
}) async {
  final file = await ImagePickerUtils.pickPublicCatalogImage(context);
  if (file == null || !context.mounted) return;

  ref.read(serviceCardImageUploadingIdProvider.notifier).state = service.id;
  try {
    final upload = await ref.read(uploadsRepositoryProvider).uploadTechnicianFile(
          category: UploadCategory.workPhoto,
          file: file,
        );
    final imageUrl = WorkPortfolioUploadUtils.resolveReference(upload.file);

    final updated = await ref
        .read(myTechnicianServiceProvider(service.id).notifier)
        .updateService(
          UpdateTechnicianServiceRequest(
            cardImageServiceUrl: imageUrl,
          ),
        );

    // Asegura la URL en el carrusel aunque el response/GET vengan incompletos.
    final cardUrl = (updated.cardImageServiceUrl?.trim().isNotEmpty ?? false)
        ? updated.cardImageServiceUrl
        : imageUrl;
    ref.read(myTechnicianProfileProvider.notifier).patchSubSubCategory(
          updated.copyWith(cardImageServiceUrl: cardUrl),
        );

    // Detalle público en segundo plano (el carrusel ya se actualizó en el perfil).
    ref.invalidate(technicianDetailProvider(userId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imagen de la card actualizada',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  } finally {
    ref.read(serviceCardImageUploadingIdProvider.notifier).state = null;
  }
}

class _EditAboutSheet extends StatefulWidget {
  const _EditAboutSheet({
    required this.profile,
    required this.onSave,
  });

  final TechnicianApplicationModel profile;
  final Future<void> Function(
    String phone,
    String description,
    String minimumQuoteText,
  ) onSave;

  @override
  State<_EditAboutSheet> createState() => _EditAboutSheetState();
}

class _EditAboutSheetState extends State<_EditAboutSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _phoneController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _minimumQuoteController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.profile.phone ?? '');
    _descriptionController =
        TextEditingController(text: widget.profile.description ?? '');
    final quote = widget.profile.minimumQuote;
    _minimumQuoteController = TextEditingController(
      text: quote == null
          ? ''
          : (quote % 1 == 0 ? quote.toInt().toString() : quote.toString()),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _descriptionController.dispose();
    _minimumQuoteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(
        _phoneController.text.trim(),
        _descriptionController.text.trim(),
        _minimumQuoteController.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.profile.profileType == 'empresa'
                    ? 'Sobre la empresa'
                    : 'Sobre mí',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              AuthRoundedField(
                controller: _phoneController,
                label: 'Teléfono *',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.trim().length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 14),
              AuthRoundedField(
                controller: _descriptionController,
                label: widget.profile.profileType == 'empresa'
                    ? 'Descripción de la empresa'
                    : 'Descripción',
                minLines: 3,
                maxLines: 6,
                maxLength: 2000,
              ),
              const SizedBox(height: 14),
              Text(
                'Cotización mínima',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Opcional. Monto mínimo desde el que aceptas trabajos '
                '(entero o decimal). Se muestra en tu tarjeta.',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  height: 1.35,
                  color: AppBrandColors.textMuted,
                ),
              ),
              const SizedBox(height: 10),
              AuthRoundedField(
                controller: _minimumQuoteController,
                label: 'Desde (S/)',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => validateMinimumQuoteInput(v ?? ''),
              ),
              const SizedBox(height: 20),
              AuthPrimaryButton(
                label: 'Guardar',
                isLoading: _saving,
                onPressed: _saving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditExperienceSheet extends StatefulWidget {
  const _EditExperienceSheet({
    required this.profile,
    required this.onSave,
  });

  final TechnicianApplicationModel profile;
  final Future<void> Function(int? years) onSave;

  @override
  State<_EditExperienceSheet> createState() => _EditExperienceSheetState();
}

class _EditExperienceSheetState extends State<_EditExperienceSheet> {
  static const _yearOptions = [
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 15, 20, 25, 30,
  ];

  int? _selectedYears;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selectedYears = widget.profile.experienceYears;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await widget.onSave(_selectedYears);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _labelForYears(int years) {
    if (years == 0) return 'Menos de 1 año';
    if (years >= 20) return '$years+ años';
    return years == 1 ? '1 año' : '$years años';
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Experiencia',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Selecciona cuántos años llevas ejerciendo tu profesión.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _yearOptions.map((years) {
              final selected = _selectedYears == years;
              return ChoiceChip(
                label: Text(_labelForYears(years)),
                selected: selected,
                onSelected: (_) => setState(() => _selectedYears = years),
                selectedColor: AppBrandColors.primaryGreen.withValues(alpha: 0.15),
                labelStyle: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? AppBrandColors.primaryGreen
                      : AppBrandColors.textDark,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          AuthPrimaryButton(
            label: 'Guardar',
            isLoading: _saving,
            onPressed: _selectedYears == null || _saving ? null : _save,
          ),
        ],
      ),
    );
  }
}

Future<void> showEditServicePricingSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianSubSubCategoryModel service,
  required int userId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _EditServicePricingSheet(
      service: service,
      userId: userId,
    ),
  );
}

class _EditServicePricingSheet extends ConsumerStatefulWidget {
  const _EditServicePricingSheet({
    required this.service,
    required this.userId,
  });

  final TechnicianSubSubCategoryModel service;
  final int userId;

  @override
  ConsumerState<_EditServicePricingSheet> createState() =>
      _EditServicePricingSheetState();
}

class _EditServicePricingSheetState
    extends ConsumerState<_EditServicePricingSheet> {
  late final TextEditingController _laborMinController;
  late final TextEditingController _laborMaxController;
  late final TextEditingController _turnkeyMinController;
  late final TextEditingController _turnkeyMaxController;
  late ProfilePriceDisplay _profilePriceDisplay;
  late bool _laborSelected;
  late bool _turnkeySelected;
  bool _saving = false;

  ServicePricingMode get _mode => widget.service.resolvedPricingMode;

  bool get _canChooseMethods => _mode == ServicePricingMode.both;

  bool get _showLaborFields =>
      _mode.allowsLabor && (!_canChooseMethods || _laborSelected);

  bool get _showTurnkeyFields =>
      _mode.allowsTurnkey && (!_canChooseMethods || _turnkeySelected);

  bool get _showProfilePicker => _canChooseMethods && _laborSelected && _turnkeySelected;

  @override
  void initState() {
    super.initState();
    final service = widget.service;
    _laborMinController = TextEditingController(
      text: service.effectiveLaborMin?.toString() ?? '',
    );
    _laborMaxController = TextEditingController(
      text: service.effectiveLaborMax?.toString() ?? '',
    );
    _turnkeyMinController = TextEditingController(
      text: service.turnkeyPriceMin?.toString() ?? '',
    );
    _turnkeyMaxController = TextEditingController(
      text: service.turnkeyPriceMax?.toString() ?? '',
    );
    _profilePriceDisplay = service.resolvedProfilePriceDisplay;

    if (_mode == ServicePricingMode.labor) {
      _laborSelected = true;
      _turnkeySelected = false;
    } else if (_mode == ServicePricingMode.turnkey) {
      _laborSelected = false;
      _turnkeySelected = true;
    } else {
      final hasLabor = service.hasLaborPricing;
      final hasTurnkey = service.hasTurnkeyPricing;
      if (!hasLabor && !hasTurnkey) {
        _laborSelected = true;
        _turnkeySelected = true;
      } else {
        _laborSelected = hasLabor;
        _turnkeySelected = hasTurnkey;
      }
    }
  }

  @override
  void dispose() {
    _laborMinController.dispose();
    _laborMaxController.dispose();
    _turnkeyMinController.dispose();
    _turnkeyMaxController.dispose();
    super.dispose();
  }

  void _toggleLabor() {
    if (!_canChooseMethods || _saving) return;
    setState(() {
      if (_laborSelected && !_turnkeySelected) return;
      _laborSelected = !_laborSelected;
      if (!_laborSelected &&
          _profilePriceDisplay == ProfilePriceDisplay.labor) {
        _profilePriceDisplay = ProfilePriceDisplay.turnkey;
      }
    });
  }

  void _toggleTurnkey() {
    if (!_canChooseMethods || _saving) return;
    setState(() {
      if (_turnkeySelected && !_laborSelected) return;
      _turnkeySelected = !_turnkeySelected;
      if (!_turnkeySelected &&
          _profilePriceDisplay == ProfilePriceDisplay.turnkey) {
        _profilePriceDisplay = ProfilePriceDisplay.labor;
      }
    });
  }

  Future<void> _save() async {
    if (_saving) return;

    if (_canChooseMethods && !_laborSelected && !_turnkeySelected) {
      showErrorSnackBar(context, 'Selecciona al menos un método de cotización');
      return;
    }

    double? laborMin;
    double? laborMax;
    double? turnkeyMin;
    double? turnkeyMax;

    if (_showLaborFields) {
      final laborError = validatePriceRangeInputs(
        minText: _laborMinController.text,
        maxText: _laborMaxController.text,
        required: true,
        emptyMessage: 'El precio de mano de obra es obligatorio',
        partialMessage: 'Ingresa mínimo y máximo de mano de obra',
      );
      if (laborError != null) {
        showErrorSnackBar(context, laborError);
        return;
      }
      final laborRange = parsePriceRangeInputs(
        minText: _laborMinController.text,
        maxText: _laborMaxController.text,
      );
      laborMin = laborRange.priceMin;
      laborMax = laborRange.priceMax;
    }

    if (_showTurnkeyFields) {
      final turnkeyError = validatePriceRangeInputs(
        minText: _turnkeyMinController.text,
        maxText: _turnkeyMaxController.text,
        required: true,
        emptyMessage: 'El precio todo incluido es obligatorio',
        partialMessage: 'Ingresa mínimo y máximo de todo incluido',
      );
      if (turnkeyError != null) {
        showErrorSnackBar(context, turnkeyError);
        return;
      }
      final turnkeyRange = parsePriceRangeInputs(
        minText: _turnkeyMinController.text,
        maxText: _turnkeyMaxController.text,
      );
      turnkeyMin = turnkeyRange.priceMin;
      turnkeyMax = turnkeyRange.priceMax;
    }

    setState(() => _saving = true);
    try {
      // Releer para conservar rangos del método no editado.
      final latest = await ref.read(
        myTechnicianServiceProvider(widget.service.id).future,
      );

      if (_mode.allowsLabor && !_showLaborFields) {
        laborMin = latest.effectiveLaborMin;
        laborMax = latest.effectiveLaborMax;
      }
      if (_mode.allowsTurnkey && !_showTurnkeyFields) {
        turnkeyMin = latest.turnkeyPriceMin;
        turnkeyMax = latest.turnkeyPriceMax;
      }

      final String? profilePriceDisplay;
      if (_showProfilePicker) {
        profilePriceDisplay = _profilePriceDisplay.apiValue;
      } else if (_showLaborFields && !_showTurnkeyFields) {
        profilePriceDisplay = ProfilePriceDisplay.labor.apiValue;
      } else if (_showTurnkeyFields && !_showLaborFields) {
        profilePriceDisplay = ProfilePriceDisplay.turnkey.apiValue;
      } else {
        profilePriceDisplay = null;
      }

      await ref
          .read(myTechnicianServiceProvider(widget.service.id).notifier)
          .updateService(
            UpdateTechnicianServiceRequest(
              priceMin: laborMin,
              priceMax: laborMax,
              laborPriceMin: laborMin,
              laborPriceMax: laborMax,
              turnkeyPriceMin: _mode.allowsTurnkey ? turnkeyMin : null,
              turnkeyPriceMax: _mode.allowsTurnkey ? turnkeyMax : null,
              profilePriceDisplay: profilePriceDisplay,
            ),
          );
      ref.invalidate(technicianDetailProvider(widget.userId));
      await ref.read(myTechnicianProfileProvider.notifier).refreshQuietly();

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Precios actualizados',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: Padding(
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
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Text(
                'Editar precios',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppBrandColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.service.name,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppBrandColors.textMuted,
                ),
              ),
              if (_canChooseMethods) ...[
                const SizedBox(height: 16),
                Text(
                  '¿Cómo cotizas este servicio?',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Selecciona uno o ambos métodos. Luego completa los rangos.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _SheetMethodOption(
                        label: 'Mano de obra',
                        selected: _laborSelected,
                        enabled: !_saving,
                        onTap: _toggleLabor,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SheetMethodOption(
                        label: 'Todo incluido',
                        selected: _turnkeySelected,
                        enabled: !_saving,
                        onTap: _toggleTurnkey,
                      ),
                    ),
                  ],
                ),
              ],
              if (_showLaborFields) ...[
                const SizedBox(height: 16),
                Text(
                  'Mano de obra',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Solo tu trabajo · rango referencial en soles.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AuthRoundedField(
                        controller: _laborMinController,
                        label: 'Desde (S/)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AuthRoundedField(
                        controller: _laborMaxController,
                        label: 'Hasta (S/)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_showTurnkeyFields) ...[
                const SizedBox(height: 16),
                Text(
                  'Todo incluido',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Materiales y mano de obra · rango referencial.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: AuthRoundedField(
                        controller: _turnkeyMinController,
                        label: 'Desde (S/)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AuthRoundedField(
                        controller: _turnkeyMaxController,
                        label: 'Hasta (S/)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_showProfilePicker) ...[
                const SizedBox(height: 16),
                Text(
                  'Precio en la tarjeta del perfil',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Elige cuál se muestra en el carrusel.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                const SizedBox(height: 10),
                _SheetProfilePriceDisplayPicker(
                  value: _profilePriceDisplay,
                  enabled: !_saving,
                  onChanged: (value) {
                    setState(() => _profilePriceDisplay = value);
                  },
                ),
              ],
              const SizedBox(height: 18),
              AuthPrimaryButton(
                label: 'Guardar',
                isLoading: _saving,
                onPressed: _saving ? null : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetMethodOption extends StatelessWidget {
  const _SheetMethodOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppBrandColors.primaryGreen
        : AppBrandColors.textMuted;
    final background = selected
        ? AppBrandColors.primaryGreen.withValues(alpha: 0.08)
        : const Color(0xFFF7F8FA);
    final border = selected
        ? AppBrandColors.primaryGreen.withValues(alpha: 0.45)
        : const Color(0xFFE8EAED);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_box_rounded
                    : Icons.check_box_outline_blank_rounded,
                size: 18,
                color: foreground,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: foreground,
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

class _SheetProfilePriceDisplayPicker extends StatelessWidget {
  const _SheetProfilePriceDisplayPicker({
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final ProfilePriceDisplay value;
  final ValueChanged<ProfilePriceDisplay> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SheetProfilePriceOption(
            label: 'Mano de obra',
            selected: value == ProfilePriceDisplay.labor,
            enabled: enabled,
            onTap: () => onChanged(ProfilePriceDisplay.labor),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _SheetProfilePriceOption(
            label: 'Todo incluido',
            selected: value == ProfilePriceDisplay.turnkey,
            enabled: enabled,
            onTap: () => onChanged(ProfilePriceDisplay.turnkey),
          ),
        ),
      ],
    );
  }
}

class _SheetProfilePriceOption extends StatelessWidget {
  const _SheetProfilePriceOption({
    required this.label,
    required this.selected,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? AppBrandColors.primaryGreen
        : AppBrandColors.textMuted;
    final background = selected
        ? AppBrandColors.primaryGreen.withValues(alpha: 0.08)
        : const Color(0xFFF7F8FA);
    final border = selected
        ? AppBrandColors.primaryGreen.withValues(alpha: 0.45)
        : const Color(0xFFE8EAED);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_off_rounded,
                size: 18,
                color: foreground,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: foreground,
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

