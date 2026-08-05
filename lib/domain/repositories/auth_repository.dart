
import '../../data/models/auth/auth_payload_model.dart';
import '../../data/models/auth/password_reset_models.dart';
import '../../data/models/auth/registration_code_info.dart';
import '../../data/models/auth/user_model.dart';

abstract class AuthRepository {
  Future<AuthPayloadModel> login(LoginRequest request);
  Future<AuthPayloadModel> loginWithGoogle(GoogleLoginRequest request);
  Future<RegistrationCodeInfo> sendRegistrationCode(String email);
  Future<void> cancelRegistrationCode(String email);
  Future<AuthPayloadModel> registerClient(
    RegisterClientRequest request, {
    required String code,
  });
  Future<AuthPayloadModel> registerTechnician(
    RegisterTechnicianRequest request, {
    required String code,
  });
  Future<AuthPayloadModel> registerSeller(
    RegisterSellerRequest request, {
    required String code,
  });
  Future<AuthPayloadModel> addTechnicianProfile(AddTechnicianProfileRequest request);
  Future<AuthPayloadModel> addSellerProfile(AddSellerProfileRequest request);
  Future<RegistrationCodeInfo> sendPasswordResetCode(String email);
  Future<RegistrationCodeInfo> resendPasswordResetCode(String email);
  Future<PasswordResetVerifyResult> verifyPasswordResetCode({
    required String email,
    required String code,
  });
  Future<AuthPayloadModel> resetPassword({
    required String resetToken,
    required String password,
  });
  Future<UserModel> me();
  Future<void> logout();
  Future<AuthPayloadModel> updateClientProfile(UpdateClientProfileRequest request);
  Future<void> restoreSession();
  Future<void> clearSession();
  UserModel? get currentUser;
  bool get isAuthenticated;
}
