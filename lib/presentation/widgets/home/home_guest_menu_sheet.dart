import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/navigation/auth_navigation.dart';
import '../auth/auth_ui.dart';

/// Menú del chip de cuenta cuando el usuario explora sin sesión.
class HomeGuestMenuSheet extends StatelessWidget {
  const HomeGuestMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
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
                    backgroundColor: const Color(0xFFF1F5F9),
                    child: Icon(
                      Icons.person_outline_rounded,
                      color: AppBrandColors.primaryGreen,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Explorando sin cuenta',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Inicia sesión para guardar datos y ofrecer servicios.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
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
            _GuestActionTile(
              icon: Icons.login_rounded,
              label: 'Iniciar sesión',
              subtitle: 'Email o Google',
              onTap: () {
                Navigator.pop(context);
                openLogin(context);
              },
            ),
            _GuestActionTile(
              icon: Icons.person_add_alt_1_outlined,
              label: 'Crear cuenta de cliente',
              subtitle: 'Para contratar servicios',
              onTap: () {
                Navigator.pop(context);
                openRegisterClient(context);
              },
            ),
            _GuestActionTile(
              icon: Icons.engineering_outlined,
              label: 'Registrarme como técnico',
              subtitle: 'Cuenta nueva con solicitud de verificación',
              onTap: () {
                Navigator.pop(context);
                openRegisterTechnician(context);
              },
            ),
            _GuestActionTile(
              icon: Icons.storefront_outlined,
              label: 'Registrarme como vendedor',
              subtitle: 'Cuenta nueva de negocio con RUC',
              onTap: () {
                Navigator.pop(context);
                openRegisterSeller(context);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _GuestActionTile extends StatelessWidget {
  const _GuestActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppBrandColors.primaryGreen),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 15,
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
