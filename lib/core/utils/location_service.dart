import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class GeoPoint {
  const GeoPoint({
    required this.lat,
    required this.lng,
    this.address,
  });

  final double lat;
  final double lng;
  final String? address;
}

class LocationAccessOutcome {
  const LocationAccessOutcome._({
    this.point,
    this.failureMessage,
    this.shouldOpenSettings = false,
  });

  const LocationAccessOutcome.success(GeoPoint point)
      : this._(point: point);

  const LocationAccessOutcome.failure({
    required String failureMessage,
    bool shouldOpenSettings = false,
  }) : this._(
          failureMessage: failureMessage,
          shouldOpenSettings: shouldOpenSettings,
        );

  final GeoPoint? point;
  final String? failureMessage;
  final bool shouldOpenSettings;

  bool get isSuccess => point != null;
}

class LocationService {
  const LocationService._();

  static final _plusCodePattern = RegExp(
    r'^[A-Z0-9]{4,}\+[A-Z0-9]{2,}',
    caseSensitive: false,
  );

  static Future<bool> ensurePermission() async {
    final outcome = await resolveCurrentPosition(requestIfDenied: true);
    return outcome.isSuccess;
  }

  static Future<GeoPoint?> getCurrentPosition() async {
    final outcome = await resolveCurrentPosition();
    return outcome.point;
  }

  static Future<LocationAccessOutcome> resolveCurrentPosition({
    bool requestIfDenied = true,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationAccessOutcome.failure(
        failureMessage:
            'Activa el GPS en tu dispositivo para usar tu ubicación.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestIfDenied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return const LocationAccessOutcome.failure(
        failureMessage:
            'Permiso de ubicación bloqueado. Habilítalo en Ajustes del teléfono.',
        shouldOpenSettings: true,
      );
    }

    if (permission == LocationPermission.denied) {
      return const LocationAccessOutcome.failure(
        failureMessage:
            'Necesitamos permiso de ubicación para mostrarte profesionales cercanos.',
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final address = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );

      return LocationAccessOutcome.success(
        GeoPoint(
          lat: position.latitude,
          lng: position.longitude,
          address: address,
        ),
      );
    } catch (_) {
      return const LocationAccessOutcome.failure(
        failureMessage: 'No se pudo obtener tu ubicación. Intenta de nuevo.',
      );
    }
  }

  static Future<String?> reverseGeocode(double lat, double lng) =>
      _reverseGeocode(lat, lng);

  static Future<GeoPoint?> geocodeAddress(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return null;

    await _ensureSpanishLocale();

    final candidates = <String>{
      trimmed,
      if (!trimmed.toLowerCase().contains('perú') &&
          !trimmed.toLowerCase().contains('peru'))
        '$trimmed, Perú',
    };

    for (final candidate in candidates) {
      try {
        final locations = await locationFromAddress(candidate);
        if (locations.isEmpty) continue;

        final location = locations.first;
        final label = await _reverseGeocode(
          location.latitude,
          location.longitude,
        );

        return GeoPoint(
          lat: location.latitude,
          lng: location.longitude,
          address: label ?? trimmed,
        );
      } catch (_) {
        continue;
      }
    }

    return null;
  }

  /// Etiqueta corta para zona de búsqueda: distrito + ciudad (ej. Los Olivos, Lima).
  static String? formatDistrictCity(Placemark place) {
    final city = _normalizeCityLabel(
      _cleanPart(place.administrativeArea) ?? _cleanPart(place.locality),
    );
    final locality = _cleanPart(place.locality);
    final subLocality = _cleanPart(place.subLocality);
    final subAdmin = _cleanPart(place.subAdministrativeArea);

    String? district;

    if (locality != null &&
        city != null &&
        locality.toLowerCase() == city.toLowerCase()) {
      district = subLocality ?? subAdmin;
    } else {
      district = locality ?? subAdmin ?? subLocality;
    }

    if (district != null && city != null) {
      if (district.toLowerCase() == city.toLowerCase()) return city;
      return '$district, $city';
    }

    return district ?? city;
  }

  /// Calle y número cuando el geocoder los trae; si no, distrito + ciudad.
  static String? formatStreetAddress(Placemark place) {
    final zone = formatDistrictCity(place);
    final street = _formatStreetLine(place);

    if (street == null) return zone;
    if (zone == null) return street;

    final district = zone.split(',').first.trim();
    if (street.toLowerCase().contains(district.toLowerCase())) {
      return street;
    }

    return '$street, $district';
  }

  static Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      await _ensureSpanishLocale();
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      return formatStreetAddress(placemarks.first);
    } catch (_) {
      return null;
    }
  }

  static Future<void> _ensureSpanishLocale() async {
    try {
      await setLocaleIdentifier('es_PE');
    } catch (_) {}
  }

  static String? _formatStreetLine(Placemark place) {
    final number = _cleanPart(place.subThoroughfare);
    final road = _cleanPart(place.thoroughfare);
    final street = _cleanPart(place.street);

    String? line;
    if (road != null && !_isNoiseStreet(road, place)) {
      line = (number != null && !_containsIgnoreCase(road, number))
          ? '$road $number'
          : road;
    } else if (street != null && !_isNoiseStreet(street, place)) {
      line = street;
    }

    return line;
  }

  static bool _isNoiseStreet(String value, Placemark place) {
    final trimmed = value.trim();
    if (_plusCodePattern.hasMatch(trimmed)) return true;

    final lower = trimmed.toLowerCase();
    if (lower == 'unnamed road' || lower == 'calle sin nombre') return true;

    for (final part in [
      place.locality,
      place.subLocality,
      place.administrativeArea,
      place.subAdministrativeArea,
    ]) {
      final cleaned = _cleanPart(part);
      if (cleaned != null && lower == cleaned.toLowerCase()) return true;
    }

    return false;
  }

  static bool _containsIgnoreCase(String haystack, String needle) {
    return haystack.toLowerCase().contains(needle.toLowerCase());
  }

  static String? _cleanPart(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  static String? _normalizeCityLabel(String? value) {
    final cleaned = _cleanPart(value);
    if (cleaned == null) return null;

    final lower = cleaned.toLowerCase();
    const prefixes = [
      'provincia de ',
      'departamento de ',
      'region ',
      'región ',
    ];
    for (final prefix in prefixes) {
      if (lower.startsWith(prefix)) {
        return _cleanPart(cleaned.substring(prefix.length));
      }
    }

    return cleaned;
  }
}
