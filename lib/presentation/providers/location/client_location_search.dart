import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/client_location_constants.dart';
import '../../../domain/entities/place_search_result.dart';
import 'client_location_data_providers.dart';
import 'client_location_provider.dart';

Future<List<GeoSearchResult>> searchClientPlaces(
  WidgetRef ref,
  String query,
) async {
  final places = await ref
      .read(clientLocationRemoteDataSourceProvider)
      .searchPlaces(
        query,
        limit: ClientLocationConstants.maxSearchResults,
      );

  return places
      .map(
        (PlaceSearchResult place) => GeoSearchResult(
          lat: place.lat,
          lng: place.lng,
          label: place.label,
        ),
      )
      .toList(growable: false);
}
