class CatalogBrowseConstants {
  CatalogBrowseConstants._();

  static const searchDebounceMs = 400;
  static const searchMinLength = 2;

  static const professionalGridAspectRatio = 0.56;

  /// Imagen del producto (ancho / alto). Mayor valor = imagen más baja.
  static const productCardImageAspectRatio = 1.28;

  /// Ancho de referencia para calcular el aspect ratio del grid.
  static const productCardReferenceWidth = 180.0;

  /// Altura estimada del bloque de texto (browse con info de vendedor).
  static const productCardFooterHeight = 118.0;

  /// Altura estimada del bloque de texto (catálogo sin vendedor).
  static const productCardFooterHeightCompact = 76.0;

  static double productGridAspectRatio({bool showSellerInfo = true}) {
    return gridAspectRatioForCard(
      imageAspectRatio: productCardImageAspectRatio,
      footerHeight: showSellerInfo
          ? productCardFooterHeight
          : productCardFooterHeightCompact,
    );
  }

  /// width / height del ítem en [GridView].
  static double gridAspectRatioForCard({
    required double imageAspectRatio,
    required double footerHeight,
    double referenceWidth = productCardReferenceWidth,
  }) {
    final imageHeight = referenceWidth / imageAspectRatio;
    return referenceWidth / (imageHeight + footerHeight);
  }
}
