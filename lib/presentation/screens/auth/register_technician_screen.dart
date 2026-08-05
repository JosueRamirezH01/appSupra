import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_register_flow.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/technician_application_form.dart' hide validateStrongPassword;

class RegisterTechnicianScreen extends ConsumerStatefulWidget {
  const RegisterTechnicianScreen({super.key});

  @override
  ConsumerState<RegisterTechnicianScreen> createState() =>
      _RegisterTechnicianScreenState();
}

class _RegisterTechnicianScreenState
    extends ConsumerState<RegisterTechnicianScreen> {
  static const _copy = RegisterFlowCopy.technician;

  final _accountFormKey = GlobalKey<FormState>();
  final _technicianFormKey = GlobalKey<FormState>();
  final _technicianFormStateKey = GlobalKey<TechnicianApplicationFormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  int _step = 0;
  bool _submitting = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _nextStep() async {
    if (_step == 0) {
      if (!_accountFormKey.currentState!.validate()) return;
      setState(() => _step = 1);
      return;
    }

    final technicianForm = _technicianFormStateKey.currentState!;
    if (!technicianForm.validate()) return;

    final data = technicianForm.buildData();
    if (data.subcategoryIds.isEmpty) {
      showErrorSnackBar(context, 'Selecciona al menos una especialidad');
      return;
    }
    if (data.subSubCategoryIds.isEmpty) {
      showErrorSnackBar(context, 'Selecciona al menos un servicio');
      return;
    }

    setState(() => _submitting = true);

    try {
      // La foto de perfil ya no se pide aquí: se agrega después de crear la
      // cuenta (evita subir archivos antes de que exista el usuario).
      final request = RegisterTechnicianRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        specialty: data.specialty,
        profileType: data.profileType,
        ruc: data.ruc,
        businessName: data.businessName,
        legalRepresentativeName: data.legalRepresentativeName,
        subcategoryIds: data.subcategoryIds,
        subSubCategoryIds: data.subSubCategoryIds,
        documentType: data.documentType,
        documentNumber: data.documentNumber,
      );

      await ref.read(authNotifierProvider.notifier).beginRegistration(
            role: 'tecnico',
            email: request.email,
            payload: request.toJson(),
          );

      if (!mounted) return;
      context.push(RoutePaths.registerVerify);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  void _previousStep() {
    if (_step == 0) {
      context.pop();
      return;
    }
    setState(() => _step = 0);
  }

  Widget _buildStepOne() {
    return Form(
      key: _accountFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthInfoTip(message: _copy.accountTip),
          const SizedBox(height: 16),
          AuthFormSection(
            title: 'Datos de acceso',
            hint: 'Usarás estos datos para iniciar sesión.',
            icon: Icons.lock_outline_rounded,
            child: Column(
              children: [
                AuthRoundedField(
                  controller: _nameController,
                  label: 'Nombre completo *',
                  validator: (v) => v == null || v.trim().length < 2
                      ? 'Mínimo 2 caracteres'
                      : null,
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _emailController,
                  label: 'Correo electrónico *',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || !v.contains('@') ? 'Email inválido' : null,
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _phoneController,
                  label: 'Teléfono *',
                  maxLength: 9,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    final phone = value?.trim() ?? '';
                    if (phone.length != 9) {
                      return 'Debe tener 9 dígitos';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _passwordController,
                  label: 'Contraseña *',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: validateStrongPassword,
                ),
                const SizedBox(height: 12),
                AuthPasswordHints(controller: _passwordController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthInfoTip(message: _copy.profileTip),
        const SizedBox(height: 8),

        TechnicianApplicationForm(
          key: _technicianFormStateKey,
          formKey: _technicianFormKey,
          isRegistration: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading || _submitting;

    return AuthFlowScaffold(
      title: _step == 0 ? 'Crea tu cuenta' : 'Completa tu perfil',
      subtitle: _step == 0
          ? 'Información para iniciar sesión'
          : 'Datos profesionales y verificación',
      onBack: _previousStep,
      compactLogo: true,
      showLogo: false,
      footer: AuthRegisterFlowFooter(
        isFirstStep: _step == 0,
        isLoading: isLoading,
        primaryLabel: _step == 0 ? 'Continuar' : _copy.submitLabel,
        onPrimary: _nextStep,
        onBack: _previousStep,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthRegisterFlowHeader(copy: _copy, currentStep: _step),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            transitionBuilder: (child, animation) {
              final offset = Tween<Offset>(
                begin: const Offset(0.04, 0),
                end: Offset.zero,
              ).animate(animation);
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(position: offset, child: child),
              );
            },
            child: KeyedSubtree(
              key: ValueKey<int>(_step),
              child: _step == 0 ? _buildStepOne() : _buildStepTwo(),
            ),
          ),
        ],
      ),
    );
  }
}
