/// Radios permitidos por el backend (`coverageRadiusKmSchema`).
class ServiceAreaCoverage {
  ServiceAreaCoverage._();

  static const defaultKm = 10;
  static const allowedKm = [5, 7, 10, 15, 20, 25, 30];
  static const minKm = 5;
  static const maxKm = 30;

  static int normalize(int km) {
    if (allowedKm.contains(km)) return km;
    return snapFromSlider(km.toDouble());
  }

  /// Snap continuo del slider al valor permitido más cercano.
  static int snapFromSlider(double value) {
    final rounded = value.round();
    var closest = allowedKm.first;
    var minDiff = (rounded - closest).abs();
    for (final option in allowedKm.skip(1)) {
      final diff = (rounded - option).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closest = option;
      }
    }
    return closest;
  }

  static double sliderValueFor(int km) => normalize(km).toDouble();
}
