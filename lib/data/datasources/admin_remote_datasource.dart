import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/technicians/technician_model.dart';

class AdminRemoteDataSource {
  AdminRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TechnicianApplicationModel>> getApplications({
    String? status,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.adminApplications,
      queryParameters: status != null ? {'status': status} : null,
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final list = data?['applications'] as List<dynamic>?;
    if (list == null) throw AppException.unknown('Lista inválida');
    return list
        .map((e) => TechnicianApplicationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<TechnicianApplicationModel> getApplication(int userId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.adminApplication(userId),
    );
    return _parseApplication(response.data);
  }

  Future<TechnicianApplicationModel> approve(int userId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.adminApprove(userId),
    );
    return _parseApplication(response.data);
  }

  Future<TechnicianApplicationModel> reject(
    int userId,
    RejectApplicationRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.adminReject(userId),
      data: request.toJson(),
    );
    return _parseApplication(response.data);
  }

  Future<TechnicianApplicationModel> approveCertification(int userId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.adminApproveCertification(userId),
    );
    return _parseApplication(response.data);
  }

  Future<TechnicianApplicationModel> rejectCertification(int userId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.adminRejectCertification(userId),
    );
    return _parseApplication(response.data);
  }

  TechnicianApplicationModel _parseApplication(Map<String, dynamic>? json) {
    final data = json?['data'] as Map<String, dynamic>?;
    final application = data?['application'] as Map<String, dynamic>?;
    if (application != null) {
      return TechnicianApplicationModel.fromJson(application);
    }
    return _parseProfile(json);
  }

  TechnicianApplicationModel _parseProfile(Map<String, dynamic>? json) {
    final data = json?['data'] as Map<String, dynamic>?;
    final profile = data?['profile'] as Map<String, dynamic>?;
    if (profile == null) throw AppException.unknown('Solicitud no encontrada');
    return TechnicianApplicationModel.fromJson(profile);
  }
}
