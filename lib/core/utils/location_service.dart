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

    try {
      await setLocaleIdentifier('es_PE');
    } catch (_) {}

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

  /// Etiqueta corta para zona de servicio: distrito + ciudad (ej. Los Olivos, Lima).
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

  static Future<String?> _reverseGeocode(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;

      return formatDistrictCity(placemarks.first);
    } catch (_) {
      return null;
    }
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
