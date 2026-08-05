import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/app_version/app_version_model.dart';

class AppVersionRemoteDataSource {
  AppVersionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AppVersionPolicyModel> fetchPolicy({String platform = 'android'}) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.appVersion,
      queryParameters: {'platform': platform},
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    final policy = data?['policy'] as Map<String, dynamic>?;
    if (policy == null) {
      throw AppException.unknown('No se pudo obtener la política de versión');
    }

    return AppVersionPolicyModel.fromJson(policy);
  }
}
