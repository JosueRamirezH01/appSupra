import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/constants/client_location_constants.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/entities/location_hierarchy_place.dart';
import '../../domain/entities/place_search_result.dart';

class ClientLocationRemoteDataSource {
  ClientLocationRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PlaceSearchResult>> searchPlaces(
    String query, {
    int limit = ClientLocationConstants.maxSearchResults,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.locationsSearch,
        queryParameters: {
          'q': query.trim(),
          'limit': limit,
        },
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      final places = data?['places'] as List<dynamic>?;

      if (places == null) {
        throw AppException.unknown('Respuesta de ubicación inválida');
      }

      return places
          .map((item) {
            final map = item as Map<String, dynamic>;
            final label = map['label'] as String?;
            final lat = (map['lat'] as num?)?.toDouble();
            final lng = (map['lng'] as num?)?.toDouble();
            final id = (map['id'] as num?)?.toInt();

            if (label == null || lat == null || lng == null) {
              throw AppException.unknown('Respuesta de ubicación inválida');
            }

            return PlaceSearchResult(id: id, label: label, lat: lat, lng: lng);
          })
          .toList(growable: false);
    } on DioException catch (error) {
      if (error.error is AppException) {
        throw error.error as AppException;
      }
      rethrow;
    }
  }

  Future<List<LocationHierarchyPlace>> listDepartments() {
    return _listHierarchyPlaces(ApiEndpoints.locationDepartments);
  }

  Future<List<LocationHierarchyPlace>> listProvinces(int departmentId) {
    return _listHierarchyPlaces(
      ApiEndpoints.locationProvinces,
      queryParameters: {'departmentId': departmentId},
    );
  }

  Future<List<LocationHierarchyPlace>> listDistricts(int provinceId) {
    return _listHierarchyPlaces(
      ApiEndpoints.locationDistricts,
      queryParameters: {'provinceId': provinceId},
    );
  }

  Future<List<LocationHierarchyPlace>> _listHierarchyPlaces(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );

      final data = response.data?['data'] as Map<String, dynamic>?;
      final places = data?['places'] as List<dynamic>?;

      if (places == null) {
        throw AppException.unknown('Respuesta de ubicación inválida');
      }

      return places
          .map((item) {
            final map = item as Map<String, dynamic>;
            final name = map['name'] as String?;
            final label = map['label'] as String?;
            final lat = (map['lat'] as num?)?.toDouble();
            final lng = (map['lng'] as num?)?.toDouble();
            final id = (map['id'] as num?)?.toInt();
            final ubigeo = map['ubigeo'] as String?;

            if (id == null || name == null || label == null || lat == null || lng == null) {
              throw AppException.unknown('Respuesta de ubicación inválida');
            }

            return LocationHierarchyPlace(
              id: id,
              name: name,
              label: label,
              lat: lat,
              lng: lng,
              ubigeo: ubigeo,
            );
          })
          .toList(growable: false);
    } on DioException catch (error) {
      if (error.error is AppException) {
        throw error.error as AppException;
      }
      rethrow;
    }
  }
}
