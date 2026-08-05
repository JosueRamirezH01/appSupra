import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/error_utils.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_register_flow.dart';
import '../../widgets/auth/auth_ui.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final email = _emailController.text.trim();
      await ref.read(authNotifierProvider.notifier).beginRegistration(
        role: 'cliente',
        email: email,
        payload: {
          'email': email,
          'password': _passwordController.text,
        },
      );

      if (!mounted) return;
      context.push(RoutePaths.registerVerify);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading || _submitting;

    return AuthFlowScaffold(
      title: 'Crear cuenta',
      subtitle: 'Regístrate en segundos y explora técnicos y productos.',
      onBack: () => context.pop(),
      footer: AuthPrimaryButton(
        label: 'Crear cuenta',
        isLoading: isLoading,
        onPressed: _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthInfoTip(
              message:
                  'Solo necesitas email y contraseña. Completa tu nombre, celular y foto cuando quieras desde tu perfil.',
            ),
            const SizedBox(height: 16),
            AuthFormSection(
              title: 'Datos de acceso',
              hint: 'Usarás estos datos para iniciar sesión.',
              icon: Icons.person_outline_rounded,
              child: Column(
                children: [
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
                  const SizedBox(height: 14),
                  AuthRoundedField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar contraseña *',
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                    ),
                    validator: (value) => validatePasswordConfirmation(
                      value,
                      password: _passwordController.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: AuthTextLink(
                label: '¿Ya tienes cuenta? Ingresar',
                onPressed: () => context.push(RoutePaths.login),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
