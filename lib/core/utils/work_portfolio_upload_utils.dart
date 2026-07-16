import '../../data/models/uploads/upload_model.dart';

class WorkPortfolioUploadUtils {
  WorkPortfolioUploadUtils._();

  static String resolveReference(UploadedFileModel file) {
    final path = normalizeUploadReference(file.path);
    if (path != null) return path;

    final url = normalizeUploadReference(file.url);
    if (url != null) return url;

    throw StateError('El archivo subido no devolvió una URL válida');
  }

  static String? normalizeUploadReference(String? value) {
    if (value == null) return null;

    final trimmed = value.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('uploads/')) return trimmed;

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme) {
      final path = uri.path;
      if (path.startsWith('/uploads/')) {
        return path.substring(1);
      }
    }

    final normalized = trimmed.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
    if (normalized.startsWith('uploads/')) return normalized;

    return trimmed;
  }
}
