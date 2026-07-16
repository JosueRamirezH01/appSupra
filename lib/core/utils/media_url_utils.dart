import 'package:flutter/painting.dart';

import '../config/app_config.dart';

/// Convierte URLs de medios del backend al host accesible desde el dispositivo.
///
/// En BD pueden quedar `localhost`, `10.0.2.2` o IP LAN según cómo se subió el archivo.
/// Se normalizan al origen de [AppConfig.baseUrl] (emulador, LAN o ngrok).
class MediaUrlUtils {
  MediaUrlUtils._();

  static Uri? get _apiOrigin {
    final apiUri = Uri.parse(AppConfig.baseUrl);
    if (!apiUri.hasScheme || apiUri.host.isEmpty) return null;

    return Uri(
      scheme: apiUri.scheme,
      host: apiUri.host,
      port: apiUri.hasPort ? apiUri.port : null,
    );
  }

  /// ngrok free exige este header en peticiones de imagen desde la app.
  static Map<String, String>? get imageHttpHeaders {
    final host = Uri.tryParse(AppConfig.baseUrl)?.host ?? '';
    if (host.contains('ngrok')) {
      return const {'ngrok-skip-browser-warning': 'true'};
    }
    return null;
  }

  static const _privateCategories = {
    'face_photo',
    'document',
    'license',
    'background_check',
    'certification',
  };

  /// Identity docs and staging paths require Authorization / upload ticket.
  static bool isPrivateMediaUrl(String? url) {
    final resolved = resolve(url);
    if (resolved == null || resolved.isEmpty) return false;

    final uri = Uri.tryParse(resolved);
    if (uri == null) return false;

    final segments = uri.path.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return false;

    final uploadsIndex = segments.indexOf('uploads');
    final parts = uploadsIndex >= 0 ? segments.sublist(uploadsIndex + 1) : segments;

    if (parts.isEmpty) return false;
    if (parts.first == 'pending' || parts.first == 'register') return true;

    if ((parts.first == 'technicians' || parts.first == 'users') &&
        parts.length >= 3) {
      return _privateCategories.contains(parts[2]);
    }

    return false;
  }

  static Map<String, String>? headersForMedia({
    required String? url,
    String? accessToken,
  }) {
    final headers = <String, String>{
      ...?imageHttpHeaders,
    };

    if (isPrivateMediaUrl(url) &&
        accessToken != null &&
        accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers.isEmpty ? null : headers;
  }

  static bool _isLocalOrLanHost(String host) {
    if (host == 'localhost' ||
        host == '127.0.0.1' ||
        host == '0.0.0.0' ||
        host == '10.0.2.2') {
      return true;
    }

    final parts = host.split('.');
    if (parts.length != 4) return false;

    final octets = parts.map(int.tryParse).toList();
    if (octets.any((value) => value == null)) return false;

    final a = octets[0]!;
    final b = octets[1]!;

    if (a == 192 && b == 168) return true;
    if (a == 10) return true;
    if (a == 172 && b >= 16 && b <= 31) return true;

    return false;
  }

  static String? resolve(String? url) {
    if (url == null || url.trim().isEmpty) return url;

    final trimmed = url.trim();
    final origin = _apiOrigin;
    if (origin == null) return url;

    final normalizedPath = trimmed.replaceAll('\\', '/').replaceFirst(RegExp(r'^/+'), '');
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      if (normalizedPath.startsWith('uploads/')) {
        return origin.replace(path: '/$normalizedPath').toString();
      }
      return url;
    }

    final mediaUri = Uri.tryParse(trimmed);
    if (mediaUri == null || !mediaUri.hasScheme) return url;

    if (!mediaUri.path.contains('/uploads/')) return url;

    final sameOrigin = mediaUri.host == origin.host &&
        mediaUri.scheme == origin.scheme &&
        (mediaUri.hasPort ? mediaUri.port : null) ==
            (origin.hasPort ? origin.port : null);

    if (sameOrigin) return trimmed;

    if (!_isLocalOrLanHost(mediaUri.host) && mediaUri.host != origin.host) {
      return trimmed;
    }

    return origin
        .replace(
          path: mediaUri.path,
          query: mediaUri.query.isEmpty ? null : mediaUri.query,
        )
        .toString();
  }

  static ImageProvider? networkImage(String? url) {
    final resolved = resolve(url);
    if (resolved == null || resolved.isEmpty) return null;

    final headers = imageHttpHeaders;
    if (headers != null) {
      return NetworkImage(resolved, headers: headers);
    }
    return NetworkImage(resolved);
  }
}
