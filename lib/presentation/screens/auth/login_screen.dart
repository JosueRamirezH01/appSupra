import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/navigation/auth_navigation.dart';
import '../../../core/services/google_sign_in_service.dart';
import '../../../core/utils/error_utils.dart';
import '../../../core/utils/navigation_utils.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../widgets/auth/auth_login_panel.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common/app_build_version_label.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmailLogin() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );

    if (!mounted) return;
    _handleAuthResult();
  }

  Future<void> _loginWithGoogle() async {
    final googleService = GoogleSignInService();

    if (!googleService.isConfigured) {
      showErrorSnackBar(
        context,
        'Google Sign-In no está configurado. Define GOOGLE_SERVER_CLIENT_ID.',
      );
      return;
    }

    try {
      final idToken = await googleService.signInAndGetIdToken();
      if (idToken == null || !mounted) return;

      await ref.read(authNotifierProvider.notifier).loginWithGoogle(idToken);
      if (!mounted) return;
      _handleAuthResult();
    } catch (e) {
      if (mounted) showErrorSnackBar(context, e);
    }
  }

  void _handleAuthResult() {
    final state = ref.read(authNotifierProvider);
    state.whenOrNull(
      error: (e, _) => showErrorSnackBar(context, e),
      data: (user) {
        if (user != null) {
          ref.read(activeAppViewProvider.notifier).syncWithUser(user,applyDefaultView: true);
          final activeView = ref.read(activeAppViewProvider);
          context.go(rootPathForView(resolveActiveView(user, activeView)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Stack(
      fit: StackFit.expand,
      children: [
        AuthFlowScaffold(
          showLogo: true,
          title: 'Inicia sesión',
          subtitle: 'Usa Google, tu correo registrado o crea una cuenta nueva.',
          onBack: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RoutePaths.preLogin);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthGoogleSignInButton(
                  isLoading: isLoading,
                  onPressed: _loginWithGoogle,
                ),
                const SizedBox(height: 10),
                const AuthOrDivider(),
                const SizedBox(height: 10),
                AuthRoundedField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Ingresa tu correo' : null,
                ),
                const SizedBox(height: 14),
                AuthRoundedField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Ingresa tu contraseña' : null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: AuthTextLink(
                    label: '¿Olvidaste tu contraseña?',
                    onPressed: () => context.push(RoutePaths.forgotPassword),
                  ),
                ),
                const SizedBox(height: 8),
                AuthPrimaryButton(
                  label: 'Ingresar con correo',
                  isLoading: isLoading,
                  onPressed: _submitEmailLogin,
                ),
                const SizedBox(height: 6),
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : () => openRegister(context),
                    child: Text(
                      'Crear una cuenta',
                      style: GoogleFonts.poppins(
                        color: AppBrandColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                AuthSkipExploreLink(
                  onPressed:
                      isLoading ? null : () => exploreWithoutAccount(context),
                ),
              ],
            ),
          ),
        ),
        // Sobre el fondo verde, fuera de la card — no compite con el CTA.
        const AppBuildVersionCorner(onDarkBackground: true),
      ],
    );
  }
}
