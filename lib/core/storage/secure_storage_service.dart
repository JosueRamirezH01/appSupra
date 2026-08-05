import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'secure_storage_service.g.dart';

const _accessTokenKey = 'access_token';
const _refreshTokenKey = 'refresh_token';
const _pendingRegistrationKey = 'pending_registration';

class SecureStorageService {
  SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);

  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);

  /// Registro en curso (incluye contraseña) guardado mientras se verifica el OTP.
  Future<void> savePendingRegistration(String value) =>
      _storage.write(key: _pendingRegistrationKey, value: value);

  Future<String?> getPendingRegistration() =>
      _storage.read(key: _pendingRegistrationKey);

  Future<void> clearPendingRegistration() =>
      _storage.delete(key: _pendingRegistrationKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(SecureStorageServiceRef ref) {
  return SecureStorageService(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
        resetOnError: true,
      ),
    ),
  );
}
