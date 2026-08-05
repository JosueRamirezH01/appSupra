import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/client_location_constants.dart';
import '../../../core/utils/location_service.dart';
import '../../../domain/entities/client_location.dart';
import '../professionals/professionals_browse_provider.dart';
import 'client_location_provider.dart';

void refreshLocationDependents(WidgetRef ref) {
  ref.invalidate(professionalsBrowseControllerProvider);
}

Future<void> confirmClientLocation(
  WidgetRef ref,
  ClientLocation location,
) async {
  await ref
      .read(activeClientLocationProvider.notifier)
      .confirmLocation(location);
  refreshLocationDependents(ref);
}

Future<void> clearClientLocation(WidgetRef ref) async {
  await ref.read(activeClientLocationProvider.notifier).clearLocation();
  refreshLocationDependents(ref);
}

Future<ClientLocation?> useCurrentClientLocation(WidgetRef ref) async {
  final outcome = await LocationService.resolveCurrentPosition();
  final point = outcome.point;

  if (point == null) {
    throw CurrentClientLocationException(
      message:
          outcome.failureMessage ??
          'No se pudo obtener tu ubicación. Intenta de nuevo.',
      shouldOpenSettings: outcome.shouldOpenSettings,
    );
  }

  final label = point.address?.trim().isNotEmpty == true
      ? point.address!.trim()
      : ClientLocationConstants.currentLocationFallbackLabel;

  final location = ClientLocation(
    lat: point.lat,
    lng: point.lng,
    label: label,
    radiusKm: ClientLocationConstants.defaultRadiusKm,
  );

  await confirmClientLocation(ref, location);
  return location;
}

class CurrentClientLocationException implements Exception {
  const CurrentClientLocationException({
    required this.message,
    this.shouldOpenSettings = false,
  });

  final String message;
  final bool shouldOpenSettings;

  @override
  String toString() => message;
}
