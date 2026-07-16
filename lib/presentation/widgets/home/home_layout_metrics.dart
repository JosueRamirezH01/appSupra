import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'home_content_sheet.dart';

/// Medidas del carrusel flotante del home (referencia Figma).
class HomeLayoutMetrics {
  HomeLayoutMetrics._();

  /// Proporción ancho/alto del banner (~2.17:1 en mock).
  static const carouselBottomRadius = 24.0;
  static const carouselHeroOverlapRatio = 0.52;
  static const carouselAspectRatio = 0.55;

  static const _heroTopPadding = 4.0;
  static const _baseSearchRowHeight = 46.0;
  static const _baseTabsHeight = 52.0;
  static const _carouselMinHeight = 152.0;
  static const _carouselMaxHeightFactor = 0.28;
  static const _minCatalogReserve = 200.0;

  static double clampedTextScale(BuildContext context) {
    return MediaQuery.textScalerOf(context).scale(1).clamp(1.0, 1.1);
  }

  /// Solo pantallas realmente pequeñas (no la mayoría de físicos).
  static bool isCompactScreen(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return size.height < 620 || size.width < 340;
  }

  static double carouselHorizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.045).clamp(14.0, 22.0);
  }

  static double searchRowHeight(BuildContext context) {
    final scaled = _baseSearchRowHeight * clampedTextScale(context);
    return scaled.clamp(42.0, 50.0);
  }

  static double tabsHeight(BuildContext context) {
    final scaled = _baseTabsHeight * clampedTextScale(context);
    return scaled.clamp(48.0, 56.0);
  }

  static double chromeHeight(BuildContext context) {
    return MediaQuery.paddingOf(context).top +
        _heroTopPadding +
        searchRowHeight(context) +
        tabsHeight(context);
  }

  static double carouselHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final chrome = chromeHeight(context);
    final horizontal = carouselHorizontalPadding(context);
    final contentWidth = size.width - (horizontal * 2);

    // Altura principal por ancho (como en Figma).
    final fromWidth = contentWidth * carouselAspectRatio;

    final maxByScreen = size.height * _carouselMaxHeightFactor;
    final maxByLayout = math.max(
      _carouselMinHeight,
      size.height - chrome - _minCatalogReserve,
    );
    final maxHeight = math.min(maxByScreen, maxByLayout);

    final minHeight = isCompactScreen(context) ? 132.0 : _carouselMinHeight;
    final lowerBound = math.min(minHeight, maxHeight);
    final upperBound = math.max(minHeight, maxHeight);

    return fromWidth.clamp(lowerBound, upperBound);
  }

  static double carouselHeroExtent(BuildContext context) =>
      carouselHeight(context) * carouselHeroOverlapRatio;

  static double carouselSheetExtent(BuildContext context) =>
      carouselHeight(context) * (1 - carouselHeroOverlapRatio);

  static double heroHeight(BuildContext context, {required bool hasCarousel}) {
    final chrome = chromeHeight(context);
    if (!hasCarousel) return chrome + 16;
    return chrome + carouselHeroExtent(context);
  }

  static double carouselTop(BuildContext context) => chromeHeight(context);

  static double sheetTopInsetForCarousel(BuildContext context) {
    final inset = carouselSheetExtent(context) - HomeContentSheet.overlap;
    return math.max(24.0, inset);
  }

  static double carouselCtaBottom(BuildContext context, double slideHeight) {
    return (slideHeight * 0.2).clamp(32.0, 52.0);
  }

  static double carouselCtaFontSize(double slideHeight) {
    return (slideHeight * 0.115).clamp(15.0, 20.0);
  }

  static const _categoryLayoutSlack = 3.0;

  /// Ancho de cada ítem del carrusel de subcategorías.
  static double categoryItemWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return (width * 0.20).clamp(80.0, 88.0);
  }

  static double categoryLabelFontSize(BuildContext context) {
    return isCompactScreen(context) ? 10.0 : 11.0;
  }

  static double categoryLabelSpacing(BuildContext context) {
    return isCompactScreen(context) ? 4.0 : 6.0;
  }

  static double categoryLabelHeight(BuildContext context) {
    final fontSize = categoryLabelFontSize(context);
    final lineHeight = MediaQuery.textScalerOf(context).scale(fontSize) * 1.15;
    // Reserva extra: Montserrat real suele medir un poco más que el cálculo teórico.
    return lineHeight * 2 + _categoryLayoutSlack;
  }

  /// Tamaño máximo del avatar según pantalla y, si existe, altura del contenedor.
  static double categoryAvatarSize(
    BuildContext context, {
    double? maxHeight,
    double? maxSize,
  }) {
    final fromWidth = categoryItemWidth(context) * 0.78;
    var avatar = fromWidth.clamp(44.0, maxSize ?? 68.0);

    if (maxHeight != null && maxHeight.isFinite) {
      final fromHeight = maxHeight -
          categoryLabelHeight(context) -
          categoryLabelSpacing(context);
      avatar = math.min(avatar, fromHeight.clamp(44.0, maxSize ?? 68.0));
    }

    return avatar.floorToDouble();
  }

  /// Altura total de la fila horizontal de subcategorías.
  static double categoryRowHeight(BuildContext context) {
    final avatar = categoryAvatarSize(context);
    return (avatar +
            categoryLabelSpacing(context) +
            categoryLabelHeight(context))
        .ceilToDouble();
  }

  static double categoryCornerRadius(double avatarSize) {
    return (avatarSize * 0.27).clamp(12.0, 19.0);
  }

  static double categoryGridAspectRatio(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final cellWidth = (width - 32) / 4;
    return cellWidth / categoryRowHeight(context);
  }
}
