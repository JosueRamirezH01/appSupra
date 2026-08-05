import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../routes/route_paths.dart';
import '../providers/auth/auth_notifier.dart';
import '../providers/home/home_refresh_coordinator.dart';
import '../widgets/home/home_guest_menu_sheet.dart';
import 'client_shell_destination.dart';

/// Scaffold del cliente con [NavigationBar] inferior (Fase 1).
/// Visible también para invitados; el tab Perfil abre el sheet de cuenta.
class ClientShellScaffold extends ConsumerStatefulWidget {
  const ClientShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<ClientShellScaffold> createState() =>
      _ClientShellScaffoldState();
}

class _ClientShellScaffoldState extends ConsumerState<ClientShellScaffold>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  StatefulNavigationShell get navigationShell => widget.navigationShell;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_isHomeVisible) {
        unawaited(_ensureHomeFreshSilently());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      _backgroundedAt ??= DateTime.now();
      return;
    }

    if (state != AppLifecycleState.resumed) return;

    final backgroundedAt = _backgroundedAt;
    _backgroundedAt = null;
    if (backgroundedAt == null ||
        DateTime.now().difference(backgroundedAt) <
            const Duration(seconds: 30) ||
        !_isHomeVisible) {
      return;
    }

    unawaited(_ensureHomeFreshSilently());
  }

  bool get _isHomeVisible {
    if (!mounted || navigationShell.currentIndex != 0) return false;
    return GoRouterState.of(context).uri.path == RoutePaths.home;
  }

  Future<void> _ensureHomeFreshSilently() async {
    try {
      await ref.read(homeRefreshCoordinatorProvider).ensureFresh();
    } catch (_) {
      // Cada sección conserva y presenta su propio estado de error.
    }
  }

  void _openGuestAccountSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HomeGuestMenuSheet(),
    );
  }

  void _onDestinationSelected(
    BuildContext context, {
    required int index,
    required bool isGuest,
  }) {
    final destination = ClientShellDestination.values[index];

    if (destination == ClientShellDestination.profile) {
      if (isGuest) {
        _openGuestAccountSheet(context);
        return;
      }
      context.go(RoutePaths.clientSettings);
      return;
    }

    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );

    if (destination == ClientShellDestination.home) {
      unawaited(_ensureHomeFreshSilently());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    final isGuest = user == null;
    final selectedIndex = navigationShell.currentIndex.clamp(0, 3);

    return Scaffold(
      backgroundColor: AppBrandColors.scaffoldBackground,
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 68,
          backgroundColor: Colors.white,
          indicatorColor: AppBrandColors.primaryGreen.withValues(alpha: 0.16),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              color: selected
                  ? const Color(0xFF166534)
                  : AppBrandColors.textMuted,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: selected
                  ? AppBrandColors.primaryGreen
                  : AppBrandColors.textMuted,
              size: 22,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) =>
              _onDestinationSelected(context, index: index, isGuest: isGuest),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Inicio',
            ),
            NavigationDestination(
              icon: Icon(Icons.handyman_outlined),
              selectedIcon: Icon(Icons.handyman_rounded),
              label: 'Técnicos',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded),
              label: 'Productos',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
