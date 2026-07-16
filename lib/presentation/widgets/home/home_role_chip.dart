import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import '../../../core/utils/navigation_utils.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../auth/auth_ui.dart';
import 'home_guest_menu_sheet.dart';
import 'home_layout_metrics.dart';
import 'home_role_menu_sheet.dart';

class HomeRoleChipButton extends ConsumerWidget {
  const HomeRoleChipButton({
    super.key,
    required this.user,
    required this.activeView,
    this.height = 46,
  });

  final UserModel? user;
  final AppView activeView;
  final double height;

  bool get _isGuest => user == null;

  void _openMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        if (_isGuest) {
          return const HomeGuestMenuSheet();
        }

        final loggedUser = user!;
        return HomeRoleMenuSheet(
          user: loggedUser,
          activeView: activeView,
          onSelectView: (view) async {
            if (view == AppView.technician && loggedUser.hasTechnicianProfile) {
              final profile =
                  await ref.read(myTechnicianProfileProvider.future);
              if (!sheetContext.mounted) return;
              if (!profile.hasServiceArea) {
                Navigator.pop(sheetContext);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Primero configura dónde atiendes.',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                );
                context.push(RoutePaths.technicianActivateLocation);
                return;
              }
            }

            ref.read(activeAppViewProvider.notifier).setView(view);
            Navigator.pop(sheetContext);
            if (!context.mounted) return;
            context.go(rootPathForView(view));
          },
          onSettings: () {
            Navigator.pop(sheetContext);
            context.go(RoutePaths.clientSettings);
          },
          onLogout: () async {
            Navigator.pop(sheetContext);
            await ref.read(authNotifierProvider.notifier).logout();
            ref.read(activeAppViewProvider.notifier).preferClient();
            if (context.mounted) context.go(RoutePaths.home);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTechnician = !_isGuest && activeView == AppView.technician;
    final isSeller = !_isGuest && activeView == AppView.seller;
    final borderColor = isTechnician
        ? const Color(0xFF8B5CF6)
        : isSeller
            ? const Color(0xFFF59E0B)
            : AppBrandColors.primaryGreen;
    final icon = _isGuest
        ? Icons.person_outline_rounded
        : isTechnician
            ? Icons.handyman_outlined
            : isSeller
                ? Icons.storefront_outlined
                : Icons.person_outline_rounded;
    final label = _isGuest ? 'Cuenta' : activeView.label;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openMenu(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: height,
          constraints: BoxConstraints(
            maxWidth: HomeLayoutMetrics.isCompactScreen(context) ? 96 : 112,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            color: Colors.white,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 22, color: borderColor),
              const SizedBox(width: 2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    color: AppBrandColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppBrandColors.textDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
