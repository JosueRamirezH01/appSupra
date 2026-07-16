import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/auth/auth_payload_model.dart';
import '../models/auth/session_model.dart';
import '../models/auth/user_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthPayloadModel> login(LoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return _parseAuthPayload(response.data);
  }

  Future<AuthPayloadModel> loginWithGoogle(GoogleLoginRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.googleLogin,
      data: request.toJson(),
    );
    return _parseAuthPayload(response.data);
  }

  Future<SessionModel> refreshSession(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.refresh,
      data: {'refreshToken': refreshToken},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    final session = data?['session'] as Map<String, dynamic>?;
    if (session == null) {
      throw AppException.unauthorized();
    }
    return SessionModel.fromJson(session);
  }

  Future<AuthPayloadModel> registerClient(RegisterClientRequest request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerClient,
      data: _withoutNulls(request.toJson()),
    );
    return _parseAuthPayload(response.data);
  }

  Future<AuthPayloadModel> registerTechnician(
    RegisterTechnicianRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerTechnician,
      data: _withoutNulls(request.toJson()),
    );
    return _parseAuthPayload(response.data);
  }

  Future<AuthPayloadModel> registerSeller(
    RegisterSellerRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerSeller,
      data: _withoutNulls(request.toJson()),
    );
    return _parseAuthPayload(response.data);
  }

  Map<String, dynamic> _withoutNulls(Map<String, dynamic> json) {
    return Map<String, dynamic>.fromEntries(
      json.entries.where((entry) => entry.value != null),
    );
  }

  Future<AuthPayloadModel> addTechnicianProfile(
    AddTechnicianProfileRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.profileTechnician,
      data: _withoutNulls(request.toJson()),
    );
    return _parseAuthPayload(response.data);
  }

  Future<AuthPayloadModel> addSellerProfile(
    AddSellerProfileRequest request,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.profileSeller,
      data: _withoutNulls(request.toJson()),
    );
    return _parseAuthPayload(response.data);
  }

  Future<void> forgotPassword(ForgotPasswordRequest request) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: request.toJson(),
    );
  }

  Future<UserModel> me() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
    final data = response.data?['data'] as Map<String, dynamic>?;
    final user = data?['user'] as Map<String, dynamic>?;
    if (user == null) throw AppException.unknown('Perfil no disponible');
    return UserModel.fromJson(user);
  }

  Future<void> logout() async {
    await _dio.post<void>(ApiEndpoints.logout);
  }

  Future<AuthPayloadModel> updateClientProfile(
    UpdateClientProfileRequest request,
  ) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.profileClient,
      data: _withoutNulls(request.toJson()),
    );
    return _parseAuthPayload(response.data);
  }

  AuthPayloadModel _parseAuthPayload(Map<String, dynamic>? json) {
    final data = json?['data'] as Map<String, dynamic>?;
    if (data == null) throw AppException.unknown('Respuesta inválida del servidor');
    return AuthPayloadModel.fromJson(data);
  }
}
