import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../presentation/widgets/auth/auth_ui.dart';
import 'image_contact_guard.dart';
import 'media_compress_utils.dart';

class ImagePickerUtils {
  ImagePickerUtils._();

  static final ImagePicker _picker = ImagePicker();

  static Future<File?> pickImage(BuildContext context) async {
    final source = await _showSourceSheet(context);
    if (source == null || !context.mounted) return null;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 2048,
      maxHeight: 2048,
    );

    if (picked == null) return null;
    return File(picked.path);
  }

  static Future<File?> pickImageOrPdf(BuildContext context) async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppBrandColors.primaryGreen,
                  ),
                  title: Text(
                    'Imagen',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'image'),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.picture_as_pdf_outlined,
                    color: AppBrandColors.primaryGreen,
                  ),
                  title: Text(
                    'PDF',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => Navigator.pop(sheetContext, 'pdf'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice == null || !context.mounted) return null;

    if (choice == 'image') {
      return pickImage(context);
    }

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;
    return MediaCompressUtils.prepareForUpload(File(path));
  }

  static Future<List<File>> pickMultipleImages(BuildContext context) async {
    final picked = await _picker.pickMultiImage(
      imageQuality: 90,
      maxWidth: 2048,
      maxHeight: 2048,
    );

    if (picked.isEmpty) return [];
    return picked.map((file) => File(file.path)).toList();
  }

  /// Public catalog images: portfolio, technician profile photo, seller logo, product photos.
  static Future<File?> pickPublicCatalogImage(BuildContext context) async {
    final file = await pickImage(context);
    if (file == null || !context.mounted) return null;

    final allowed = await _scanPublicCatalogImage(
      context,
      file,
      progressLabel: 'Revisando imagen...',
    );
    return allowed ? file : null;
  }

  static Future<List<File>> pickMultiplePublicCatalogImages(
    BuildContext context,
  ) async {
    final files = await pickMultipleImages(context);
    if (files.isEmpty || !context.mounted) return [];

    final accepted = <File>[];
    var rejected = 0;

    for (var index = 0; index < files.length; index++) {
      if (!context.mounted) break;

      final allowed = await _scanPublicCatalogImage(
        context,
        files[index],
        progressLabel: files.length == 1
            ? 'Revisando imagen...'
            : 'Revisando imagen ${index + 1} de ${files.length}...',
      );

      if (allowed) {
        accepted.add(files[index]);
      } else {
        rejected++;
      }
    }

    if (rejected > 0 && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            rejected == 1
                ? '1 imagen no se agregó porque parece incluir un contacto.'
                : '$rejected imágenes no se agregaron porque parecen incluir un contacto.',
            style: GoogleFonts.poppins(),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    return accepted;
  }

  static Future<bool> _scanPublicCatalogImage(
    BuildContext context,
    File file, {
    required String progressLabel,
  }) async {
    _showScanDialog(context, progressLabel);

    try {
      final hasContact = await ImageContactGuard.containsContactInfo(file);
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (hasContact) {
        if (context.mounted) _showContactBlockedSnackBar(context);
        return false;
      }

      return true;
    } catch (_) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      // OCR unavailable: do not block the user on device errors.
      return true;
    }
  }

  static void _showScanDialog(BuildContext context, String message) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showContactBlockedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ImageContactGuard.blockedMessage,
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static Future<ImageSource?> _showSourceSheet(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Seleccionar imagen',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(
                    Icons.photo_library_outlined,
                    color: AppBrandColors.primaryGreen,
                  ),
                  title: Text(
                    'Galería',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Elegir una foto guardada',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                  onTap: () =>
                      Navigator.pop(sheetContext, ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppBrandColors.primaryGreen,
                  ),
                  title: Text(
                    'Cámara',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Tomar una foto ahora',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
