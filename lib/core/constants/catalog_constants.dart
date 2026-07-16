class CatalogConstants {
  CatalogConstants._();

  static const otrosServiciosTecnicosSubcategoryName = 'Otros servicios técnicos';

  static const customSpecialtyMinLength = 3;
  static const customSpecialtyMaxLength = 100;

  /// Items fetched from API for home product preview row (UI shows [homePreviewDisplayCount]).
  static const homePreviewFetchLimit = 12;

  /// Product circles shown in the home horizontal row before "Ver más".
  static const homePreviewDisplayCount = 6;

  /// Minimum characters for catalog search query param.
  static const searchMinLength = 2;

  static bool isOtrosSubcategoryName(String name) =>
      name.trim().toLowerCase() ==
      otrosServiciosTecnicosSubcategoryName.toLowerCase();

  static bool isClientVisibleSubcategory(String name) =>
      !isOtrosSubcategoryName(name);
}
