import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/contact_launch_actions.dart';
import '../../../core/utils/contact_lead_validators.dart';
import '../../../core/utils/contact_metric_utils.dart';
import '../../../core/utils/error_utils.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../data/models/technicians/contact_lead_model.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/repository_providers.dart';
import '../auth/auth_ui.dart';

enum SellerContactLeadMode { phone, whatsApp }

abstract final class SellerContactLeadSheet {
  static Future<void> show({
    required BuildContext context,
    required SellerContactLeadMode mode,
    required int sellerUserId,
    required String sellerName,
    required String? sellerPhone,
    int? productId,
    int? subcategoryId,
    String? productTitle,
    String? materialName,
    String? contactMetricType,
  }) {
    final hasPhone = sellerPhone != null && sellerPhone.trim().isNotEmpty;
    if (!hasPhone) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$sellerName aún no tiene teléfono publicado.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return Future.value();
    }

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: false,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _SellerContactLeadSheetBody(
        mode: mode,
        sellerUserId: sellerUserId,
        sellerName: sellerName,
        sellerPhone: sellerPhone,
        productId: productId,
        subcategoryId: subcategoryId,
        productTitle: productTitle,
        materialName: materialName,
        contactMetricType: ContactMetricType.fromJson(contactMetricType),
      ),
    );
  }
}

class _SellerContactLeadSheetBody extends ConsumerStatefulWidget {
  const _SellerContactLeadSheetBody({
    required this.mode,
    required this.sellerUserId,
    required this.sellerName,
    required this.sellerPhone,
    this.productId,
    this.subcategoryId,
    this.productTitle,
    this.materialName,
    this.contactMetricType = ContactMetricType.none,
  });

  final SellerContactLeadMode mode;
  final int sellerUserId;
  final String sellerName;
  final String? sellerPhone;
  final int? productId;
  final int? subcategoryId;
  final String? productTitle;
  final String? materialName;
  final ContactMetricType contactMetricType;

  @override
  ConsumerState<_SellerContactLeadSheetBody> createState() =>
      _SellerContactLeadSheetBodyState();
}

