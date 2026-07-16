class ClientLocation {
  const ClientLocation({
    required this.lat,
    required this.lng,
    required this.label,
    this.radiusKm = 15,
  });

  final double lat;
  final double lng;
  final String label;
  final int radiusKm;
}
