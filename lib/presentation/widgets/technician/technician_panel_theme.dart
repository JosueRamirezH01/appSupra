import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';

/// Paleta exclusiva del panel técnico.
abstract final class TechnicianPanelColors {
  static const primary = AppBrandColors.primaryGreen;
  static const background = Color(0xFFF5F6FB);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0B1C15);
  static const inkMuted = Color(0x990B1C15);
  static const inkSoft = Color(0x660B1C15);
  static const border = Color(0x140B1C15);
  static const primarySoft = Color(0x1A76B72A);
  static const primaryMuted = Color(0x3376B72A);
  static const warning = Color(0xFFB45309);
  static const warningSoft = Color(0xFFFFF7ED);
  static const success = Color(0xFF0F766E);
  static const successSoft = Color(0xFFE6F7F4);
}

abstract final class TechnicianPanelTheme {
  static TextStyle get display => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: TechnicianPanelColors.ink,
        height: 1.2,
      );

  static TextStyle get title => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: TechnicianPanelColors.ink,
      );

  static TextStyle get subtitle => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: TechnicianPanelColors.inkMuted,
        height: 1.4,
      );

  static TextStyle get body => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: TechnicianPanelColors.ink,
        height: 1.45,
      );

  static TextStyle get label => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: TechnicianPanelColors.inkSoft,
      );

  static TextStyle get chip => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: TechnicianPanelColors.ink,
      );

  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
        color: color ?? TechnicianPanelColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TechnicianPanelColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080B1C15),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration heroDecoration() => BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppBrandColors.primaryGreen,
            Color(0xFF79806B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0B1C15),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      );
}
