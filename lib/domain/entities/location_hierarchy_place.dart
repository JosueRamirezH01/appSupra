class LocationHierarchyPlace {
  const LocationHierarchyPlace({
    required this.id,
    required this.name,
    required this.label,
    required this.lat,
    required this.lng,
    this.ubigeo,
  });

  final int id;
  final String name;
  final String label;
  final double lat;
  final double lng;
  final String? ubigeo;
}
