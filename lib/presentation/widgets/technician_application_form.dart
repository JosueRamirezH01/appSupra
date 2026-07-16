import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/service_constants.dart';
import '../../data/models/categories/category_model.dart';
import '../providers/categories/categories_notifier.dart';
import 'auth/auth_ui.dart';
import 'sub_sub_category_multi_picker.dart';
import 'subcategory_multi_picker.dart';

class TechnicianApplicationData {
  const TechnicianApplicationData({
    required this.subcategoryIds,
    required this.subcategoryNames,
    required this.subSubCategoryIds,
    required this.documentNumber,
    required this.profileType,
    this.ruc,
    this.businessName,
    this.legalRepresentativeName,
    this.phone,
    this.documentType = 'DNI',
  });

  final List<int> subcategoryIds;
  final List<String> subcategoryNames;
  final List<int> subSubCategoryIds;
  final String documentType;
  final String documentNumber;
  final String profileType;
  final String? ruc;
  final String? businessName;
  final String? legalRepresentativeName;
  final String? phone;

  String get specialty => subcategoryNames.join(', ');
}

class TechnicianApplicationForm extends ConsumerStatefulWidget {
  const TechnicianApplicationForm({
    super.key,
    required this.formKey,
    this.phoneController,
    this.showPhoneField = false,
    this.isRegistration = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController? phoneController;
  final bool showPhoneField;
  /// Límites de teléfono (9) y DNI (8) solo en flujos de registro.
  final bool isRegistration;

  @override
  ConsumerState<TechnicianApplicationForm> createState() =>
      TechnicianApplicationFormState();
}

class TechnicianApplicationFormState
    extends ConsumerState<TechnicianApplicationForm> {
  final _documentNumberController = TextEditingController();
  final _rucController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _legalRepresentativeNameController = TextEditingController();

  final _specialtiesSectionKey = GlobalKey();
  final _servicesSectionKey = GlobalKey();
  final _profileSectionKey = GlobalKey();
  final _documentSectionKey = GlobalKey();

  final List<SubcategoryModel> _selectedSubcategories = [];
  final Map<int, SubSubCategoryModel> _selectedSubSubById = {};
  String _documentType = 'DNI';
  String? _profileType;
  String? _catalogValidationMessage;
  bool _showValidationHints = false;

  @override
  void initState() {
    super.initState();
    _documentNumberController.addListener(_refreshProgress);
    widget.phoneController?.addListener(_refreshProgress);
  }

  void _refreshProgress() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _documentNumberController.removeListener(_refreshProgress);
    widget.phoneController?.removeListener(_refreshProgress);
    _documentNumberController.dispose();
    _rucController.dispose();
    _businessNameController.dispose();
    _legalRepresentativeNameController.dispose();
    super.dispose();
  }

  Set<int> get _selectedSubSubIds => _selectedSubSubById.keys.toSet();

  int _serviceCountFor(int subcategoryId) => _selectedSubSubById.values
      .where((item) => item.subcategoryId == subcategoryId)
      .length;

  bool get _specialtiesComplete =>
      _selectedSubcategories.length >=
          ServiceConstants.minRegistrationSpecialties &&
      _selectedSubcategories.length <=
          ServiceConstants.maxRegistrationSpecialties;

  bool get _servicesComplete {
    if (!_specialtiesComplete) return false;
    for (final subcategory in _selectedSubcategories) {
      final count = _serviceCountFor(subcategory.id);
      if (count < ServiceConstants.minServicesPerSpecialty ||
          count > ServiceConstants.maxServicesPerSpecialty) {
        return false;
      }
    }
    return true;
  }

  bool get _profileTypeSelected => _profileType != null;

  bool get _documentComplete {
    final value = _documentNumberController.text.trim();
    if (widget.isRegistration && _documentType == 'DNI') {
      return value.length == 8;
    }
    return value.length >= 8;
  }

  bool get _phoneComplete {
    final length = widget.phoneController?.text.trim().length ?? 0;
    if (widget.isRegistration) return length == 9;
    return length >= 6;
  }

  int get completedRequirements {
    var count = 0;
    if (_specialtiesComplete) count++;
    if (_servicesComplete) count++;
    if (_profileTypeSelected) count++;
    if (_documentComplete) count++;
    return count;
  }

  bool validate() {
    setState(() => _showValidationHints = true);
    final formValid = widget.formKey.currentState?.validate() ?? false;
    final catalogValid = _validateCatalogSelection();
    if (!formValid || !catalogValid) {
      setState(() {});
      _scrollToFirstIncomplete();
    }
    return formValid && catalogValid;
  }

  void _scrollToFirstIncomplete() {
    final targets = <GlobalKey>[
      if (!_specialtiesComplete) _specialtiesSectionKey,
      if (!_servicesComplete) _servicesSectionKey,
      if (!_profileTypeSelected) _profileSectionKey,
      if (!_documentComplete) _documentSectionKey,
    ];

    if (targets.isEmpty) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = targets.first.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    });
  }

  bool _validateCatalogSelection() {
    final subCount = _selectedSubcategories.length;
    if (subCount < ServiceConstants.minRegistrationSpecialties) {
      _catalogValidationMessage = 'Selecciona al menos una especialidad';
      return false;
    }
    if (subCount > ServiceConstants.maxRegistrationSpecialties) {
      _catalogValidationMessage =
          'Máximo ${ServiceConstants.maxRegistrationSpecialties} especialidades';
      return false;
    }

    for (final subcategory in _selectedSubcategories) {
      final count = _serviceCountFor(subcategory.id);

      if (count < ServiceConstants.minServicesPerSpecialty) {
        _catalogValidationMessage =
            'En ${subcategory.name} falta al menos un servicio';
        return false;
      }

      if (count > ServiceConstants.maxServicesPerSpecialty) {
        _catalogValidationMessage =
            'Máximo ${ServiceConstants.maxServicesPerSpecialty} servicios en ${subcategory.name}';
        return false;
      }
    }

    _catalogValidationMessage = null;
    return true;
  }

  TechnicianApplicationData buildData() {
    return TechnicianApplicationData(
      subcategoryIds: _selectedSubcategories.map((item) => item.id).toList(),
      subcategoryNames:
          _selectedSubcategories.map((item) => item.name).toList(),
      subSubCategoryIds: _selectedSubSubIds.toList(),
      documentType: _documentType,
      documentNumber: _documentNumberController.text.trim(),
      profileType: _profileType!,
      ruc: _profileType == 'empresa' ? _rucController.text.trim() : null,
      businessName:
          _profileType == 'empresa' ? _businessNameController.text.trim() : null,
      legalRepresentativeName: _profileType == 'empresa'
          ? _legalRepresentativeNameController.text.trim()
          : null,
      phone: widget.phoneController?.text.trim().isEmpty ?? true
          ? null
          : widget.phoneController!.text.trim(),
    );
  }

  Future<void> _openSubcategoryPicker(List<SubcategoryModel> subcategories) async {
    final picked = await showSubcategoryMultiPicker(
      context,
      subcategories: subcategories,
      selectedIds: _selectedSubcategories.map((item) => item.id).toSet(),
    );

    if (!mounted || picked == null) return;

    final keptSubcategoryIds = picked.map((item) => item.id).toSet();
    final hadServices = _selectedSubSubById.isNotEmpty;

    setState(() {
      _selectedSubcategories
        ..clear()
        ..addAll(picked);
      _selectedSubSubById.removeWhere(
        (_, subSub) => !keptSubcategoryIds.contains(subSub.subcategoryId),
      );
      _catalogValidationMessage = null;
    });
    widget.formKey.currentState?.validate();

    if (!hadServices && picked.isNotEmpty && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _scrollToSection(_servicesSectionKey);
      });
    }
  }

  Future<void> _openSubSubPicker({SubcategoryModel? onlySubcategory}) async {
    final targets =
        onlySubcategory != null ? [onlySubcategory] : _selectedSubcategories;
    if (targets.isEmpty) return;

    final catalog = <int, List<SubSubCategoryModel>>{};
    for (final subcategory in targets) {
      final items = await ref.read(
        subSubCategoriesListProvider(subcategory.id).future,
      );
      catalog[subcategory.id] = items;
    }

    if (!mounted) return;

    final picked = await showSubSubCategoryMultiPicker(
      context,
      subcategories: targets,
      catalogBySubcategory: catalog,
      selectedIds: _selectedSubSubIds,
    );

    if (!mounted || picked == null) return;

    setState(() {
      if (onlySubcategory != null) {
        _selectedSubSubById.removeWhere(
          (_, item) => item.subcategoryId == onlySubcategory.id,
        );
        for (final item in picked) {
          _selectedSubSubById[item.id] = item;
        }
      } else {
        _selectedSubSubById
          ..clear()
          ..addEntries(picked.map((item) => MapEntry(item.id, item)));
      }
      _catalogValidationMessage = null;
    });
    widget.formKey.currentState?.validate();
  }

  void _scrollToSection(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        alignment: 0.08,
      );
    });
  }

  void _removeSubSub(int subSubId) {
    setState(() {
      _selectedSubSubById.remove(subSubId);
      _catalogValidationMessage = null;
    });
  }

  void _removeSubcategoryAndClean(int subcategoryId) {
    setState(() {
      _selectedSubcategories.removeWhere((item) => item.id == subcategoryId);
      _selectedSubSubById.removeWhere(
        (_, subSub) => subSub.subcategoryId == subcategoryId,
      );
      _catalogValidationMessage = null;
    });
  }

  List<SubSubCategoryModel> _servicesForSubcategory(int subcategoryId) =>
      _selectedSubSubById.values
          .where((item) => item.subcategoryId == subcategoryId)
          .toList();

  @override
  Widget build(BuildContext context) {
    final subcategoriesAsync = ref.watch(professionSubcategoriesProvider);
    final totalRequirements = 4 + (widget.showPhoneField ? 1 : 0);
    var doneRequirements = completedRequirements;
    if (widget.showPhoneField && _phoneComplete) {
      doneRequirements++;
    }

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TechnicianRegistrationProgress(
            done: doneRequirements,
            total: totalRequirements,
            specialtiesComplete: _specialtiesComplete,
            servicesComplete: _servicesComplete,
            profileComplete: _profileTypeSelected,
            documentComplete: _documentComplete,
            phoneComplete: !widget.showPhoneField || _phoneComplete,
            showPhone: widget.showPhoneField,
          ),
          const SizedBox(height: 16),
          if (widget.showPhoneField && widget.phoneController != null) ...[
            AuthFormSection(
              title: 'Contacto',
              icon: Icons.call_outlined,
              child: AuthRoundedField(
                controller: widget.phoneController!,
                label: 'Teléfono *',
                keyboardType: TextInputType.phone,
                maxLength: widget.isRegistration ? 9 : null,
                validator: (value) {
                  final phone = value?.trim() ?? '';
                  if (widget.isRegistration) {
                    if (phone.length != 9) {
                      return 'Debe tener 9 dígitos';
                    }
                    return null;
                  }
                  if (phone.length < 6) {
                    return 'Mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          KeyedSubtree(
            key: _specialtiesSectionKey,
            child: AuthFormSection(
              title: 'Paso 1 · Especialidades',
              hint:
                  'Elige de ${ServiceConstants.minRegistrationSpecialties} a ${ServiceConstants.maxRegistrationSpecialties} rubros en los que trabajas.',
              icon: Icons.handyman_outlined,
              child: subcategoriesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(
                    color: AppBrandColors.primaryGreen,
                  ),
                ),
                error: (e, _) => AuthInfoTip(
                  message: 'No se pudieron cargar las especialidades. Reintenta.',
                  icon: Icons.error_outline_rounded,
                ),
                data: (subs) {
                  if (subs.isEmpty) {
                    return const AuthInfoTip(
                      message: 'No hay especialidades disponibles por ahora.',
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SelectionTriggerCard(
                        label: 'Especialidades',
                        placeholder: 'Toca para buscar y elegir',
                        summary: _selectedSubcategories.isEmpty
                            ? null
                            : '${_selectedSubcategories.length}/${ServiceConstants.maxRegistrationSpecialties} elegidas',
                        icon: Icons.add_circle_outline,
                        isComplete: _specialtiesComplete,
                        showError: _showValidationHints &&
                            !_specialtiesComplete,
                        errorText: _catalogValidationMessage != null &&
                                _selectedSubcategories.isEmpty
                            ? _catalogValidationMessage
                            : 'Selecciona al menos una especialidad',
                        onTap: () => _openSubcategoryPicker(subs),
                      ),
                      if (_selectedSubcategories.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _selectedSubcategories.map((item) {
                            return InputChip(
                              label: Text(item.name),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () =>
                                  _removeSubcategoryAndClean(item.id),
                              backgroundColor: AppBrandColors.primaryGreen
                                  .withValues(alpha: 0.1),
                              labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          if (_selectedSubcategories.isNotEmpty) ...[
            const SizedBox(height: 16),
            KeyedSubtree(
              key: _servicesSectionKey,
              child: AuthFormSection(
                title: 'Paso 2 · Servicios por especialidad',
                hint:
                    'En cada rubro elige de ${ServiceConstants.minServicesPerSpecialty} a ${ServiceConstants.maxServicesPerSpecialty} servicios concretos.',
                icon: Icons.design_services_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!_servicesComplete)
                      AuthInfoTip(
                        message: _catalogValidationMessage ??
                            'Completa los servicios de cada especialidad. Toca cada tarjeta para elegirlos.',
                        icon: Icons.lightbulb_outline_rounded,
                      ),
                    if (!_servicesComplete) const SizedBox(height: 12),
                    for (final subcategory in _selectedSubcategories) ...[
                      _SpecialtyServicesCard(
                        subcategory: subcategory,
                        selectedServices: _servicesForSubcategory(subcategory.id),
                        showValidation: _showValidationHints,
                        onPick: () => _openSubSubPicker(onlySubcategory: subcategory),
                        onRemoveService: _removeSubSub,
                      ),
                      const SizedBox(height: 10),
                    ],
                    if (_selectedSubcategories.length > 1)
                      TextButton.icon(
                        onPressed: () => _openSubSubPicker(),
                        icon: const Icon(Icons.tune_rounded, size: 18),
                        label: Text(
                          'Editar todos los servicios (${_selectedSubSubIds.length}/${ServiceConstants.maxTotalServicesForSpecialtyCount(_selectedSubcategories.length)})',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 16),
          KeyedSubtree(
            key: _profileSectionKey,
            child: AuthFormSection(
              title: 'Paso 3 · Tipo de perfil',
              hint: '¿Trabajas por tu cuenta o representas una empresa?',
              icon: Icons.badge_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ProfileTypeOption(
                          title: 'Independiente',
                          subtitle: 'Persona natural',
                          icon: Icons.person_outline_rounded,
                          selected: _profileType == 'independiente',
                          showError: _showValidationHints &&
                              _profileType == null,
                          onTap: () {
                            setState(() {
                              _profileType = 'independiente';
                              _rucController.clear();
                              _businessNameController.clear();
                              _legalRepresentativeNameController.clear();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ProfileTypeOption(
                          title: 'Empresa',
                          subtitle: 'Con RUC activo',
                          icon: Icons.business_outlined,
                          selected: _profileType == 'empresa',
                          showError: _showValidationHints &&
                              _profileType == null,
                          onTap: () =>
                              setState(() => _profileType = 'empresa'),
                        ),
                      ),
                    ],
                  ),
                  if (_showValidationHints && _profileType == null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Selecciona cómo vas a registrarte',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                  if (_profileType == 'empresa') ...[
                    const SizedBox(height: 14),
                    AuthRoundedField(
                      controller: _businessNameController,
                      label: 'Razón social *',
                      validator: (value) {
                        if (_profileType != 'empresa') return null;
                        if (value == null || value.trim().length < 2) {
                          return 'Mínimo 2 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    AuthRoundedField(
                      controller: _legalRepresentativeNameController,
                      label: 'Representante legal *',
                      validator: (value) {
                        if (_profileType != 'empresa') return null;
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
                      validator: (value) {
                        if (_profileType != 'empresa') return null;
                        if (value == null ||
                            !RegExp(r'^\d{11}$').hasMatch(value.trim())) {
                          return 'El RUC debe tener 11 dígitos';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          KeyedSubtree(
            key: _documentSectionKey,
            child: AuthFormSection(
              title: 'Paso 4 · Documento de identidad',
              hint: 'Debe coincidir con el documento que enviarás al subir fotos en el siguiente paso.',
              icon: Icons.verified_user_outlined,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _documentType,
                    decoration: authDropdownDecoration('Tipo de documento'),
                    items: const [
                      DropdownMenuItem(value: 'DNI', child: Text('DNI')),
                      DropdownMenuItem(value: 'CE', child: Text('CE')),
                      DropdownMenuItem(
                        value: 'PASAPORTE',
                        child: Text('Pasaporte'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        _documentType = value;
                        if (widget.isRegistration && value == 'DNI') {
                          final text = _documentNumberController.text;
                          if (text.length > 8) {
                            _documentNumberController.text = text.substring(0, 8);
                          }
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 14),
                  AuthRoundedField(
                    controller: _documentNumberController,
                    label: 'Número de documento *',
                    keyboardType: _documentType == 'DNI'
                        ? TextInputType.number
                        : TextInputType.text,
                    maxLength:
                        widget.isRegistration && _documentType == 'DNI' ? 8 : null,
                    validator: (v) {
                      final doc = v?.trim() ?? '';
                      if (widget.isRegistration && _documentType == 'DNI') {
                        if (doc.length != 8) {
                          return 'El DNI debe tener 8 dígitos';
                        }
                        return null;
                      }
                      if (doc.length < 8) {
                        return 'Mínimo 8 caracteres';
                      }
                      return null;
                    },
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

class _TechnicianRegistrationProgress extends StatelessWidget {
  const _TechnicianRegistrationProgress({
    required this.done,
    required this.total,
    required this.specialtiesComplete,
    required this.servicesComplete,
    required this.profileComplete,
    required this.documentComplete,
    required this.phoneComplete,
    required this.showPhone,
  });

  final int done;
  final int total;
  final bool specialtiesComplete;
  final bool servicesComplete;
  final bool profileComplete;
  final bool documentComplete;
  final bool phoneComplete;
  final bool showPhone;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Requisitos del registro',
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$done/$total',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : done / total,
              minHeight: 6,
              backgroundColor: AppBrandColors.fieldFill,
              color: AppBrandColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          _ProgressRow(
            label: 'Especialidades',
            done: specialtiesComplete,
          ),
          _ProgressRow(label: 'Servicios', done: servicesComplete),
          _ProgressRow(label: 'Tipo de perfil', done: profileComplete),
          _ProgressRow(label: 'Documento', done: documentComplete),
          if (showPhone)
            _ProgressRow(label: 'Teléfono', done: phoneComplete),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 16,
            color: done
                ? AppBrandColors.primaryGreen
                : AppBrandColors.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                color: done ? AppBrandColors.textDark : AppBrandColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionTriggerCard extends StatelessWidget {
  const _SelectionTriggerCard({
    required this.label,
    required this.placeholder,
    required this.onTap,
    this.summary,
    this.icon,
    this.isComplete = false,
    this.showError = false,
    this.errorText,
  });

  final String label;
  final String placeholder;
  final String? summary;
  final IconData? icon;
  final bool isComplete;
  final bool showError;
  final String? errorText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = showError
        ? Colors.red.shade300
        : isComplete
            ? AppBrandColors.primaryGreen.withValues(alpha: 0.45)
            : const Color(0xFFE5E7EB);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: showError ? 1.5 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      summary ?? placeholder,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight:
                            summary != null ? FontWeight.w600 : FontWeight.w400,
                        color: summary != null
                            ? AppBrandColors.textDark
                            : AppBrandColors.textMuted,
                      ),
                    ),
                    if (showError && errorText != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        errorText!,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isComplete)
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppBrandColors.primaryGreen,
                  size: 22,
                )
              else if (icon != null)
                Icon(icon, color: AppBrandColors.primaryGreen),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecialtyServicesCard extends StatelessWidget {
  const _SpecialtyServicesCard({
    required this.subcategory,
    required this.selectedServices,
    required this.onPick,
    required this.onRemoveService,
    this.showValidation = false,
  });

  final SubcategoryModel subcategory;
  final List<SubSubCategoryModel> selectedServices;
  final VoidCallback onPick;
  final void Function(int subSubId) onRemoveService;
  final bool showValidation;

  @override
  Widget build(BuildContext context) {
    final count = selectedServices.length;
    final min = ServiceConstants.minServicesPerSpecialty;
    final max = ServiceConstants.maxServicesPerSpecialty;
    final isComplete = count >= min && count <= max;
    final needsMore = count < min;

    final statusLabel = needsMore
        ? 'Falta al menos $min servicio'
        : isComplete
            ? 'Completo'
            : '$count de $max';

    final statusColor = needsMore
        ? const Color(0xFFD97706)
        : AppBrandColors.primaryGreen;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: showValidation && needsMore
              ? Colors.red.shade300
              : isComplete
                  ? AppBrandColors.primaryGreen.withValues(alpha: 0.35)
                  : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  subcategory.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$count/$max · $statusLabel',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: (count / max).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: AppBrandColors.fieldFill,
              color: statusColor,
            ),
          ),
          if (selectedServices.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: selectedServices.map((item) {
                return InputChip(
                  label: Text(item.name),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => onRemoveService(item.id),
                  backgroundColor:
                      AppBrandColors.primaryGreen.withValues(alpha: 0.08),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: onPick,
            icon: Icon(
              selectedServices.isEmpty
                  ? Icons.add_rounded
                  : Icons.edit_outlined,
              size: 18,
            ),
            label: Text(
              selectedServices.isEmpty
                  ? 'Elegir servicios'
                  : 'Editar servicios',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppBrandColors.primaryGreen,
              side: BorderSide(
                color: AppBrandColors.primaryGreen.withValues(alpha: 0.45),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTypeOption extends StatelessWidget {
  const _ProfileTypeOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
    this.showError = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final bool showError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? AppBrandColors.primaryGreen
        : showError
            ? Colors.red.shade300
            : const Color(0xFFE5E7EB);

    return Material(
      color: selected
          ? AppBrandColors.primaryGreen.withValues(alpha: 0.06)
          : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: selected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: selected
                    ? AppBrandColors.primaryGreen
                    : AppBrandColors.textMuted,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? validateStrongPassword(String? value) {
  if (value == null || value.length < 8) {
    return 'Mínimo 8 caracteres';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Incluye al menos una mayúscula';
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'Incluye al menos una minúscula';
  }
  if (!RegExp(r'\d').hasMatch(value)) {
    return 'Incluye al menos un número';
  }
  return null;
}
