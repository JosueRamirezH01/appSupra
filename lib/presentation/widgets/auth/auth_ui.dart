import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

export '../../../core/theme/app_colors.dart';

String? validatePasswordConfirmation(
  String? value, {
  required String password,
}) {
  if (value == null || value.isEmpty) {
    return 'Confirma tu contraseña';
  }
  if (value != password) {
    return 'Las contraseñas no coinciden';
  }
  return null;
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

/// Logo responsive con fallback si el asset no carga.
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final logoHeight = compact
        ? (width * 0.14).clamp(40.0, 56.0)
        : (width * 0.18).clamp(48.0, 80.0);

    return Image.asset(
      'assets/img/logo.png',
      height: logoHeight,
      errorBuilder: (context, error, stackTrace) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.home_rounded,
            color: AppBrandColors.primaryGreen,
            size: logoHeight * 0.7,
          ),
          const SizedBox(width: 6),
          Text(
            'SUPRA',
            style: GoogleFonts.montserrat(
              fontSize: logoHeight * 0.45,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class AuthRoundedField extends StatelessWidget {
  const AuthRoundedField({
    super.key,
    required this.controller,
    required this.label,
    this.obscureText = false,
    this.readOnly = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength
  });

  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final int minLines;
  final int maxLines;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      readOnly: readOnly,
      keyboardType: keyboardType,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      autocorrect: false,
      enableSuggestions: false,
      validator: validator,
      style: GoogleFonts.poppins(color: AppBrandColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppBrandColors.textMuted),
        filled: true,
        fillColor: AppBrandColors.fieldFill,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppBrandColors.primaryGreen,
            width: 1.8,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
        ),
        counterText: maxLength != null ? '' : null,
      ),
    );
  }
}

InputDecoration authDropdownDecoration(String label) {
  return InputDecoration(
    labelText: label,
    labelStyle: GoogleFonts.poppins(color: AppBrandColors.textMuted),
    filled: true,
    fillColor: AppBrandColors.fieldFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: AppBrandColors.primaryGreen,
        width: 1.8,
      ),
    ),
  );
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: AppBrandColors.primaryGreen,
          disabledBackgroundColor:
              AppBrandColors.primaryGreen.withValues(alpha: 0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class AuthSecondaryButton extends StatelessWidget {
  const AuthSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppBrandColors.textDark,
          side: const BorderSide(color: AppBrandColors.primaryGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class AuthTextLink extends StatelessWidget {
  const AuthTextLink({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(foregroundColor: AppBrandColors.primaryGreen),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPad = width < 360 ? 20.0 : 20.0;

    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: AppBrandColors.cardShadow,
      borderRadius: BorderRadius.circular(28),
      child: Padding(
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: horizontalPad, vertical: 20),
        child: child,
      ),
    );
  }
}

/// Scaffold verde con tarjeta blanca centrada — patrón del login.
class AuthFlowScaffold extends StatelessWidget {
  const AuthFlowScaffold({
    super.key,
    this.title,
    this.subtitle,
    required this.child,
    this.footer,
    this.onBack,
    this.topActions,
    this.progress,
    this.expandBody = false,
    this.showLogo = true,
    this.compactLogo = false,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final Widget? footer;
  final VoidCallback? onBack;
  final List<Widget>? topActions;
  final double? progress;
  final bool expandBody;
  final bool showLogo;
  final bool compactLogo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppBrandColors.primaryGreen,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 600;
              final cardMaxWidth = isCompact ? constraints.maxWidth * 0.94 : 520.0;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Row(
                      children: [
                        if (onBack != null)
                          IconButton(
                            onPressed: onBack,
                            icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            color: Colors.white,
                          )
                        else
                          const SizedBox(width: 48),
                        const Spacer(),
                        ...?topActions,
                      ],
                    ),
                  ),
                  if (progress != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: cardMaxWidth),
                          child: AuthFormCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (showLogo) ...[
                                  AuthLogo(compact: compactLogo),
                                  const SizedBox(height: 16),
                                ],
                                if (title != null)
                                  Text(
                                    title!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppBrandColors.textDark,
                                      height: 1.3,
                                    ),
                                  ),
                                if (subtitle != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    subtitle!,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppBrandColors.textMuted,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                                if (title != null || subtitle != null)
                                  const SizedBox(height: 24),
                                child,
                                if (footer != null) ...[
                                  const SizedBox(height: 24),
                                  footer!,
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class AuthSectionLabel extends StatelessWidget {
  const AuthSectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppBrandColors.textDark,
      ),
    );
  }
}

class AuthInfoTip extends StatelessWidget {
  const AuthInfoTip({
    super.key,
    required this.message,
    this.icon = Icons.info_outline_rounded,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppBrandColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppBrandColors.primaryGreen.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppBrandColors.primaryGreen),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppBrandColors.textDark,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Agrupa campos del registro con título y contexto breve.
class AuthFormSection extends StatelessWidget {
  const AuthFormSection({
    super.key,
    required this.title,
    required this.child,
    this.hint,
    this.icon,
  });

  final String title;
  final String? hint;
  final IconData? icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: AppBrandColors.primaryGreen),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    if (hint != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        hint!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppBrandColors.textMuted,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class AuthOptionCard extends StatelessWidget {
  const AuthOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final accent = highlighted
        ? AppBrandColors.primaryGreen
        : AppBrandColors.textDark;

    return Material(
      color: highlighted
          ? AppBrandColors.fieldFill
          : const Color(0xFFF9FAFB),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlighted
                  ? AppBrandColors.primaryGreen.withValues(alpha: 0.4)
                  : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: AppBrandColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: AppBrandColors.textMuted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthUploadTile extends StatelessWidget {
  const AuthUploadTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPick,
    this.preview,
    this.enabled = true,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPick;
  final Widget? preview;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppBrandColors.fieldFill,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (preview != null) ...[
            preview!,
            const SizedBox(width: 14),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: enabled ? onPick : null,
            style: TextButton.styleFrom(
              foregroundColor: AppBrandColors.primaryGreen,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              buttonLabel,
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

ChipThemeData authChipTheme(BuildContext context) {
  return ChipTheme.of(context).copyWith(
    backgroundColor: const Color(0xFFF3F4F6),
    selectedColor: AppBrandColors.primaryGreen.withValues(alpha: 0.22),
    disabledColor: const Color(0xFFE5E7EB),
    checkmarkColor: AppBrandColors.primaryGreen,
    labelStyle: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: AppBrandColors.textDark,
    ),
    secondaryLabelStyle: GoogleFonts.poppins(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppBrandColors.textDark,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: const BorderSide(color: Color(0xFFE5E7EB)),
  );
}

/// Chip con contraste legible en estados seleccionado y normal.
class AuthChoiceChip extends StatelessWidget {
  const AuthChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.showCheckmark = false,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final bool showCheckmark;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: AppBrandColors.textDark,
        ),
      ),
      selected: selected,
      showCheckmark: showCheckmark,
      checkmarkColor: AppBrandColors.primaryGreen,
      selectedColor: AppBrandColors.primaryGreen.withValues(alpha: 0.22),
      backgroundColor: const Color(0xFFF3F4F6),
      side: BorderSide(
        color: selected
            ? AppBrandColors.primaryGreen
            : const Color(0xFFD1D5DB),
        width: selected ? 1.5 : 1,
      ),
      onSelected: onSelected,
    );
  }
}
