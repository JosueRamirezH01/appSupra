
import '../../data/models/auth/auth_payload_model.dart';
import '../../data/models/auth/user_model.dart';

abstract class AuthRepository {
  Future<AuthPayloadModel> login(LoginRequest request);
  Future<AuthPayloadModel> loginWithGoogle(GoogleLoginRequest request);
  Future<AuthPayloadModel> registerClient(RegisterClientRequest request);
  Future<AuthPayloadModel> registerTechnician(RegisterTechnicianRequest request);
  Future<AuthPayloadModel> registerSeller(RegisterSellerRequest request);
  Future<AuthPayloadModel> addTechnicianProfile(AddTechnicianProfileRequest request);
  Future<AuthPayloadModel> addSellerProfile(AddSellerProfileRequest request);
  Future<void> forgotPassword(ForgotPasswordRequest request);
  Future<UserModel> me();
  Future<void> logout();
  Future<AuthPayloadModel> updateClientProfile(UpdateClientProfileRequest request);
  Future<void> restoreSession();
  Future<void> clearSession();
  UserModel? get currentUser;
  bool get isAuthenticated;
}
