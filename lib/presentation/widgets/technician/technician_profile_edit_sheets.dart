import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/image_picker_utils.dart';
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
