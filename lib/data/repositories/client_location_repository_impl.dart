import '../../domain/entities/client_location.dart';
import '../../domain/entities/place_search_result.dart';
import '../../domain/repositories/client_location_repository.dart';
import '../datasources/client_location_local_datasource.dart';
import '../datasources/client_location_remote_datasource.dart';

class ClientLocationRepositoryImpl implements ClientLocationRepository {
  ClientLocationRepositoryImpl(this._local, this._remote);

  final ClientLocationLocalDataSource _local;
  final ClientLocationRemoteDataSource _remote;

  @override
  Future<ClientLocation?> getSavedLocation() => _local.readActive();

  @override
  Future<void> saveLocation(ClientLocation location) =>
      _local.writeActive(location);

  @override
  Future<void> clearLocation() => _local.clearActive();

  @override
  Future<List<PlaceSearchResult>> searchPlaces(String query) =>
      _remote.searchPlaces(query);
}
