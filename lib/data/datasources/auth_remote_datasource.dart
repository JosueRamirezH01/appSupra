import 'package:dio/dio.dart';

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exception.dart';
import '../models/auth/auth_payload_model.dart';
import '../models/auth/password_reset_models.dart';
import '../models/auth/registration_code_info.dart';
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

  Future<RegistrationCodeInfo> sendRegistrationCode(String email) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerSendCode,
      data: {'email': email},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw AppException.unknown('Respuesta inválida del servidor');
    }
    return RegistrationCodeInfo.fromJson(data);
  }

  Future<void> cancelRegistrationCode(String email) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerCancelCode,
      data: {'email': email},
    );
  }

  Future<AuthPayloadModel> registerClient(
    RegisterClientRequest request, {
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerClient,
      data: {..._withoutNulls(request.toJson()), 'code': code},
    );
    return _parseAuthPayload(response.data);
  }

  Future<AuthPayloadModel> registerTechnician(
    RegisterTechnicianRequest request, {
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerTechnician,
      data: {..._withoutNulls(request.toJson()), 'code': code},
    );
    return _parseAuthPayload(response.data);
  }

  Future<AuthPayloadModel> registerSeller(
    RegisterSellerRequest request, {
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.registerSeller,
      data: {..._withoutNulls(request.toJson()), 'code': code},
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

  Future<RegistrationCodeInfo> sendPasswordResetCode(String email) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw AppException.unknown('Respuesta inválida del servidor');
    }
    return RegistrationCodeInfo.fromJson(data);
  }

  Future<RegistrationCodeInfo> resendPasswordResetCode(String email) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPasswordResend,
      data: {'email': email},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw AppException.unknown('Respuesta inválida del servidor');
    }
    return RegistrationCodeInfo.fromJson(data);
  }

  Future<PasswordResetVerifyResult> verifyPasswordResetCode({
    required String email,
    required String code,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPasswordVerify,
      data: {'email': email, 'code': code},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw AppException.unknown('Respuesta inválida del servidor');
    }
    return PasswordResetVerifyResult.fromJson(data);
  }

  Future<AuthPayloadModel> resetPassword({
    required String resetToken,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.forgotPasswordReset,
      data: {'resetToken': resetToken, 'password': password},
    );
    return _parseAuthPayload(response.data);
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
