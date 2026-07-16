import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth_ui.dart';

/// Botón principal de Google Sign-In para pantallas de auth.
class AuthGoogleSignInButton extends StatelessWidget {
  const AuthGoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppBrandColors.textDark,
          side: const BorderSide(color: Color(0xFFE5E7EB)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'G',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: const Color(0xFFEA4335),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continuar con Google',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Separador "o con tu correo" entre social y formulario email.
class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key, this.label = 'o con tu correo'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: AppBrandColors.textMuted,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }
}

/// Enlace para omitir auth y explorar el home como invitado.
class AuthSkipExploreLink extends StatelessWidget {
  const AuthSkipExploreLink({
    super.key,
    required this.onPressed,
    this.label = 'Omitir e ir al inicio',
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: AppBrandColors.textMuted,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            decoration: TextDecoration.underline,
            decorationColor: AppBrandColors.textMuted,
          ),
        ),
      ),
    );
  }
}
