/// Límites alineados con el backend (`UPLOAD_MAX_IMAGE_BYTES`, `UPLOAD_MAX_PDF_BYTES`).
abstract final class MediaUploadConstants {
  static const int maxImageBytes = 2 * 1024 * 1024;
  static const int maxPdfBytes = 10 * 1024 * 1024;

  /// Objetivo de compresión para dejar margen bajo el límite del servidor.
  static const int targetImageBytes = 1800 * 1024;

  static const int maxImageEdge = 1600;
  static const int initialCompressQuality = 82;
  static const int minCompressQuality = 55;
  static const int compressQualityStep = 12;

  static const int defaultUploadConcurrency = 3;
}
