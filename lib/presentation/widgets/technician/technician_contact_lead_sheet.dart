import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/legal_urls.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/contact_launch_actions.dart';
import '../../../core/utils/contact_lead_validators.dart';
import '../../../core/utils/contact_metric_utils.dart';
import '../../../core/utils/error_utils.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';

enum TechnicianContactLeadMode { phone, whatsApp }

abstract final class TechnicianContactLeadSheet {
  static Future<void> show({
    required BuildContext context,
    required TechnicianContactLeadMode mode,
    required int technicianUserId,
    required String technicianName,
    required String? technicianPhone,
    int? subcategoryId,
    List<TechnicianSubSubCategoryModel> availableServices = const [],
    int? initialSubSubCategoryId,
    /// Si es true, el servicio ya viene definido (p. ej. detalle de servicio):
    /// no muestra lista ni permite cambiar.
    bool lockToService = false,
    /// Caso del catálogo desde el que se inicia el contacto.
    TechnicianWorkPhotoModel? workCase,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _TechnicianContactLeadSheetBody(
        mode: mode,
        technicianUserId: technicianUserId,
        technicianName: technicianName,
        technicianPhone: technicianPhone,
        subcategoryId: subcategoryId,
        availableServices: availableServices,
        initialSubSubCategoryId: initialSubSubCategoryId,
        lockToService: lockToService,
        workCase: workCase,
      ),
    );
  }
}

class _TechnicianContactLeadSheetBody extends ConsumerStatefulWidget {
  const _TechnicianContactLeadSheetBody({
    required this.mode,
    required this.technicianUserId,
    required this.technicianName,
    required this.technicianPhone,
    this.subcategoryId,
    this.availableServices = const [],
    this.initialSubSubCategoryId,
    this.lockToService = false,
    this.workCase,
  });

  final TechnicianContactLeadMode mode;
  final int technicianUserId;
  final String technicianName;
  final String? technicianPhone;
  final int? subcategoryId;
  final List<TechnicianSubSubCategoryModel> availableServices;
  final int? initialSubSubCategoryId;
  final bool lockToService;
  final TechnicianWorkPhotoModel? workCase;

  @override
  ConsumerState<_TechnicianContactLeadSheetBody> createState() =>
      _TechnicianContactLeadSheetBodyState();
}

