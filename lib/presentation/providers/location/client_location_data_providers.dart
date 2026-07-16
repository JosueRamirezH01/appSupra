import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/dio_client.dart';
import '../../../data/datasources/client_location_local_datasource.dart';
import '../../../data/datasources/client_location_remote_datasource.dart';
import '../../../data/repositories/client_location_repository_impl.dart';
import '../../../domain/repositories/client_location_repository.dart';

part 'client_location_data_providers.g.dart';

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(SharedPreferencesRef ref) async {
  return SharedPreferences.getInstance();
}

@Riverpod(keepAlive: true)
ClientLocationRemoteDataSource clientLocationRemoteDataSource(
  ClientLocationRemoteDataSourceRef ref,
) {
  return ClientLocationRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
Future<ClientLocationRepository> clientLocationRepository(
  ClientLocationRepositoryRef ref,
) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return ClientLocationRepositoryImpl(
    ClientLocationLocalDataSource(prefs),
    ref.watch(clientLocationRemoteDataSourceProvider),
  );
}
