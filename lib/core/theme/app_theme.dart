import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppBrandColors.primaryGreen,
        primary: AppBrandColors.primaryGreen,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: AppBrandColors.scaffoldBackground,
      textTheme: GoogleFonts.poppinsTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppBrandColors.inputFill,
        border: AppBrandColors.outlineInput(),
        enabledBorder: AppBrandColors.outlineInput(),
        focusedBorder: AppBrandColors.outlineInput(
          color: AppBrandColors.primaryGreen,
          width: 1.8,
        ),
        errorBorder: AppBrandColors.outlineInput(color: Colors.redAccent),
        focusedErrorBorder: AppBrandColors.outlineInput(
          color: Colors.redAccent,
          width: 1.8,
        ),
      ),
    );
  }
}
