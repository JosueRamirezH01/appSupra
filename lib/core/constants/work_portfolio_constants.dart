/// Límites de fotos/casos de trabajo (alineado al API).
abstract final class WorkPortfolioConstants {
  /// Mínimo en verificación de perfil (independiente).
  static const int minPhotos = 6;

  /// Máximo en verificación de perfil.
  static const int maxPhotos = 10;

  /// Máximo de casos del catálogo por servicio (carrusel del perfil).
  static const int maxServiceCatalogCases = 5;

  static const int minCaptionLength = 3;
  static const int maxCaptionLength = 500;
}
