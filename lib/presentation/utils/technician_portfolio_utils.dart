import '../../data/models/technicians/technician_model.dart';

extension TechnicianPortfolioItemX on TechnicianPortfolioItemModel {
  String get displayLocation {
    final place = location?.trim();
    if (place != null && place.isNotEmpty) return place;
    return title;
  }

  String? get coverUrl {
    final cover = imageUrl?.trim();
    if (cover != null && cover.isNotEmpty) return cover;
    for (final image in images) {
      final url = image.imageUrl.trim();
      if (url.isNotEmpty) return url;
    }
    return null;
  }

  List<String> get galleryUrls {
    final fromImages = images
        .map((image) => image.imageUrl.trim())
        .where((url) => url.isNotEmpty)
        .toList(growable: false);
    if (fromImages.isNotEmpty) return fromImages;
    final cover = imageUrl?.trim();
    if (cover != null && cover.isNotEmpty) return [cover];
    return const [];
  }
}
