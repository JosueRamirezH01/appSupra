import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Detects phone / WhatsApp-style contact info in image text (OCR).
class ImageContactGuard {
  ImageContactGuard._();

  static const blockedMessage =
      'La imagen parece incluir un celular o WhatsApp. Sube una foto sin datos de contacto.';

  static final RegExp _contactKeywords = RegExp(
    r'(whatsapp|wsp|wa\.me|celular|cel\.?|llamar|tel[eé]fono|telf\.?|móvil|movil)',
    caseSensitive: false,
  );

  static final RegExp _peruMobileDigits = RegExp(r'9\d{8}');

  static final RegExp _peruInternational = RegExp(
    r'\+?\s*51[\s\-\.]?9\d{2}[\s\-\.]?\d{3}[\s\-\.]?\d{3}',
    caseSensitive: false,
  );

  /// Pure text rules — useful for tests and OCR output.
  static bool containsContactInText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    if (_peruInternational.hasMatch(trimmed)) return true;

    final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');
    if (_peruMobileDigits.hasMatch(digitsOnly)) return true;

    if (_contactKeywords.hasMatch(trimmed)) {
      final digitCount = RegExp(r'\d').allMatches(trimmed).length;
      if (digitCount >= 7) return true;
    }

    return false;
  }

  static Future<bool> containsContactInfo(File file) async {
    final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final recognizedText = await recognizer.processImage(inputImage);
      return containsContactInText(recognizedText.text);
    } finally {
      await recognizer.close();
    }
  }
}