class _TechnicianContactLeadSheetBodyState
    extends ConsumerState<_TechnicianContactLeadSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;
  late final TextEditingController _metricController;

  bool _acceptedTerms = false;
  bool _marketingConsent = false;
  bool _submitting = false;
  bool _termsError = false;
  bool _selectingService = false;
  int? _selectedSubSubCategoryId;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool get _isWhatsApp => widget.mode == TechnicianContactLeadMode.whatsApp;
  bool get _requiresServiceSelection => widget.availableServices.isNotEmpty;

  TechnicianSubSubCategoryModel? get _selectedService {
    final selectedId = _selectedSubSubCategoryId;
    if (selectedId == null) return null;
    for (final service in widget.availableServices) {
      if (service.id == selectedId) return service;
    }
    return null;
  }

  ContactMetricType get _selectedMetricType =>
      ContactMetricType.fromJson(_selectedService?.contactMetricType);

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).valueOrNull;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(
      text: user?.views?.client?.phone ?? '',
    );
    _metricController = TextEditingController();
    _messageController = TextEditingController();

    if (_requiresServiceSelection) {
      final initialId = widget.initialSubSubCategoryId;
      final hasInitial = initialId != null &&
          widget.availableServices.any((service) => service.id == initialId);
      if (hasInitial) {
        _selectedSubSubCategoryId = initialId;
        _selectingService = false;
      } else if (widget.lockToService && widget.availableServices.length == 1) {
        _selectedSubSubCategoryId = widget.availableServices.first.id;
        _selectingService = false;
      } else if (widget.lockToService) {
        // Servicio fijo esperado pero no resoluble: no mostrar selector.
        _selectingService = false;
      } else {
        _selectingService = true;
      }
    }

    _refreshWhatsAppMessage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    _metricController.dispose();
    super.dispose();
  }

  void _refreshWhatsAppMessage() {
    if (!_isWhatsApp) return;
    final contextText = ContactMetricUtils.buildWhatsAppContext(
      service: _selectedService,
      metricType: _selectedMetricType,
      metricValue: ContactMetricUtils.parseMetricValue(
        _metricController.text,
        _selectedMetricType,
      ),
      workCase: widget.workCase,
    );
    final intro = widget.workCase != null
        ? 'Hola ${widget.technicianName}, vi este trabajo de tu catálogo en Servicios Técnicos y me interesa algo similar.'
        : 'Hola ${widget.technicianName}, vi tu perfil en Servicios Técnicos y me interesa contactarte por un servicio.';

    // Link OG /share/trabajo al inicio: WhatsApp genera mejor el preview.
    final workCase = widget.workCase;
    final caseTitle = workCase?.caption?.trim();
    final shareUrl = ContactMetricUtils.workCaseShareUrlForWhatsApp(
      workCase,
      title: (caseTitle != null && caseTitle.isNotEmpty)
          ? caseTitle
          : 'Trabajo del catálogo',
      description: _selectedService != null
          ? 'Servicio: ${_selectedService!.name}'
          : null,
    );
    if (shareUrl != null) {
      _messageController.text = '$shareUrl\n\n$intro$contextText';
    } else {
      _messageController.text = '$intro$contextText';
    }
  }

  void _continueFromServiceSelection() {
    if (_selectedSubSubCategoryId == null) {
      showErrorSnackBar(context, 'Selecciona el servicio que necesitas.');
      return;
    }
    setState(() {
      _selectingService = false;
      _refreshWhatsAppMessage();
    });
  }

  Future<void> _submit() async {
    if (_requiresServiceSelection && _selectedSubSubCategoryId == null) {
      showErrorSnackBar(context, 'Selecciona el servicio que necesitas.');
      return;
    }

    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
      _termsError = !_acceptedTerms;
    });

    if (!_acceptedTerms) {
      showErrorSnackBar(
        context,
        'Debes aceptar los Términos y Condiciones y la política de privacidad.',
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      showErrorSnackBar(context, 'Revisa los campos marcados antes de continuar.');
      return;
    }

    final selectedService = _selectedService;
    final metricValue = ContactMetricUtils.parseMetricValue(
      _metricController.text,
      _selectedMetricType,
    );

    setState(() => _submitting = true);
    try {
      await ref.read(techniciansRepositoryProvider).submitContactLead(
            technicianUserId: widget.technicianUserId,
            request: SubmitTechnicianContactRequest(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              channel: _isWhatsApp
                  ? TechnicianContactChannel.whatsapp
                  : TechnicianContactChannel.phone,
              message: _isWhatsApp ? _messageController.text.trim() : null,
              subcategoryId: selectedService?.subcategoryId ?? widget.subcategoryId,
              subSubCategoryId: _selectedSubSubCategoryId,
              metricValue: metricValue,
              acceptedTerms: true,
              marketingConsent: _marketingConsent,
            ),
          );

      if (!mounted) return;
      Navigator.of(context).pop();

      ContactLaunchActions.showSuccessSnackBar(
        context,
        isWhatsApp: _isWhatsApp,
      );

      if (_isWhatsApp) {
        await ContactLaunchActions.whatsApp(
          context,
          widget.technicianPhone,
          message: _messageController.text.trim(),
        );
      } else {
        await ContactLaunchActions.call(context, widget.technicianPhone);
      }
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isWhatsApp) _WhatsAppHeader(onClose: () => Navigator.pop(context)),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: _selectingService && !widget.lockToService
                      ? _buildServiceSelection()
                      : Form(
                          key: _formKey,
                          autovalidateMode: _autovalidateMode,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!_isWhatsApp) ...[
                                _PhoneLeadHeader(technicianName: widget.technicianName),
                                const SizedBox(height: 20),
                              ] else ...[
                                Text(
                                  widget.workCase != null
                                      ? 'Escribe un mensaje sobre este trabajo del catálogo'
                                      : 'Escribe un mensaje al técnico por este servicio',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: AppBrandColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                              if (widget.workCase != null) ...[
                                _SelectedWorkCaseChip(workCase: widget.workCase!),
                                const SizedBox(height: 12),
                              ],
                              if (_selectedService != null) ...[
                                _SelectedServiceChip(
                                  service: _selectedService!,
                                  onChange: !widget.lockToService &&
                                          _requiresServiceSelection &&
                                          widget.availableServices.length > 1
                                      ? () => setState(() => _selectingService = true)
                                      : null,
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (_selectedMetricType != ContactMetricType.none) ...[
                                _LeadTextField(
                                  controller: _metricController,
                                  label: ContactMetricUtils.metricFieldLabel(
                                    _selectedMetricType,
                                  ),
                                  hintText: ContactMetricUtils.metricHint(
                                    _selectedMetricType,
                                  ),
                                  enabled: !_submitting,
                                  keyboardType: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  inputFormatters: _selectedMetricType ==
                                          ContactMetricType.quantity
                                      ? [FilteringTextInputFormatter.digitsOnly]
                                      : null,
                                  onChanged: (_) => _refreshWhatsAppMessage(),
                                  validator: (value) => ContactMetricUtils.validateMetric(
                                    value,
                                    _selectedMetricType,
                                  ),
                                ),
                                const SizedBox(height: 12),
                              ],
                              if (_isWhatsApp) ...[
                                _LeadTextField(
                                  controller: _nameController,
                                  label: 'Nombre *',
                                  enabled: !_submitting,
                                  textInputAction: TextInputAction.next,
                                  validator: ContactLeadValidators.name,
                                ),
                                const SizedBox(height: 12),
                              ],
                              _LeadTextField(
                                controller: _emailController,
                                label: 'Email *',
                                enabled: !_submitting,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: ContactLeadValidators.email,
                              ),
                              const SizedBox(height: 12),
                              if (_isWhatsApp)
                                _LeadTextField(
                                  controller: _phoneController,
                                  label: 'Teléfono *',
                                  enabled: !_submitting,
                                  maxLength: 9,
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.next,
                                  validator: ContactLeadValidators.phone,
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: _LeadTextField(
                                        controller: _nameController,
                                        label: 'Nombre *',
                                        enabled: !_submitting,
                                        textInputAction: TextInputAction.next,
                                        validator: ContactLeadValidators.name,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _LeadTextField(
                                        controller: _phoneController,
                                        label: 'Teléfono *',
                                        enabled: !_submitting,
                                        keyboardType: TextInputType.phone,
                                        textInputAction: TextInputAction.done,
                                        validator: ContactLeadValidators.phone,
                                      ),
                                    ),
                                  ],
                                ),
                              if (_isWhatsApp) ...[
                                const SizedBox(height: 12),
                                _LeadTextField(
                                  controller: _messageController,
                                  label: 'Mensaje *',
                                  enabled: !_submitting,
                                  maxLines: 4,
                                  maxLength: 1000,
                                  validator: (value) => ContactLeadValidators.message(
                                    value,
                                    required: true,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              _ConsentCheckbox(
                                value: _acceptedTerms,
                                onChanged: _submitting
                                    ? null
                                    : (value) => setState(() {
                                          _acceptedTerms = value ?? false;
                                          _termsError = false;
                                        }),
                                label: _termsLabel(),
                              ),
                              if (_termsError) ...[
                                const SizedBox(height: 4),
                                Text(
                                  'Debes aceptar los términos para continuar.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              _ConsentCheckbox(
                                value: _marketingConsent,
                                onChanged: _submitting
                                    ? null
                                    : (value) =>
                                        setState(() => _marketingConsent = value ?? false),
                                label: _marketingLabel(),
                              ),
                              const SizedBox(height: 20),
                              FilledButton(
                                onPressed: _submitting ? null : _submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: _isWhatsApp
                                      ? const Color(0xFF25D366)
                                      : const Color(0xFF005F4B),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _submitting
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        _isWhatsApp ? 'Iniciar chat' : 'Enviar',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        Text(
          '¿Qué servicio necesitas?',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Elige el servicio para que el técnico sepa cómo ayudarte.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppBrandColors.textMuted,
            height: 1.45,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.availableServices.map((service) {
          final selected = _selectedSubSubCategoryId == service.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: selected
                  ? AppBrandColors.primaryGreen.withValues(alpha: 0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => _selectedSubSubCategoryId = service.id),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? AppBrandColors.primaryGreen
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: AppBrandColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service.subcategoryName,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _continueFromServiceSelection,
          style: FilledButton.styleFrom(
            backgroundColor: AppBrandColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(
            'Continuar',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _termsLabel() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: AppBrandColors.textDark,
          height: 1.4,
        ),
        children: [
          const TextSpan(text: 'Acepto los '),
          TextSpan(
            text: 'Términos y Condiciones de Uso',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () => ContactLaunchActions.openLegalPage(
                    context,
                    LegalUrls.termsAndConditions,
                  ),
          ),
          const TextSpan(text: ', y las '),
          TextSpan(
            text: 'políticas de privacidad',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () => ContactLaunchActions.openLegalPage(
                    context,
                    LegalUrls.privacyPolicy,
                  ),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  Widget _marketingLabel() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: AppBrandColors.textDark,
          height: 1.4,
        ),
        children: [
          const TextSpan(text: 'Autorizo el uso de mi información para '),
          TextSpan(
            text: 'fines adicionales',
            style: const TextStyle(decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _showLegalDialog('Uso de información'),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }

  void _showLegalDialog(String title) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(
          'Documento legal en preparación. Al continuar confirmas que has leído '
          'y aceptas nuestras políticas de uso de datos.',
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

class _SelectedWorkCaseChip extends StatelessWidget {
  const _SelectedWorkCaseChip({required this.workCase});

  final TechnicianWorkPhotoModel workCase;

  @override
  Widget build(BuildContext context) {
    final caption = workCase.caption?.trim();
    final title = (caption != null && caption.isNotEmpty)
        ? caption
        : 'Trabajo realizado';
    final estimated =
        ContactMetricUtils.formatWorkCaseEstimatedCost(
      estimatedCost: workCase.estimatedCost,
      estimatedCostMin: workCase.estimatedCostMin,
      estimatedCostMax: workCase.estimatedCostMax,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 18,
            color: AppBrandColors.primaryGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Caso del catálogo',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                Text(
                  estimated.isEmpty ? title : '$title · $estimated',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textDark,
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

class _SelectedServiceChip extends StatelessWidget {
  const _SelectedServiceChip({
    required this.service,
    this.onChange,
  });

  final TechnicianSubSubCategoryModel service;
  final VoidCallback? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.build_outlined, size: 18, color: AppBrandColors.primaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Servicio: ${service.name}',
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppBrandColors.textDark,
              ),
            ),
          ),
          if (onChange != null)
            TextButton(
              onPressed: onChange,
              child: const Text('Cambiar'),
            ),
        ],
      ),
    );
  }
}

class _WhatsAppHeader extends StatelessWidget {
  const _WhatsAppHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
      decoration: const BoxDecoration(
        color: Color(0xFF075E54),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Text(
            'WhatsApp',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _PhoneLeadHeader extends StatelessWidget {
  const _PhoneLeadHeader({required this.technicianName});

  final String technicianName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
          ),
        ),
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppBrandColors.fieldFill,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.phone_in_talk_rounded,
            color: AppBrandColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Completa tus datos y contacta al técnico',
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppBrandColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Registramos tu interés y te mostramos el teléfono de $technicianName.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppBrandColors.textMuted,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _LeadTextField extends StatelessWidget {
  const _LeadTextField({
    required this.controller,
    required this.label,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.inputFormatters,
    this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final int maxLines;
  final int? maxLength;
  final bool enabled;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppBrandColors.primaryGreen),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}

class _ConsentCheckbox extends StatelessWidget {
  const _ConsentCheckbox({
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool?>? onChanged;
  final Widget label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF005F4B),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Expanded(child: Padding(padding: const EdgeInsets.only(top: 10), child: label)),
      ],
    );
  }
}
