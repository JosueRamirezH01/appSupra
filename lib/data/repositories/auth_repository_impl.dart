import '../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth/auth_payload_model.dart';
import '../models/auth/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  UserModel? _currentUser;

  @override
  UserModel? get currentUser => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  Future<void> restoreSession() async {
    final accessToken = await _storage.getAccessToken();
    final refreshToken = await _storage.getRefreshToken();

    if ((accessToken == null || accessToken.isEmpty) &&
        (refreshToken == null || refreshToken.isEmpty)) {
      return;
    }

    try {
      if (accessToken != null && accessToken.isNotEmpty) {
        _currentUser = await _remote.me();
        return;
      }
    } catch (_) {
      // Intenta renovar la sesión con el refresh token.
    }

    if (refreshToken != null && refreshToken.isNotEmpty) {
      try {
        await _refreshTokens(refreshToken);
        _currentUser = await _remote.me();
        return;
      } catch (_) {
        // Continúa al cierre de sesión local.
      }
    }

    _currentUser = null;
    await _storage.clearTokens();
  }

  Future<void> _refreshTokens(String refreshToken) async {
    final session = await _remote.refreshSession(refreshToken);
    await _storage.saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  @override
  Future<void> clearSession() async {
    _currentUser = null;
    await _storage.clearTokens();
  }

  Future<void> _persistSession(AuthPayloadModel payload) async {
    await _storage.saveTokens(
      accessToken: payload.session.accessToken,
      refreshToken: payload.session.refreshToken,
    );
    _currentUser = payload.user;
  }

  @override
  Future<AuthPayloadModel> login(LoginRequest request) async {
    final payload = await _remote.login(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<AuthPayloadModel> loginWithGoogle(GoogleLoginRequest request) async {
    final payload = await _remote.loginWithGoogle(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<AuthPayloadModel> registerClient(RegisterClientRequest request) async {
    final payload = await _remote.registerClient(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<AuthPayloadModel> registerTechnician(
    RegisterTechnicianRequest request,
  ) async {
    final payload = await _remote.registerTechnician(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<AuthPayloadModel> registerSeller(RegisterSellerRequest request) async {
    final payload = await _remote.registerSeller(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<AuthPayloadModel> addTechnicianProfile(
    AddTechnicianProfileRequest request,
  ) async {
    final payload = await _remote.addTechnicianProfile(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<AuthPayloadModel> addSellerProfile(
    AddSellerProfileRequest request,
  ) async {
    final payload = await _remote.addSellerProfile(request);
    await _persistSession(payload);
    return payload;
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequest request) async =>
      _remote.forgotPassword(request);

  @override
  Future<UserModel> me() async {
    _currentUser = await _remote.me();
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    try {
      await _remote.logout();
    } finally {
      await clearSession();
    }
  }

  @override
  Future<AuthPayloadModel> updateClientProfile(
    UpdateClientProfileRequest request,
  ) async {
    final payload = await _remote.updateClientProfile(request);
    await _persistSession(payload);
    return payload;
  }
}
