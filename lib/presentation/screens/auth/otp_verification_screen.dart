import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/auth/password_reset_models.dart';
import '../../../data/models/auth/registration_code_info.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/auth/pending_password_reset_provider.dart';
import '../../widgets/auth/auth_ui.dart';

enum OtpPurpose {
  registration,
  passwordReset,
}

/// Pantalla OTP reutilizable (registro y recuperación de contraseña).
class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.purpose,
    this.email,
  });

  final OtpPurpose purpose;
  final String? email;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _codeController = TextEditingController();

  Timer? _cooldownTimer;
  int _cooldown = 0;
  bool _submitting = false;
  bool _resending = false;
  bool _loading = true;
  String? _email;
  String? _role;

  bool get _isRegistration => widget.purpose == OtpPurpose.registration;

  String get _subtitle => _isRegistration
      ? 'Ingresa el código para crear tu cuenta'
      : 'Ingresa el código para continuar';

  String get _primaryLabel =>
      _isRegistration ? 'Verificar y crear cuenta' : 'Continuar';

  String get _exitMessage => _isRegistration
      ? 'Si sales ahora tendrás que empezar tu registro de nuevo y pedir un '
          'código nuevo.'
      : 'Si sales ahora tendrás que pedir un código nuevo para restablecer '
          'tu contraseña.';

  String get _missingMessage => _isRegistration
      ? 'No encontramos un registro en curso. Vuelve a empezar tu registro.'
      : 'No encontramos el correo. Vuelve a pedirlo.';

  String get _missingBackLabel =>
      _isRegistration ? 'Volver al registro' : 'Volver';

  String get _missingBackRoute =>
      _isRegistration ? RoutePaths.register : RoutePaths.forgotPassword;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (_isRegistration) {
      final pending =
          await ref.read(authNotifierProvider.notifier).readPendingRegistration();
      if (!mounted) return;
      setState(() {
        _email = pending?.email;
        _role = pending?.role;
        _loading = false;
      });
      if (pending != null) _startCooldown(60);
      return;
    }

    setState(() {
      _email = widget.email?.trim().isNotEmpty == true ? widget.email!.trim() : null;
      _loading = false;
    });
    if (_email != null) _startCooldown(60);
  }

  void _startCooldown(int seconds) {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = seconds);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_cooldown <= 1) {
          _cooldown = 0;
          timer.cancel();
        } else {
          _cooldown -= 1;
        }
      });
    });
  }

  Future<bool> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Salir de la verificación?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppBrandColors.textDark,
          ),
        ),
        content: Text(
          _exitMessage,
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

    if (_isRegistration) {
      await ref.read(authNotifierProvider.notifier).cancelRegistration();
      if (!mounted) return;
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(RoutePaths.register);
      }
      return;
    }

    context.go(RoutePaths.forgotPassword);
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length != 6) {
      showErrorSnackBar(context, 'Ingresa el código de 6 dígitos');
      return;
    }

    setState(() => _submitting = true);
    try {
      if (_isRegistration) {
        await ref.read(authNotifierProvider.notifier).confirmRegistration(code);
        if (!mounted) return;
        final state = ref.read(authNotifierProvider);
        state.whenOrNull(
          error: (e, _) => showErrorSnackBar(context, e),
          data: (user) {
            if (user != null) _navigateByRole(_role ?? 'cliente');
          },
        );
        return;
      }

      final result = await ref.read(authNotifierProvider.notifier).verifyPasswordResetCode(email: _email!, code: code);
      if (!mounted) return;
      ref.read(pendingPasswordResetProvider.notifier).state =
          PasswordResetNewArgs(
        email: _email!,
        resetToken: result.resetToken,
      );
      context.go(RoutePaths.forgotPasswordNew);
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resend() async {
    if (_cooldown > 0 || _resending || _email == null) return;
    setState(() => _resending = true);
    try {
      final RegistrationCodeInfo info = _isRegistration
          ? await ref.read(authNotifierProvider.notifier).resendRegistrationCode()
          : await ref.read(authNotifierProvider.notifier).resendPasswordResetCode(_email!);
      if (!mounted) return;
      _startCooldown(info.resendAvailableInSeconds);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Te reenviamos un nuevo código',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _navigateByRole(String role) {
    switch (role) {
      case 'tecnico':
        context.go('${RoutePaths.technicianActivateLocation}?source=register');
      case 'vendedor':
        ref.read(activeAppViewProvider.notifier).preferSeller();
        context.go(RoutePaths.sellerOnboarding);
      default:
        context.go(RoutePaths.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = (_isRegistration && ref.watch(authNotifierProvider).isLoading) || _submitting;

    if (_loading) {
      return const AuthFlowScaffold(
        title: 'Verifica tu correo',
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_email == null) {
      return AuthFlowScaffold(
        title: 'Verifica tu correo',
        onBack: () => context.go(_missingBackRoute),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthInfoTip(message: _missingMessage),
            const SizedBox(height: 20),
            AuthPrimaryButton(
              label: _missingBackLabel,
              onPressed: () => context.go(_missingBackRoute),
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
        title: 'Verifica tu correo',
        subtitle: _subtitle,
        onBack: _handleExit,
        compactLogo: true,
        showLogo: false,
        footer: AuthPrimaryButton(
          label: _primaryLabel,
          isLoading: isLoading,
          onPressed: _verify,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _EmailBadge(email: _email!),
            const SizedBox(height: 16),
            const AuthInfoTip(
              message:
                  'Te enviamos un código de 6 dígitos. Revisa tu bandeja de entrada '
                  'y también la carpeta de spam.',
            ),
            const SizedBox(height: 20),
            _CodeField(
              controller: _codeController,
              onSubmitted: (_) => _verify(),
            ),
            const SizedBox(height: 16),
            _ResendRow(
              cooldown: _cooldown,
              resending: _resending,
              onResend: _resend,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailBadge extends StatelessWidget {
  const _EmailBadge({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.mark_email_unread_outlined,
            color: AppBrandColors.primaryGreen,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enviamos el código a',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppBrandColors.textMuted,
                  ),
                ),
                Text(
                  email,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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

class _CodeField extends StatelessWidget {
  const _CodeField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 6,
      autofocus: true,
      onSubmitted: onSubmitted,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: GoogleFonts.poppins(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: 14,
        color: AppBrandColors.textDark,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: '••••••',
        hintStyle: GoogleFonts.poppins(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: 14,
          color: AppBrandColors.textMuted.withValues(alpha: 0.4),
        ),
        filled: true,
        fillColor: AppBrandColors.inputFill,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: AppBrandColors.outlineInput(radius: 16),
        enabledBorder: AppBrandColors.outlineInput(radius: 16),
        focusedBorder: AppBrandColors.outlineInput(
          radius: 16,
          color: AppBrandColors.primaryGreen,
          width: 1.5,
        ),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({
    required this.cooldown,
    required this.resending,
    required this.onResend,
  });

  final int cooldown;
  final bool resending;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final canResend = cooldown == 0 && !resending;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '¿No recibiste el código?',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppBrandColors.textMuted,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: TextButton(
            onPressed: canResend ? onResend : null,
            style: TextButton.styleFrom(
              foregroundColor: AppBrandColors.primaryGreen,
            ),
            child: Text(
              resending
                  ? 'Enviando…'
                  : cooldown > 0
                      ? 'Reenviar en ${cooldown}s'
                      : 'Reenviar código',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}
