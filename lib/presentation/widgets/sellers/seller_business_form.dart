import 'package:flutter/material.dart';

import '../auth/auth_ui.dart';

class SellerBusinessFormData {
  const SellerBusinessFormData({
    required this.businessName,
    required this.ruc,
    required this.legalRepresentativeName,
    required this.phone,
    this.address,
    this.description,
  });

  final String businessName;
  final String ruc;
  final String legalRepresentativeName;
  final String phone;
  final String? address;
  final String? description;
}

class SellerBusinessForm extends StatefulWidget {
  const SellerBusinessForm({
    super.key,
    required this.formKey,
    this.phoneController,
    this.initialData,
    this.includePhoneField = true,
    this.includeAddressField = false,
    this.includeDescriptionField = false,
    this.lockIdentityFields = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController? phoneController;
  final SellerBusinessFormData? initialData;
  final bool includePhoneField;
  final bool includeAddressField;
  final bool includeDescriptionField;
  final bool lockIdentityFields;

  @override
  State<SellerBusinessForm> createState() => SellerBusinessFormState();
}

class SellerBusinessFormState extends State<SellerBusinessForm> {
  final _businessNameController = TextEditingController();
  final _rucController = TextEditingController();
  final _legalRepController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _phoneController = widget.phoneController ?? TextEditingController();
    _applyInitialData(widget.initialData);
  }

  @override
  void didUpdateWidget(covariant SellerBusinessForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData != widget.initialData) {
      _applyInitialData(widget.initialData);
    }
  }

  void _applyInitialData(SellerBusinessFormData? data) {
    if (data == null) return;
    _businessNameController.text = data.businessName;
    _rucController.text = data.ruc;
    _legalRepController.text = data.legalRepresentativeName;
    _phoneController.text = data.phone;
    _addressController.text = data.address ?? '';
    _descriptionController.text = data.description ?? '';
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _rucController.dispose();
    _legalRepController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    if (widget.phoneController == null) {
      _phoneController.dispose();
    }
    super.dispose();
  }

  bool validate() => widget.formKey.currentState?.validate() ?? false;

  String get _contactHint {
    if (widget.includePhoneField && widget.includeAddressField) {
      return 'WhatsApp y dirección visibles para clientes interesados.';
    }
    if (widget.includePhoneField) {
      return 'Número de WhatsApp visible para clientes interesados.';
    }
    return 'Dirección visible para clientes interesados.';
  }

  SellerBusinessFormData buildData() {
    return SellerBusinessFormData(
      businessName: _businessNameController.text.trim(),
      ruc: _rucController.text.trim(),
      legalRepresentativeName: _legalRepController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim().isEmpty
          ? null
          : _addressController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthInfoTip(
            message: widget.lockIdentityFields
                ? 'RUC y representante legal no se pueden modificar tras el registro.'
                : 'Registra los datos tal como figuran en SUNAT. La verificación puede tardar 1–3 días hábiles.',
          ),
          const SizedBox(height: 16),
          AuthFormSection(
            title: 'Identidad del negocio',
            hint: 'Razón social y RUC de la empresa.',
            icon: Icons.apartment_outlined,
            child: Column(
              children: [
                AuthRoundedField(
                  controller: _businessNameController,
                  label: 'Razón social *',
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Mínimo 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _rucController,
                  label: 'RUC *',
                  keyboardType: TextInputType.number,
                  readOnly: widget.lockIdentityFields,
                  validator: (value) {
                    final trimmed = value?.trim() ?? '';
                    if (trimmed.length != 11) return 'El RUC debe tener 11 dígitos';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _legalRepController,
                  label: 'Representante legal *',
                  readOnly: widget.lockIdentityFields,
                  validator: (value) {
                    if (value == null || value.trim().length < 2) {
                      return 'Mínimo 2 caracteres';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          if (widget.includePhoneField || widget.includeAddressField) ...[
            const SizedBox(height: 16),
            AuthFormSection(
              title: 'Contacto comercial',
              hint: _contactHint,
              icon: Icons.chat_outlined,
              child: Column(
                children: [
                  if (widget.includePhoneField) ...[
                    AuthRoundedField(
                      controller: _phoneController,
                      label: 'Número de WhatsApp *',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        return null;
                      },
                    ),
                  ],
                  if (widget.includePhoneField && widget.includeAddressField)
                    const SizedBox(height: 14),
                  if (widget.includeAddressField)
                    AuthRoundedField(
                      controller: _addressController,
                      label: 'Dirección comercial',
                      maxLines: 2,
                    ),
                ],
              ),
            ),
          ],
          if (widget.includeDescriptionField) ...[
            const SizedBox(height: 16),
            AuthFormSection(
              title: 'Presentación',
              hint: 'Opcional. Ayuda a que los clientes conozcan tu negocio.',
              icon: Icons.description_outlined,
              child: AuthRoundedField(
                controller: _descriptionController,
                label: 'Descripción del negocio',
                maxLines: 3,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
