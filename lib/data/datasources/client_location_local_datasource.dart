import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/client_location_constants.dart';
import '../../domain/entities/client_location.dart';

class ClientLocationLocalDataSource {
  ClientLocationLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  Future<ClientLocation?> readActive() async {
    final raw = _prefs.getString(ClientLocationConstants.storageKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final lat = (json['lat'] as num?)?.toDouble();
      final lng = (json['lng'] as num?)?.toDouble();
      final label = json['label'] as String?;

      if (lat == null || lng == null || label == null || label.trim().isEmpty) {
        return null;
      }

      return ClientLocation(
        lat: lat,
        lng: lng,
        label: label.trim(),
        radiusKm: (json['radiusKm'] as num?)?.toInt() ??
            ClientLocationConstants.defaultRadiusKm,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> writeActive(ClientLocation location) async {
    final payload = jsonEncode({
      'lat': location.lat,
      'lng': location.lng,
      'label': location.label,
      'radiusKm': location.radiusKm,
    });
    await _prefs.setString(ClientLocationConstants.storageKey, payload);
  }

  Future<void> clearActive() async {
    await _prefs.remove(ClientLocationConstants.storageKey);
  }
}
