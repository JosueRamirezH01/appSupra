import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/auth/pending_password_reset_provider.dart';
import '../../widgets/auth/auth_register_flow.dart';
import '../../widgets/auth/auth_ui.dart';

/// Paso 3: definir la nueva contraseña tras validar el OTP.
class ForgotPasswordNewScreen extends ConsumerStatefulWidget {
  const ForgotPasswordNewScreen({super.key});

  @override
  ConsumerState<ForgotPasswordNewScreen> createState() =>
      _ForgotPasswordNewScreenState();
}

class _ForgotPasswordNewScreenState
    extends ConsumerState<ForgotPasswordNewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _submitting = false;
  /// Copia local: sobrevive al refresh del router al guardar.
  String? _email;
  String? _resetToken;

  @override
  void initState() {
    super.initState();
    final args = ref.read(pendingPasswordResetProvider);
    _email = args?.email;
    _resetToken = args?.resetToken;
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<bool> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Cancelar el cambio?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppBrandColors.textDark,
          ),
        ),
        content: Text(
          'Tendrás que verificar tu correo de nuevo para crear una nueva '
          'contraseña.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppBrandColors.textMuted,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: AppBrandColors.textMuted,
            ),
            child: Text(
              'Seguir aquí',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppBrandColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Salir',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  Future<void> _handleExit() async {
    final leave = await _confirmExit();
    if (!leave || !mounted) return;
    ref.read(pendingPasswordResetProvider.notifier).state = null;
    context.go(RoutePaths.forgotPassword);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final token = _resetToken;
    if (token == null || token.isEmpty) {
      context.go(RoutePaths.forgotPassword);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(authNotifierProvider.notifier).resetPassword(
            resetToken: token,
            password: _passwordController.text,
          );
      if (!mounted) return;

      ref.read(pendingPasswordResetProvider.notifier).state = null;

      // Sesión activa: el redirect del router manda al home sin pantallas intermedias.
      final state = ref.read(authNotifierProvider);
      state.whenOrNull(
        error: (e, _) => showErrorSnackBar(context, e),
      );
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        ref.watch(authNotifierProvider).isLoading || _submitting;

    if (_email == null || _resetToken == null) {
      return AuthFlowScaffold(
        title: 'Nueva contraseña',
        onBack: () => context.go(RoutePaths.forgotPassword),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthInfoTip(
              message:
                  'La verificación expiró o no está disponible. Vuelve a '
                  'solicitar el código.',
            ),
            const SizedBox(height: 20),
            AuthPrimaryButton(
              label: 'Volver',
              onPressed: () => context.go(RoutePaths.forgotPassword),
            ),
          ],
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleExit();
      },
      child: AuthFlowScaffold(
        title: 'Nueva contraseña',
        subtitle: 'Elige una contraseña segura para tu cuenta',
        onBack: _handleExit,
        compactLogo: true,
        showLogo: false,
        footer: AuthPrimaryButton(
          label: 'Guardar e iniciar sesión',
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
                    'Tu cuenta $_email quedará lista al guardar. '
                    'Entrarás automáticamente.',
              ),
              const SizedBox(height: 16),
              AuthFormSection(
                title: 'Contraseña',
                hint: 'Debe ser distinta y segura.',
                icon: Icons.lock_outline_rounded,
                child: Column(
                  children: [
                    AuthRoundedField(
                      controller: _passwordController,
                      label: 'Nueva contraseña *',
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: validateStrongPassword,
                    ),
                    const SizedBox(height: 12),
                    AuthPasswordHints(controller: _passwordController),
                    const SizedBox(height: 14),
                    AuthRoundedField(
                      controller: _confirmController,
                      label: 'Confirmar contraseña *',
                      obscureText: _obscureConfirm,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscureConfirm = !_obscureConfirm,
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
            ],
          ),
        ),
      ),
    );
  }
}
