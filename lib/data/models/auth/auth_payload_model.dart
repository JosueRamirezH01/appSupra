import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:prueba/data/models/auth/session_model.dart';
import 'package:prueba/data/models/auth/user_model.dart';

part 'auth_payload_model.freezed.dart';
part 'auth_payload_model.g.dart';

@freezed
class AuthPayloadModel with _$AuthPayloadModel {
  const factory AuthPayloadModel({
    required UserModel user,
    required SessionModel session,
  }) = _AuthPayloadModel;

  factory AuthPayloadModel.fromJson(Map<String, dynamic> json) =>
      _$AuthPayloadModelFromJson(json);
}

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

@freezed
class GoogleLoginRequest with _$GoogleLoginRequest {
  const factory GoogleLoginRequest({
    required String idToken,
  }) = _GoogleLoginRequest;

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);
}

@freezed
class RefreshRequest with _$RefreshRequest {
  const factory RefreshRequest({
    required String refreshToken,
  }) = _RefreshRequest;

  factory RefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshRequestFromJson(json);
}

@freezed
class RegisterClientRequest with _$RegisterClientRequest {
  const factory RegisterClientRequest({
    required String email,
    required String password,
  }) = _RegisterClientRequest;

  factory RegisterClientRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterClientRequestFromJson(json);
}

@freezed
class ForgotPasswordRequest with _$ForgotPasswordRequest {
  const factory ForgotPasswordRequest({
    required String email,
  }) = _ForgotPasswordRequest;

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordRequestFromJson(json);
}

@freezed
class UpdateClientProfileRequest with _$UpdateClientProfileRequest {
  const factory UpdateClientProfileRequest({
    String? name,
    String? phone,
    String? profilePhotoUrl,
    String? uploadSessionId,
  }) = _UpdateClientProfileRequest;

  factory UpdateClientProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateClientProfileRequestFromJson(json);
}

@freezed
class AddClientProfileRequest with _$AddClientProfileRequest {
  const factory AddClientProfileRequest({
    String? phone,
    String? address,
  }) = _AddClientProfileRequest;

  factory AddClientProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$AddClientProfileRequestFromJson(json);
}

@freezed
class RegisterTechnicianRequest with _$RegisterTechnicianRequest {
  const factory RegisterTechnicianRequest({
    required String name,
    required String email,
    required String password,
    required String phone,
    required List<int> subcategoryIds,
    required String documentNumber,
    String? specialty,
    String? address,
    @Default('DNI') String documentType,
    List<int>? subSubCategoryIds,
    String? description,
    int? experienceYears,
    String? profilePhotoUrl,
    String? uploadSessionId,
    @Default('independiente') String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
  }) = _RegisterTechnicianRequest;

  factory RegisterTechnicianRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterTechnicianRequestFromJson(json);
}

@freezed
class AddTechnicianProfileRequest with _$AddTechnicianProfileRequest {
  const factory AddTechnicianProfileRequest({
    required List<int> subcategoryIds,
    required String documentNumber,
    required String phone,
    String? specialty,
    String? address,
    @Default('DNI') String documentType,
    List<int>? subSubCategoryIds,
    String? description,
    int? experienceYears,
    String? profilePhotoUrl,
    @Default('independiente') String profileType,
    String? ruc,
    String? businessName,
    String? legalRepresentativeName,
  }) = _AddTechnicianProfileRequest;

  factory AddTechnicianProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$AddTechnicianProfileRequestFromJson(json);
}

@freezed
class RegisterSellerRequest with _$RegisterSellerRequest {
  const factory RegisterSellerRequest({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String businessName,
    required String ruc,
    required String legalRepresentativeName,
    String? address,
    String? description,
    String? logoUrl,
    String? rucDocumentUrl,
  }) = _RegisterSellerRequest;

  factory RegisterSellerRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterSellerRequestFromJson(json);
}

@freezed
class AddSellerProfileRequest with _$AddSellerProfileRequest {
  const factory AddSellerProfileRequest({
    required String businessName,
    required String ruc,
    required String legalRepresentativeName,
    required String phone,
    String? address,
    String? description,
    String? logoUrl,
    String? rucDocumentUrl,
  }) = _AddSellerProfileRequest;

  factory AddSellerProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$AddSellerProfileRequestFromJson(json);
}
