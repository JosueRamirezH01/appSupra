import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/common/pagination_model.dart';
import '../models/technicians/contact_lead_model.dart';
import '../models/technicians/technician_activity_model.dart';
import '../models/technicians/technician_performance_model.dart';
import '../models/technicians/technician_model.dart';

class TechniciansRemoteDataSource {
  TechniciansRemoteDataSource(this._dio);

  final Dio _dio;

  Future<
    ({List<TechnicianPublicModel> technicians, PaginationModel pagination})
  >
  getTechnicians(TechniciansQuery query) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicians,
      queryParameters: {
        'page': query.page,
        'limit': query.limit,
        if (query.categoryId != null) 'categoryId': query.categoryId,
        if (query.subcategoryId != null) 'subcategoryId': query.subcategoryId,
        if (query.subSubCategoryId != null)
          'subSubCategoryId': query.subSubCategoryId,
        if (query.prioritizeSubSubCategoryId != null)
          'prioritizeSubSubCategoryId': query.prioritizeSubSubCategoryId,
        if (query.search != null && query.search!.isNotEmpty)
          'search': query.search,
        if (query.lat != null) 'lat': query.lat,
        if (query.lng != null) 'lng': query.lng,
        if (query.lat != null && query.lng != null) 'radiusKm': query.radiusKm,
      },
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) throw AppException.unknown('Respuesta inválida');

    final list = (data['technicians'] as List<dynamic>)
        .map((e) => TechnicianPublicModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagination = PaginationModel.fromJson(
      data['pagination'] as Map<String, dynamic>,
    );

    return (technicians: list, pagination: pagination);
  }

  Future<List<TechnicianPublicModel>> getHomeTechnicians({
    double? lat,
    double? lng,
    int? radiusKm,
  }) async {
    final hasLocation = lat != null && lng != null;
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.homeTechnicians,
      queryParameters: {
        if (hasLocation) 'lat': lat,
        if (hasLocation) 'lng': lng,
        if (hasLocation && radiusKm != null) 'radiusKm': radiusKm,
      },
    );

    final data = response.data?['data'] as Map<String, dynamic>?;
    final technicians = data?['technicians'] as List<dynamic>?;
    if (technicians == null) {
      throw AppException.unknown('Respuesta inválida');
    }

    return technicians
        .map(
          (item) =>
              TechnicianPublicModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<TechnicianPublicModel> getTechnician(int userId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technician(userId),
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final technician = data?['technician'] as Map<String, dynamic>?;
    if (technician == null) throw AppException.unknown('Técnico no encontrado');
    return TechnicianPublicModel.fromJson(technician);
  }

  Future<TechnicianContactLeadResult> submitContactLead({
    required int technicianUserId,
    required SubmitTechnicianContactRequest request,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.technicianContacts(technicianUserId),
      data: request.toJson(),
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final contact = data?['contact'] as Map<String, dynamic>?;
    if (contact == null) {
      throw AppException.unknown('No se pudo registrar el contacto');
    }
    return TechnicianContactLeadResult.fromJson(contact);
  }

  Future<TechnicianContactLeadsPageModel> getMyContactLeads({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianContactsMe,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw AppException.unknown('No se pudieron cargar los contactos');
    }
    return TechnicianContactLeadsPageModel.fromJson(data);
  }

  Future<TechnicianActivityStatsModel> getMyActivityStats() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianActivityMe,
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final stats = data?['stats'] as Map<String, dynamic>?;
    if (stats == null) {
      throw AppException.unknown('No se pudieron cargar las métricas');
    }
    return TechnicianActivityStatsModel.fromJson(stats);
  }

  Future<TechnicianPerformanceReportModel> getMyPerformanceReport({
    required String period,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianPerformanceMe,
      queryParameters: {'period': period},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final report = data?['report'] as Map<String, dynamic>?;
    if (report == null) {
      throw AppException.unknown('No se pudo cargar el rendimiento');
    }
    return TechnicianPerformanceReportModel.fromJson(report);
  }

  Future<RecordTechnicianProfileViewResult> recordProfileView({
    required int technicianUserId,
    required String viewerKey,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.technicianProfileViews(technicianUserId),
      data: {'viewerKey': viewerKey},
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
    return RecordTechnicianProfileViewResult.fromJson(data);
  }

  Future<TechnicianApplicationModel> getMyProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianProfileMe,
    );
    return _parseTechnicianPayload(response.data, key: 'profile');
  }

  Future<TechnicianApplicationModel> getMyApplication() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianApplicationMe,
    );
    return _parseTechnicianPayload(response.data, key: 'application');
  }

  Future<TechnicianApplicationModel> updateMyProfile(
    UpdateTechnicianProfileRequest request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.technicianProfileMe,
      data: _sanitizeProfilePayload(request),
    );
    return _parseTechnicianPayload(response.data, key: 'profile');
  }

  Future<TechnicianApplicationModel> submitVerification(
    SubmitTechnicianVerificationRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.technicianVerificationMe,
      data: _sanitizeVerificationPayload(request),
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final application = data?['application'] as Map<String, dynamic>?;
    if (application == null) {
      throw AppException.unknown('No se pudo enviar la verificación');
    }
    return TechnicianApplicationModel.fromJson(application);
  }

  Future<TechnicianApplicationModel> submitCertification(
    SubmitTechnicianCertificationRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.technicianCertificationMe,
      data: Map<String, dynamic>.from(request.toJson())
        ..removeWhere((_, value) => value == null),
    );
    return _parseTechnicianPayload(response.data, key: 'profile');
  }

  Future<TechnicianApplicationModel> suggestService({
    required int subcategoryId,
    required String proposedName,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.technicianSuggestService,
      data: {
        'subcategoryId': subcategoryId,
        'proposedName': proposedName.trim(),
      },
    );
    return _parseTechnicianPayload(response.data, key: 'profile');
  }

  Future<TechnicianApplicationModel> removeServiceSuggestion(
    int suggestionId,
  ) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      ApiEndpoints.technicianRemoveServiceSuggestion(suggestionId),
    );
    return _parseTechnicianPayload(response.data, key: 'profile');
  }

  Future<TechnicianSubSubCategoryModel> getMyService(
    int subSubCategoryId,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianServiceMe(subSubCategoryId),
    );
    return _parseServicePayload(response.data);
  }

  Future<TechnicianSubSubCategoryModel> updateMyService(
    int subSubCategoryId,
    UpdateTechnicianServiceRequest request,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      ApiEndpoints.technicianServiceMe(subSubCategoryId),
      data: _sanitizeServicePayload(request),
    );
    return _parseServicePayload(response.data);
  }

  Future<TechnicianSubSubCategoryModel> getPublicService(
    int userId,
    int subSubCategoryId,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.technicianPublicService(userId, subSubCategoryId),
    );
    return _parseServicePayload(response.data);
  }

  Map<String, dynamic> _sanitizeProfilePayload(
    UpdateTechnicianProfileRequest request,
  ) {
    final payload = Map<String, dynamic>.from(request.toJson())
      ..removeWhere((_, value) => value == null);
    _sanitizeWorkPhotosList(payload);
    return payload;
  }

  Map<String, dynamic> _sanitizeVerificationPayload(
    SubmitTechnicianVerificationRequest request,
  ) {
    final payload = Map<String, dynamic>.from(request.toJson())
      ..removeWhere((_, value) => value == null);
    _sanitizeWorkPhotosList(payload);
    return payload;
  }

  void _sanitizeWorkPhotosList(Map<String, dynamic> payload) {
    final workPhotos = payload['workPhotos'];
    if (workPhotos is! List) return;

    payload['workPhotos'] = workPhotos
        .map(_workPhotoItemToMap)
        .whereType<Map<String, dynamic>>()
        .where((item) {
          final imageUrl = item['imageUrl'];
          return imageUrl is String && imageUrl.trim().isNotEmpty;
        })
        .toList();
  }

  Map<String, dynamic>? _workPhotoItemToMap(dynamic item) {
    final Map<String, dynamic> map;
    if (item is WorkPhotoInputModel || item is WorkPhotoSubmitRequest) {
      map = Map<String, dynamic>.from(item.toJson());
    } else if (item is Map) {
      map = Map<String, dynamic>.from(item);
    } else {
      return null;
    }

    map.removeWhere((_, value) => value == null);
    return map;
  }

  TechnicianApplicationModel _parseTechnicianPayload(
    Map<String, dynamic>? json, {
    required String key,
  }) {
    final data = json?['data'] as Map<String, dynamic>?;
    final payload = data?[key] as Map<String, dynamic>?;
    if (payload == null) {
      throw AppException.unknown('Perfil no disponible');
    }
    return TechnicianApplicationModel.fromJson(payload);
  }

  Map<String, dynamic> _sanitizeServicePayload(
    UpdateTechnicianServiceRequest request,
  ) {
    final payload = Map<String, dynamic>.from(request.toJson())
      ..removeWhere((_, value) => value == null);
    _sanitizeWorkPhotosList(payload);
    // No forzar workPhotos: [] — si se omite, el backend no toca el portafolio.
    return payload;
  }

  TechnicianSubSubCategoryModel _parseServicePayload(
    Map<String, dynamic>? json,
  ) {
    final data = json?['data'] as Map<String, dynamic>?;
    final service = data?['service'] as Map<String, dynamic>?;
    if (service == null) {
      throw AppException.unknown('Servicio no disponible');
    }
    return TechnicianSubSubCategoryModel.fromJson(service);
  }
}
