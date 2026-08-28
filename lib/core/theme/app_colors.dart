import 'package:flutter/material.dart';

/// Tokens de marca — única fuente de verdad para colores de la app.
abstract final class AppBrandColors {
  static const primaryGreen = Color(0xFF5EA529);
  /// Descuento / oferta. El verde queda para marca y acciones.
  static const promoAmber = Color(0xFFFB8C00);
  static const islaHomePromo = Color(0xFF7AD435);
  static const islaServicePromo = Color(0xFF79806B);
  static const islaHomeProducts = Color(0xFFE8F5D8);
  /// Superficies suaves de marca (chips, placeholders). No usar en inputs.
  static const fieldFill = Color(0xFFEAF3DD);
  /// Relleno de campos. Neutro: la marca va en el foco.
  static const inputFill = Color(0xFFF4F5F4);
  static const inputBorder = Color(0xFFE5E7EB);
  static const scaffoldBackground = Colors.white;
  static const textDark = Color(0xFF1F2937);
  static const textMuted = Color(0xFF6B7280);
  static const cardShadow = Color(0x1F000000);

  static OutlineInputBorder outlineInput({
    double radius = 14,
    Color? color,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(color: color ?? inputBorder, width: width),
    );
  }
}
