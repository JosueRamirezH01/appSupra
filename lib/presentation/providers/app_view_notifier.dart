import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/enums/app_view.dart';
import '../../data/models/auth/user_model.dart';
import 'auth/auth_notifier.dart';

part 'app_view_notifier.g.dart';

@Riverpod(keepAlive: true)
class ActiveAppView extends _$ActiveAppView {
  @override
  AppView build() => AppView.client;

  /// Alinea la vista activa con los roles del usuario.
  /// [applyDefaultView] solo en login/inicio de sesión; no en cada refresh de `/auth/me`.
  void syncWithUser(UserModel? user, {bool applyDefaultView = false}) {
    if (user == null) return;

    final available = user.parsedAvailableViews;
    if (available.isEmpty) return;

    if (applyDefaultView) {
      final preferred = AppView.tryParse(user.navigation?.defaultView);
      if (preferred != null && available.contains(preferred)) {
        state = preferred;
        return;
      }
    }

    if (!available.contains(state)) {
      final preferred = AppView.tryParse(user.navigation?.defaultView);
      if (preferred != null && available.contains(preferred)) {
        state = preferred;
        return;
      }
      state = available.first;
    }
  }

  void setView(AppView view) {
    final user = ref.read(authNotifierProvider).valueOrNull;
    final available =
        user?.parsedAvailableViews ?? const [AppView.client];
    if (available.contains(view)) {
      state = view;
    }
  }

  void preferTechnician() => setView(AppView.technician);

  void preferSeller() => setView(AppView.seller);

  void preferClient() => setView(AppView.client);
}
