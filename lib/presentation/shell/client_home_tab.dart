import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/enums/app_view.dart';
import '../../core/utils/navigation_utils.dart';
import '../../routes/route_paths.dart';
import '../providers/app_view_notifier.dart';
import '../providers/auth/auth_notifier.dart';
import '../screens/home/client_home_screen.dart';
import '../widgets/common_widgets.dart';
import '../widgets/technician/technician_panel_theme.dart';

/// Pestaña Inicio del shell cliente.
class ClientHomeTab extends ConsumerStatefulWidget {
  const ClientHomeTab({super.key});

  @override
  ConsumerState<ClientHomeTab> createState() => _ClientHomeTabState();
}

class _ClientHomeTabState extends ConsumerState<ClientHomeTab> {
  bool _handledActivationToast = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncActiveViewOnEntry();
      _maybeShowActivationToast();
      _maybeRedirectToPanel();
    });
  }

  void _syncActiveViewOnEntry() {
    final user = ref.read(authNotifierProvider).valueOrNull;
    final uri = GoRouterState.of(context).uri;
    final notifier = ref.read(activeAppViewProvider.notifier);

    if (uri.queryParameters['sellerVerificationSubmitted'] == '1') {
      notifier.preferSeller();
      return;
    }

    if (uri.queryParameters['technicianActivated'] == '1') {
      notifier.preferTechnician();
      return;
    }

    if (user != null) {
      notifier.syncWithUser(user, applyDefaultView: true);
    }
  }

  void _maybeRedirectToPanel() {
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return;

    final uri = GoRouterState.of(context).uri;
    final activeView = ref.read(activeAppViewProvider);
    final shouldPreferPanel = uri.queryParameters['sellerVerificationSubmitted'] == '1' ||
        uri.queryParameters['technicianActivated'] == '1';

    final resolved = resolveActiveView(user, activeView);
    if (resolved != AppView.client || shouldPreferPanel) {
      if (!mounted) return;
      final query = uri.query.isEmpty ? '' : '?${uri.query}';
      context.go('${RoutePaths.panel}$query');
    }
  }

  void _maybeShowActivationToast() {
    if (_handledActivationToast || !mounted) return;

    final uri = GoRouterState.of(context).uri;
    final technicianActivated =
        uri.queryParameters['technicianActivated'] == '1';
    final sellerVerificationSubmitted =
        uri.queryParameters['sellerVerificationSubmitted'] == '1';

    if (!technicianActivated && !sellerVerificationSubmitted) return;

    _handledActivationToast = true;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          technicianActivated
              ? 'Perfil técnico activo. Ya puedes aparecer en búsquedas.'
              : 'Verificación enviada. Ya puedes armar tu catálogo desde el panel.',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: technicianActivated
            ? const Color(0xFF0D9488)
            : TechnicianPanelColors.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final activeView = ref.watch(activeAppViewProvider);

    return auth.when(
      loading: () => const LoadingView(message: 'Cargando sesión...'),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(authNotifierProvider),
      ),
      data: (user) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            top: false,
            child: ClientHomeScreen(
              user: user,
              activeView: user == null ? AppView.client : activeView,
            ),
          ),
        );
      },
    );
  }
}
