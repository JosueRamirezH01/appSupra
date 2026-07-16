import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

import '../constants/media_upload_constants.dart';
import '../errors/app_exception.dart';

class MediaCompressUtils {
  MediaCompressUtils._();

  static bool isPdf(File file) {
    final lower = file.path.toLowerCase();
    return lower.endsWith('.pdf');
  }

  static bool isImage(File file) {
    final lower = file.path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.heic') ||
        lower.endsWith('.heif');
  }

  /// Comprime imágenes antes del upload. Los PDF se validan por tamaño.
  static Future<File> prepareForUpload(File file) async {
    if (isPdf(file)) {
      _validatePdfSize(file);
      return file;
    }

    if (!isImage(file)) {
      return file;
    }

    return compressImageIfNeeded(file);
  }

  static void _validatePdfSize(File file) {
    final size = file.lengthSync();
    if (size > MediaUploadConstants.maxPdfBytes) {
      final maxMb = MediaUploadConstants.maxPdfBytes ~/ (1024 * 1024);
      throw AppException(
        message:
            'El PDF es demasiado grande (máx. $maxMb MB). Escanea en calidad media.',
        code: 'FILE_TOO_LARGE',
      );
    }
  }

  static Future<File> compressImageIfNeeded(File file) async {
    final originalSize = await file.length();
    if (originalSize <= MediaUploadConstants.targetImageBytes) {
      if (originalSize <= MediaUploadConstants.maxImageBytes) {
        return file;
      }
    }

    var current = file;
    var quality = MediaUploadConstants.initialCompressQuality;

    while (quality >= MediaUploadConstants.minCompressQuality) {
      final compressed = await _compressOnce(current, quality: quality);
      if (compressed == null) break;

      final compressedSize = await compressed.length();
      if (compressedSize <= MediaUploadConstants.targetImageBytes) {
        await _deleteIfTemporary(current, keep: compressed);
        return compressed;
      }

      await _deleteIfTemporary(current, keep: compressed);
      current = compressed;
      quality -= MediaUploadConstants.compressQualityStep;
    }

    final finalSize = await current.length();
    if (finalSize > MediaUploadConstants.maxImageBytes) {
      final maxMb = MediaUploadConstants.maxImageBytes ~/ (1024 * 1024);
      throw AppException(
        message:
            'La imagen sigue siendo muy pesada (máx. $maxMb MB). Prueba otra foto o más cercana.',
        code: 'FILE_TOO_LARGE',
      );
    }

    return current;
  }

  static Future<File?> _compressOnce(File file, {required int quality}) async {
    final targetPath = p.join(
      Directory.systemTemp.path,
      'upload_${DateTime.now().microsecondsSinceEpoch}.webp',
    );

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: quality,
      minWidth: MediaUploadConstants.maxImageEdge,
      minHeight: MediaUploadConstants.maxImageEdge,
      format: CompressFormat.webp,
      keepExif: false,
    );

    if (result == null) return null;
    return File(result.path);
  }

  static Future<void> _deleteIfTemporary(File current, {required File keep}) async {
    if (current.path == keep.path) return;
    if (!current.path.contains(Directory.systemTemp.path)) return;
    try {
      if (await current.exists()) {
        await current.delete();
      }
    } catch (_) {}
  }
}
