import '../entities/client_location.dart';
import '../entities/place_search_result.dart';

abstract class ClientLocationRepository {
  Future<ClientLocation?> getSavedLocation();

  Future<void> saveLocation(ClientLocation location);

  Future<void> clearLocation();

  Future<List<PlaceSearchResult>> searchPlaces(String query);
}