class _SellerContactLeadSheetBodyState
    extends ConsumerState<_SellerContactLeadSheetBody> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _messageController;
  late final TextEditingController _metricController;
  bool _acceptedTerms = false;
  bool _submitting = false;
  bool _termsError = false;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  bool get _isWhatsApp => widget.mode == SellerContactLeadMode.whatsApp;
  bool get _requiresMetric =>
      widget.contactMetricType != ContactMetricType.none;

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

  String _productContext({double? metricValue}) {
    return ContactMetricUtils.buildProductContactContext(
      materialName: widget.materialName,
      productTitle: widget.productTitle,
      metricType: widget.contactMetricType,
      metricValue: metricValue,
    );
  }

  void _refreshWhatsAppMessage() {
    if (!_isWhatsApp) return;
    final metricValue = ContactMetricUtils.parseMetricValue(
      _metricController.text,
      widget.contactMetricType,
    );
    _messageController.text =
        'Hola ${widget.sellerName}, vi tu negocio en Servicios Técnicos y me interesa consultar.${_productContext(metricValue: metricValue)}';
  }

  String? _composeStoredMessage({required double? metricValue}) {
    if (_isWhatsApp) {
      final base = _messageController.text.trim();
      return base.isEmpty ? null : base;
    }

    final metricSummary = ContactMetricUtils.formatMetricSummary(
      type: widget.contactMetricType,
      value: metricValue,
    );
    if (metricSummary.isEmpty) return null;

    return widget.contactMetricType == ContactMetricType.area
        ? 'Área aproximada: $metricSummary'
        : 'Cantidad: $metricSummary';
  }

  Future<void> _submit() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
      _termsError = !_acceptedTerms;
    });

    if (!_acceptedTerms) {
      showErrorSnackBar(context, 'Debes aceptar los términos y condiciones.');
      return;
    }

    if (!_formKey.currentState!.validate()) {
      showErrorSnackBar(context, 'Revisa los campos marcados antes de continuar.');
      return;
    }

    final metricValue = ContactMetricUtils.parseMetricValue(
      _metricController.text,
      widget.contactMetricType,
    );

    setState(() => _submitting = true);
    try {
      await ref.read(sellersRepositoryProvider).submitContactLead(
            sellerUserId: widget.sellerUserId,
            request: SubmitSellerContactRequest(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
              channel: _isWhatsApp
                  ? SellerContactChannel.whatsapp
                  : SellerContactChannel.phone,
              message: _composeStoredMessage(metricValue: metricValue),
              productId: widget.productId,
              subcategoryId: widget.subcategoryId,
              acceptedTerms: true,
            ),
          );

      if (!mounted) return;
      Navigator.pop(context);

      ContactLaunchActions.showSuccessSnackBar(
        context,
        isWhatsApp: _isWhatsApp,
      );

      if (_isWhatsApp) {
        await ContactLaunchActions.whatsApp(
          context,
          widget.sellerPhone,
          message: _messageController.text.trim(),
        );
      } else {
        await ContactLaunchActions.call(context, widget.sellerPhone);
      }
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final keyboardInset = mediaQuery.viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 8),
          child: Material(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidateMode,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _isWhatsApp
                                ? 'Contactar por WhatsApp'
                                : 'Llamar al vendedor',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed:
                              _submitting ? null : () => Navigator.pop(context),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Registramos tu interés en ${widget.sellerName} y te conectamos.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppBrandColors.textMuted,
                        height: 1.45,
                      ),
                    ),
                    if (widget.materialName != null &&
                        widget.materialName!.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.materialName!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppBrandColors.textDark,
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    AuthRoundedField(
                      controller: _nameController,
                      label: 'Tu nombre *',
                      readOnly: _submitting,
                      validator: ContactLeadValidators.name,
                    ),
                    const SizedBox(height: 12),
                    AuthRoundedField(
                      controller: _emailController,
                      label: 'Email *',
                      readOnly: _submitting,
                      keyboardType: TextInputType.emailAddress,
                      validator: ContactLeadValidators.email,
                    ),
                    const SizedBox(height: 12),
                    AuthRoundedField(
                      controller: _phoneController,
                      label: 'Teléfono *',
                      readOnly: _submitting,
                      keyboardType: TextInputType.phone,
                      validator: ContactLeadValidators.phone,
                    ),
                    if (_requiresMetric) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _metricController,
                        enabled: !_submitting,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters:
                            widget.contactMetricType == ContactMetricType.quantity
                                ? [FilteringTextInputFormatter.digitsOnly]
                                : null,
                        autovalidateMode: _autovalidateMode,
                        validator: (value) => ContactMetricUtils.validateMetric(
                          value,
                          widget.contactMetricType,
                        ),
                        onChanged: (_) {
                          if (_isWhatsApp) {
                            setState(_refreshWhatsAppMessage);
                          }
                        },
                        style: GoogleFonts.poppins(
                          color: AppBrandColors.textDark,
                        ),
                        decoration: InputDecoration(
                          labelText: ContactMetricUtils.metricFieldLabel(
                            widget.contactMetricType,
                          ),
                          hintText: ContactMetricUtils.metricHint(
                            widget.contactMetricType,
                          ),
                          filled: true,
                          fillColor: AppBrandColors.fieldFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                    if (_isWhatsApp) ...[
                      const SizedBox(height: 12),
                      AuthRoundedField(
                        controller: _messageController,
                        label: 'Mensaje *',
                        readOnly: _submitting,
                        maxLines: 4,
                        validator: (value) => ContactLeadValidators.message(
                          value,
                          required: true,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      value: _acceptedTerms,
                      onChanged: _submitting
                          ? null
                          : (value) => setState(() {
                                _acceptedTerms = value ?? false;
                                _termsError = false;
                              }),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text.rich(
                        TextSpan(
                          text: 'Acepto los términos y condiciones',
                          style: GoogleFonts.montserrat(fontSize: 13),
                        ),
                      ),
                    ),
                    if (_termsError) ...[
                      Text(
                        'Debes aceptar los términos para continuar.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    AuthPrimaryButton(
                      label: _submitting
                          ? 'Enviando…'
                          : (_isWhatsApp ? 'Iniciar chat' : 'Enviar y llamar'),
                      isLoading: _submitting,
                      onPressed: _submitting ? null : () => _submit(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
