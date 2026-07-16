import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/app_view.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/auth/user_model.dart';
import '../auth/auth_ui.dart';

class HomeRoleMenuSheet extends StatelessWidget {
  const HomeRoleMenuSheet({
    super.key,
    required this.user,
    required this.activeView,
    required this.onSelectView,
    required this.onSettings,
    required this.onLogout,
  });

  final UserModel user;
  final AppView activeView;
  final ValueChanged<AppView> onSelectView;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final switchable = user.parsedAvailableViews
        .where((v) =>
            v == AppView.client ||
            v == AppView.technician ||
            v == AppView.seller)
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: MediaUrlUtils.networkImage(user.profilePhotoUrl),
                  child: user.profilePhotoUrl == null
                      ? Text(
                          user.name.characters.first.toUpperCase(),
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                        )
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.email,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppBrandColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (switchable.length >= 2) ...[
            if (switchable.contains(AppView.client))
              _ModeTile(
                icon: Icons.person_outline_rounded,
                label: 'Modo Cliente',
                selected: activeView == AppView.client,
                onTap: () => onSelectView(AppView.client),
              ),
            if (switchable.contains(AppView.technician))
              _ModeTile(
                icon: Icons.handyman_outlined,
                label: 'Modo Técnico',
                selected: activeView == AppView.technician,
                onTap: () => onSelectView(AppView.technician),
              ),
            if (switchable.contains(AppView.seller))
              _ModeTile(
                icon: Icons.storefront_outlined,
                label: 'Modo Vendedor',
                selected: activeView == AppView.seller,
                onTap: () => onSelectView(AppView.seller),
              ),
            const Divider(height: 1),
          ],
          _ActionTile(
            icon: Icons.person_outline_rounded,
            label: 'Mi cuenta',
            subtitle: 'Nombre, foto y sesión',
            onTap: onSettings,
          ),
          _ActionTile(
            icon: Icons.logout_rounded,
            label: 'Cerrar sesión',
            color: const Color(0xFFDC2626),
            onTap: onLogout,
          ),
          const SizedBox(height: 8),
        ],
        ),
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        selected ? Icons.check_circle_rounded : icon,
        color: selected ? AppBrandColors.primaryGreen : AppBrandColors.textMuted,
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? AppBrandColors.textDark;

    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: resolved),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: resolved,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppBrandColors.textMuted,
              ),
            ),
    );
  }
}
