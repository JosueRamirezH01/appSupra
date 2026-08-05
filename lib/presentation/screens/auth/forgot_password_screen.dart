import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_ui.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;
  /// Opción B: se envió respuesta genérica sin OTP (correo no elegible).
  bool _softNotice = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    if (_softNotice) setState(() => _softNotice = false);
  }

  @override
  void dispose() {
    _emailController.removeListener(_onEmailChanged);
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _softNotice = false;
    });

    try {
      final email = _emailController.text.trim();
      final info =
          await ref.read(authNotifierProvider.notifier).sendPasswordResetCode(email);
      if (!mounted) return;

      if (info.codeSent) {
        context.go(
          '${RoutePaths.forgotPasswordVerify}?email=${Uri.encodeComponent(email)}',
        );
        return;
      }

      // No elegible: nos quedamos aquí con mensaje suave (sin ir al OTP vacío).
      setState(() => _softNotice = true);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: 'Recuperar contraseña',
      subtitle: 'Te enviaremos un código si la cuenta usa email y contraseña',
      onBack: () => context.canPop()
          ? context.pop()
          : context.go(RoutePaths.login),
      compactLogo: true,
      showLogo: false,
      footer: AuthPrimaryButton(
        label: _softNotice ? 'Intentar de nuevo' : 'Enviar código',
        isLoading: _loading,
        onPressed: _submit,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_softNotice) ...[
              const _SoftNoticeCard(),
              const SizedBox(height: 20),
            ] else ...[
              const AuthInfoTip(
                message:
                    'Si hay una cuenta con ese correo y usa contraseña, te '
                    'enviaremos un código de 6 dígitos.',
              ),
              const SizedBox(height: 20),
            ],
            AuthFormSection(
              title: 'Tu correo',
              hint: 'El mismo con el que creaste la cuenta.',
              icon: Icons.mail_outline_rounded,
              child: AuthRoundedField(
                controller: _emailController,
                label: 'Correo electrónico',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Ingresa tu email';
                  if (!value.contains('@')) return 'Email inválido';
                  return null;
                },
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: AuthTextLink(
                label: 'Volver al inicio de sesión',
                onPressed: () => context.go(RoutePaths.login),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Aviso suave, minimalista: no revela si el correo existe.
class _SoftNoticeCard extends StatelessWidget {
  const _SoftNoticeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: AppBrandColors.primaryGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppBrandColors.primaryGreen.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.mark_email_read_outlined,
            size: 22,
            color: AppBrandColors.primaryGreen.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Revisa tu bandeja',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Si hay una cuenta con ese correo y usa contraseña, te '
                  'enviamos un código. Mira también la carpeta de spam.',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    height: 1.45,
                    color: AppBrandColors.textMuted,
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
