import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/app_view.dart';
import '../../../data/models/auth/user_model.dart';
import '../technician/technician_panel_theme.dart';
import 'home_role_chip.dart';

/// AppBar compacto para el panel técnico (sin buscador).
class HomeShellAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const HomeShellAppBar({
    super.key,
    required this.user,
    required this.activeView,
  });

  final UserModel user;
  final AppView activeView;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: TechnicianPanelColors.background,
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Inicio',
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home_outlined,
                    color: TechnicianPanelColors.ink,
                  ),
                ),
                const Spacer(),
                HomeRoleChipButton(
                  user: user,
                  activeView: activeView,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
