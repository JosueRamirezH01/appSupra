import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../routes/route_paths.dart';
import '../providers/auth/auth_notifier.dart';
import '../widgets/home/home_guest_menu_sheet.dart';
import 'client_shell_destination.dart';

/// Scaffold del cliente con [NavigationBar] inferior (Fase 1).
/// Visible también para invitados; el tab Perfil abre el sheet de cuenta.
class ClientShellScaffold extends ConsumerWidget {
  const ClientShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onDestinationSelected: (index) => _onDestinationSelected(
            context,
            index: index,
            isGuest: isGuest,
          ),
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
