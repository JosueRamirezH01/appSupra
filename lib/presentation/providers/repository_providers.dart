import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/dio_client.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../data/datasources/admin_remote_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/categories_remote_datasource.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/datasources/sellers_remote_datasource.dart';
import '../../data/datasources/technicians_remote_datasource.dart';
import '../../data/datasources/uploads_remote_datasource.dart';
import '../../data/datasources/app_version_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/categories_repository_impl.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../data/repositories/sellers_repository_impl.dart';
import '../../data/repositories/technicians_repository_impl.dart';
import '../../data/repositories/uploads_repository_impl.dart';
import '../../data/repositories/app_version_repository.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(AuthRemoteDataSourceRef ref) {
  return AuthRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
CategoriesRemoteDataSource categoriesRemoteDataSource(
  CategoriesRemoteDataSourceRef ref,
) {
  return CategoriesRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
HomeRemoteDataSource homeRemoteDataSource(HomeRemoteDataSourceRef ref) {
  return HomeRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
TechniciansRemoteDataSource techniciansRemoteDataSource(
  TechniciansRemoteDataSourceRef ref,
) {
  return TechniciansRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
SearchRemoteDataSource searchRemoteDataSource(SearchRemoteDataSourceRef ref) {
  return SearchRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
SellersRemoteDataSource sellersRemoteDataSource(SellersRemoteDataSourceRef ref) {
  return SellersRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
AdminRemoteDataSource adminRemoteDataSource(AdminRemoteDataSourceRef ref) {
  return AdminRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
UploadsRemoteDataSource uploadsRemoteDataSource(UploadsRemoteDataSourceRef ref) {
  return UploadsRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
AppVersionRemoteDataSource appVersionRemoteDataSource(
  AppVersionRemoteDataSourceRef ref,
) {
  return AppVersionRemoteDataSource(ref.watch(dioProvider));
}

@Riverpod(keepAlive: true)
AppVersionRepository appVersionRepository(AppVersionRepositoryRef ref) {
  return AppVersionRepository(ref.watch(appVersionRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
AuthRepositoryImpl authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(secureStorageServiceProvider),
  );
}

@Riverpod(keepAlive: true)
CategoriesRepositoryImpl categoriesRepository(CategoriesRepositoryRef ref) {
  return CategoriesRepositoryImpl(ref.watch(categoriesRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
HomeRepositoryImpl homeRepository(HomeRepositoryRef ref) {
  return HomeRepositoryImpl(ref.watch(homeRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
TechniciansRepositoryImpl techniciansRepository(TechniciansRepositoryRef ref) {
  return TechniciansRepositoryImpl(ref.watch(techniciansRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
SearchRepositoryImpl searchRepository(SearchRepositoryRef ref) {
  return SearchRepositoryImpl(ref.watch(searchRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
SellersRepositoryImpl sellersRepository(SellersRepositoryRef ref) {
  return SellersRepositoryImpl(ref.watch(sellersRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
AdminRepositoryImpl adminRepository(AdminRepositoryRef ref) {
  return AdminRepositoryImpl(ref.watch(adminRemoteDataSourceProvider));
}

@Riverpod(keepAlive: true)
UploadsRepositoryImpl uploadsRepository(UploadsRepositoryRef ref) {
  return UploadsRepositoryImpl(ref.watch(uploadsRemoteDataSourceProvider));
}
