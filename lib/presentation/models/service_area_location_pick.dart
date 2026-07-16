import 'service_area_coverage.dart';

class ServiceAreaLocationPick {
  const ServiceAreaLocationPick({
    required this.lat,
    required this.lng,
    required this.address,
    required this.coverageRadiusKm,
  });

  final double lat;
  final double lng;
  final String address;
  final int coverageRadiusKm;
}

class ServiceAreaMapPickerArgs {
  const ServiceAreaMapPickerArgs({
    this.initialLat,
    this.initialLng,
    this.initialQuery,
    this.initialCoverageRadiusKm = ServiceAreaCoverage.defaultKm,
    this.pinOnly = false,
  });

  final double? initialLat;
  final double? initialLng;
  final String? initialQuery;
  final int initialCoverageRadiusKm;
  /// Ubicación puntual del negocio (sin radio de cobertura).
  final bool pinOnly;
}
