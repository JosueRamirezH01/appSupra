import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/client_location.dart';
import 'client_location_data_providers.dart';

part 'client_location_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveClientLocation extends _$ActiveClientLocation {
  @override
  Future<ClientLocation?> build() async {
    final repo = await ref.watch(clientLocationRepositoryProvider.future);
    return repo.getSavedLocation();
  }

  Future<void> confirmLocation(ClientLocation location) async {
    final repo = await ref.read(clientLocationRepositoryProvider.future);
    await repo.saveLocation(location);
    state = AsyncValue.data(location);
  }

  Future<void> clearLocation() async {
    final repo = await ref.read(clientLocationRepositoryProvider.future);
    await repo.clearLocation();
    state = const AsyncValue.data(null);
  }
}

class GeoSearchResult {
  const GeoSearchResult({
    required this.lat,
    required this.lng,
    required this.label,
  });

  final double lat;
  final double lng;
  final String label;

  ClientLocation toClientLocation({int radiusKm = 15}) => ClientLocation(
        lat: lat,
        lng: lng,
        label: label,
        radiusKm: radiusKm,
      );
}
