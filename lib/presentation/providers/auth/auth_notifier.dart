import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/auth/auth_payload_model.dart';
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

  Future<void> registerClient({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload = await ref.read(authRepositoryProvider).registerClient(
            RegisterClientRequest(
              email: email,
              password: password,
            ),
          );
      return payload.user;
    });
  }

  Future<void> registerTechnician(RegisterTechnicianRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload =
          await ref.read(authRepositoryProvider).registerTechnician(request);
      return payload.user;
    });
  }

  Future<void> registerSeller(RegisterSellerRequest request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final payload =
          await ref.read(authRepositoryProvider).registerSeller(request);
      return payload.user;
    });
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

  Future<void> forgotPassword(String email) async {
    await ref.read(authRepositoryProvider).forgotPassword(
          ForgotPasswordRequest(email: email),
        );
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
