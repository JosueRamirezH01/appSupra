import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Abre la ubicación del técnico/vendedor en Maps (app o navegador).
abstract final class MapsLaunchActions {
  static Future<void> openLocation(
    BuildContext context, {
    double? lat,
    double? lng,
    String? address,
  }) async {
    final uri = _buildMapsUri(lat: lat, lng: lng, address: address);
    if (uri == null) {
      _snack(context, 'Ubicación no disponible');
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      _snack(context, 'No se pudo abrir Maps');
    }
  }

  static bool canOpen({double? lat, double? lng, String? address}) {
    return _buildMapsUri(lat: lat, lng: lng, address: address) != null;
  }

  static Uri? _buildMapsUri({
    double? lat,
    double? lng,
    String? address,
  }) {
    if (lat != null && lng != null) {
      return Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
      );
    }

    final trimmed = address?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;

    return Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(trimmed)}',
    );
  }

  static void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }
}
