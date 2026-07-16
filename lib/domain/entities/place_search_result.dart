class PlaceSearchResult {
  const PlaceSearchResult({
    this.id,
    required this.label,
    required this.lat,
    required this.lng,
  });

  final int? id;
  final String label;
  final double lat;
  final double lng;
}
