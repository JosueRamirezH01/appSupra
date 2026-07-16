import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_register_flow.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/sellers/seller_business_form.dart';

class RegisterSellerScreen extends ConsumerStatefulWidget {
  const RegisterSellerScreen({super.key});

  @override
  ConsumerState<RegisterSellerScreen> createState() =>
      _RegisterSellerScreenState();
}

class _RegisterSellerScreenState extends ConsumerState<RegisterSellerScreen> {
  static const _copy = RegisterFlowCopy.seller;

  final _accountFormKey = GlobalKey<FormState>();
  final _businessFormKey = GlobalKey<FormState>();
  final _businessFormStateKey = GlobalKey<SellerBusinessFormState>();

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

    final businessForm = _businessFormStateKey.currentState!;
    if (!businessForm.validate()) return;

    final data = businessForm.buildData();
    setState(() => _submitting = true);

    try {
      await ref.read(authNotifierProvider.notifier).registerSeller(
            RegisterSellerRequest(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              phone: data.phone,
              businessName: data.businessName,
              ruc: data.ruc,
              legalRepresentativeName: data.legalRepresentativeName,
              description: data.description,
            ),
          );

      if (!mounted) return;
      final state = ref.read(authNotifierProvider);
      state.whenOrNull(
        error: (e, _) => showErrorSnackBar(context, e),
        data: (user) {
          if (user != null) {
            ref.read(activeAppViewProvider.notifier).preferSeller();
            context.go(RoutePaths.sellerOnboarding);
          }
        },
      );
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
            hint: 'Persona de contacto del negocio.',
            icon: Icons.lock_outline_rounded,
            child: Column(
              children: [
                AuthRoundedField(
                  controller: _nameController,
                  label: 'Nombre de contacto *',
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
        const SizedBox(height: 16),
        SellerBusinessForm(
          key: _businessFormStateKey,
          formKey: _businessFormKey,
          phoneController: _phoneController,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading || _submitting;

    return AuthFlowScaffold(
      title: _step == 0 ? 'Crea tu cuenta' : 'Registra tu negocio',
      subtitle: _step == 0
          ? 'Información para iniciar sesión'
          : 'Datos comerciales con RUC',
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
