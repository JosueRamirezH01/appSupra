import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../data/models/auth/auth_payload_model.dart';
import '../../../data/models/auth/password_reset_models.dart';
import '../../../data/models/auth/pending_registration.dart';
import '../../../data/models/auth/registration_code_info.dart';
import '../../../data/models/auth/user_model.dart';
import '../repository_providers.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<UserModel?> build() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.restoreSession();
    return repo.currentUser;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload = await ref.read(authRepositoryProvider).login(
            LoginRequest(email: email, password: password),
          );
      return payload.user;
    });
  }

  Future<void> loginWithGoogle(String idToken) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload = await ref.read(authRepositoryProvider).loginWithGoogle(
            GoogleLoginRequest(idToken: idToken),
          );
      return payload.user;
    });
  }

  /// Paso 1 del registro: envía el código al correo y guarda el registro en
  /// curso localmente (secure storage). NO crea la cuenta ni cambia la sesión.
  Future<RegistrationCodeInfo> beginRegistration({
    required String role,
    required String email,
    required Map<String, dynamic> payload,
  }) async {
    final info = await ref.read(authRepositoryProvider).sendRegistrationCode(email);
    final pending = PendingRegistration(role: role, email: email, payload: payload);
    await ref
        .read(secureStorageServiceProvider)
        .savePendingRegistration(pending.encode());
    return info;
  }

  /// Reenvía el código al correo del registro en curso.
  Future<RegistrationCodeInfo> resendRegistrationCode() async {
    final pending = await _readPendingRegistrationOrThrow();
    return ref.read(authRepositoryProvider).sendRegistrationCode(pending.email);
  }

  /// Paso 2: valida el código y crea la cuenta con los datos guardados.
  Future<void> confirmRegistration(String code) async {
    final pending = await _readPendingRegistrationOrThrow();
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final user = await _dispatchRegister(pending, code);
      await ref.read(secureStorageServiceProvider).clearPendingRegistration();
      return user;
    });
  }

  /// Cancela el registro en curso: invalida el código en el backend (para poder
  /// empezar de cero de inmediato) y borra los datos locales.
  Future<void> cancelRegistration() async {
    final pending = await readPendingRegistration();
    if (pending != null) {
      try {
        await ref
            .read(authRepositoryProvider)
            .cancelRegistrationCode(pending.email);
      } catch (_) {
        // Best-effort: aunque falle la red, limpiamos el registro local.
      }
    }
    await ref.read(secureStorageServiceProvider).clearPendingRegistration();
  }

  Future<PendingRegistration?> readPendingRegistration() async {
    final raw =
        await ref.read(secureStorageServiceProvider).getPendingRegistration();
    if (raw == null || raw.isEmpty) return null;
    try {
      return PendingRegistration.decode(raw);
    } catch (_) {
      return null;
    }
  }

  Future<PendingRegistration> _readPendingRegistrationOrThrow() async {
    final pending = await readPendingRegistration();
    if (pending == null) {
      throw AppException.unknown('No hay un registro pendiente. Vuelve a intentarlo.');
    }
    return pending;
  }

  Future<UserModel> _dispatchRegister(
    PendingRegistration pending,
    String code,
  ) async {
    final repo = ref.read(authRepositoryProvider);
    switch (pending.role) {
      case 'tecnico':
        final res = await repo.registerTechnician(
          RegisterTechnicianRequest.fromJson(pending.payload),
          code: code,
        );
        return res.user;
      case 'vendedor':
        final res = await repo.registerSeller(
          RegisterSellerRequest.fromJson(pending.payload),
          code: code,
        );
        return res.user;
      default:
        final res = await repo.registerClient(
          RegisterClientRequest.fromJson(pending.payload),
          code: code,
        );
        return res.user;
    }
  }

  Future<void> addTechnicianProfile(AddTechnicianProfileRequest request) async {
    await _runProfileAction(() async {
      final payload =
          await ref.read(authRepositoryProvider).addTechnicianProfile(request);
      return payload.user;
    });
  }

  Future<void> addSellerProfile(AddSellerProfileRequest request) async {
    await _runProfileAction(() async {
      final payload =
          await ref.read(authRepositoryProvider).addSellerProfile(request);
      return payload.user;
    });
  }

  /// Mantiene la sesión activa si el usuario ya estaba logueado y la acción falla.
  Future<void> _runProfileAction(
    Future<UserModel> Function() action,
  ) async {
    final previousUser = state.valueOrNull;
    state = const AsyncValue.loading();
    try {
      final user = await action();
      state = AsyncValue.data(user);
    } catch (e, st) {
      if (previousUser != null) {
        state = AsyncValue.data(previousUser);
      } else {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }

  Future<RegistrationCodeInfo> sendPasswordResetCode(String email) {
    return ref.read(authRepositoryProvider).sendPasswordResetCode(email);
  }

  Future<RegistrationCodeInfo> resendPasswordResetCode(String email) {
    return ref.read(authRepositoryProvider).resendPasswordResetCode(email);
  }

  Future<PasswordResetVerifyResult> verifyPasswordResetCode({
    required String email,
    required String code,
  }) {
    return ref.read(authRepositoryProvider).verifyPasswordResetCode(
          email: email,
          code: code,
        );
  }

  /// Define la nueva clave y abre sesión (como un login).
  Future<void> resetPassword({
    required String resetToken,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload = await ref.read(authRepositoryProvider).resetPassword(
            resetToken: resetToken,
            password: password,
          );
      return payload.user;
    });
  }

  Future<void> refreshProfile() async {
    final user = await ref.read(authRepositoryProvider).me();
    state = AsyncValue.data(user);
  }

  Future<void> updateClientProfile(UpdateClientProfileRequest request) async {
    await _runProfileAction(() async {
      final payload =
          await ref.read(authRepositoryProvider).updateClientProfile(request);
      return payload.user;
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }

  Future<void> clearSession() async {
    await ref.read(authRepositoryProvider).clearSession();
    state = const AsyncValue.data(null);
  }

  /// Sesión inválida detectada por el interceptor HTTP (sin tocar el repo vía Dio).
  void markSessionExpired() {
    state = const AsyncValue.data(null);
  }
}

@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  final auth = ref.watch(authNotifierProvider);
  return auth.maybeWhen(data: (user) => user != null, orElse: () => false);
}

@riverpod
bool isAdmin(IsAdminRef ref) {
  final auth = ref.watch(authNotifierProvider);
  return auth.maybeWhen(
    data: (user) => user?.isAdmin ?? false,
    orElse: () => false,
  );
}
