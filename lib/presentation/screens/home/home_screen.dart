import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/seller_onboarding_status.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/home_shell_app_bar.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import 'seller_home_screen.dart';
import 'technician_home_screen.dart';

/// Panel de técnico, vendedor o administrador (`/panel`).
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _handledActivationToast = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncActiveViewOnEntry();
      _maybeShowActivationToast();
    });
  }

  void _syncActiveViewOnEntry() {
    final user = ref.read(authNotifierProvider).valueOrNull;
    final uri = GoRouterState.of(context).uri;
    final notifier = ref.read(activeAppViewProvider.notifier);
    final currentView = ref.read(activeAppViewProvider);

    if (uri.queryParameters['sellerVerificationSubmitted'] == '1') {
      notifier.preferSeller();
      return;
    }

    if (uri.queryParameters['technicianActivated'] == '1') {
      notifier.preferTechnician();
      return;
    }

    final available = user?.parsedAvailableViews ?? const <AppView>[];
    if (user != null &&
        available.contains(currentView) &&
        currentView != AppView.client) {
      return;
    }

    notifier.syncWithUser(user, applyDefaultView: true);
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
    context.go(RoutePaths.panel);
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final activeView = ref.watch(activeAppViewProvider);

    ref.listen(authNotifierProvider, (previous, next) {
      final user = next.valueOrNull;
      if (user != null) {
        ref.read(activeAppViewProvider.notifier).syncWithUser(user);
      } else {
        ref.read(activeAppViewProvider.notifier).preferClient();
      }
    });

    return auth.when(
      loading: () => const AppScaffold(
        title: 'Panel',
        body: LoadingView(message: 'Cargando sesión...'),
      ),
      error: (e, _) => AppScaffold(
        title: 'Panel',
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(authNotifierProvider),
        ),
      ),
      data: (user) {
        if (user == null) {
          return const AppScaffold(
            title: 'Panel',
            body: LoadingView(message: 'Redirigiendo...'),
          );
        }

        final resolvedView = _resolveView(user, activeView);

        if (resolvedView == AppView.client) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.go(RoutePaths.home);
          });
          return const AppScaffold(
            title: 'Panel',
            body: LoadingView(message: 'Redirigiendo...'),
          );
        }

        if (resolvedView == AppView.admin) {
          return AppScaffold(
            title: 'Administración',
            body: _AdminHome(user: user),
          );
        }

        return Scaffold(
          backgroundColor: TechnicianPanelColors.background,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(
              MediaQuery.paddingOf(context).top + 64,
            ),
            child: HomeShellAppBar(
              user: user,
              activeView: resolvedView,
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              top: false,
              child: _PanelBody(user: user, activeView: resolvedView),
            ),
          ),
        );
      },
    );
  }

  AppView _resolveView(UserModel user, AppView activeView) {
    final available = user.parsedAvailableViews;
    if (available.isEmpty) return AppView.client;
    if (available.contains(activeView)) return activeView;
    return user.preferredDefaultView;
  }
}

class _PanelBody extends ConsumerWidget {
  const _PanelBody({
    required this.user,
    required this.activeView,
  });

  final UserModel user;
  final AppView activeView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (activeView == AppView.seller && user.hasSellerProfile) {
      final applicationAsync = ref.watch(mySellerApplicationProvider);
      return applicationAsync.when(
        loading: () => const LoadingView(message: 'Cargando tu negocio...'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(mySellerApplicationProvider),
        ),
        data: (application) {
          if (SellerOnboardingStatus.needsOnboarding(application)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              context.go('${RoutePaths.sellerOnboarding}?resume=1');
            });
            return const LoadingView(message: 'Preparando activación...');
          }
          return SellerHomeScreen(user: user);
        },
      );
    }

    if (activeView == AppView.technician && user.hasTechnicianProfile) {
      final profileAsync = ref.watch(myTechnicianProfileProvider);
      return profileAsync.when(
        loading: () => const LoadingView(message: 'Cargando perfil técnico...'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(myTechnicianProfileProvider),
        ),
        data: (profile) {
          if (!profile.hasServiceArea) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Configura tu ubicación para usar el modo técnico.',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
              ref.read(activeAppViewProvider.notifier).preferClient();
              context.go(RoutePaths.home);
            });
            return const LoadingView(message: 'Redirigiendo...');
          }
          return TechnicianHomeScreen(user: user);
        },
      );
    }

    return switch (activeView) {
      AppView.technician => TechnicianHomeScreen(user: user),
      AppView.seller => SellerHomeScreen(user: user),
      AppView.admin => _AdminHome(user: user),
      AppView.client => const LoadingView(message: 'Redirigiendo...'),
    };
  }
}

class _AdminHome extends StatelessWidget {
  const _AdminHome({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              child: Text(user.name.characters.first.toUpperCase()),
            ),
            title: Text(user.name),
            subtitle: Text('${user.email}\nAdministrador'),
            isThreeLine: true,
          ),
        ),
        const SizedBox(height: 16),
        _AdminTile(
          icon: Icons.category,
          title: 'Categorías',
          subtitle: 'CRUD de categorías, subcategorías y habilidades',
          onTap: () => context.push(RoutePaths.categories),
        ),
        _AdminTile(
          icon: Icons.admin_panel_settings,
          title: 'Solicitudes de técnicos',
          onTap: () => context.push(RoutePaths.adminApplications),
        ),
      ],
    );
  }
}

class _AdminTile extends StatelessWidget {
  const _AdminTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
