class CatalogConstants {
  CatalogConstants._();

  static const otrosServiciosTecnicosSubcategoryName = 'Otros servicios técnicos';

  static const customSpecialtyMinLength = 3;
  static const customSpecialtyMaxLength = 100;

  /// Items fetched from API for home product preview row (UI shows [homePreviewDisplayCount]).
  static const homePreviewFetchLimit = 12;

  /// Product circles shown in the home horizontal row before "Ver más".
  static const homePreviewDisplayCount = 6;

  /// Isla de productos del home: 6 cards + Ver más.
  static const homeFeaturedProductsCount = 6;

  /// Isla de ofertas del home (carrusel). El API ya recorta a este tope.
  static const homeOffersPreviewCount = 6;

  /// Materiales relacionados: tope del riel. Si hay 4+, la card Ver más va al final.
  static const relatedMaterialsPreviewCount = 6;
  static const relatedMaterialsSeeMoreFrom = 4;

  /// Productos estrella en Mi tienda. Solo el vendedor los ve.
  static const sellerStarredProductLimit = 4;

  /// Minimum characters for catalog search query param.
  static const searchMinLength = 2;

  static bool isOtrosSubcategoryName(String name) =>
      name.trim().toLowerCase() ==
      otrosServiciosTecnicosSubcategoryName.toLowerCase();

  static bool isClientVisibleSubcategory(String name) =>
      !isOtrosSubcategoryName(name);
}
