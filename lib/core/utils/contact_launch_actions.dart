import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class ContactLaunchActions {
  static String? _digits(String? phone) {
    final raw = phone?.trim();
    if (raw == null || raw.isEmpty) return null;
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits.isEmpty ? null : digits;
  }

  static Future<void> call(BuildContext context, String? phone) async {
    final digits = _digits(phone);
    if (digits == null) {
      _snack(context, 'Teléfono no disponible');
      return;
    }

    final uri = Uri(scheme: 'tel', path: digits);
    if (!await launchUrl(uri)) {
      if (!context.mounted) return;
      _snack(context, 'No se pudo abrir el teléfono');
    }
  }

  static Future<void> whatsApp(
    BuildContext context,
    String? phone, {
    String? message,
  }) async {
    final digits = _digits(phone);
    if (digits == null) {
      _snack(context, 'Teléfono no disponible para WhatsApp');
      return;
    }

    final trimmedMessage = message?.trim();
    final uri = trimmedMessage == null || trimmedMessage.isEmpty
        ? Uri.parse('https://wa.me/$digits')
        : Uri.parse(
            'https://wa.me/$digits?text=${Uri.encodeComponent(trimmedMessage)}',
          );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      _snack(context, 'No se pudo abrir WhatsApp');
    }
  }

  static void showSuccessSnackBar(
    BuildContext context, {
    required bool isWhatsApp,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isWhatsApp
              ? 'Datos registrados. Abriendo WhatsApp…'
              : 'Datos registrados. Abriendo llamada…',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
