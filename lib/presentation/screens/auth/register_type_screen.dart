import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/route_paths.dart';
import '../../widgets/auth/auth_ui.dart';

class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: '¿Qué quieres hacer?',
      subtitle: 'Podrás sumar otro perfil después.',
      onBack: () => context.pop(),
      compactLogo: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthOptionCard(
            badge: 'Cliente',
            icon: Icons.person_outline_rounded,
            title: 'Contratar servicios',
            subtitle: 'Buscar y contactar técnicos verificados.',
            onTap: () {
              HapticFeedback.selectionClick();
              context.push(RoutePaths.registerClient);
            },
          ),
          const SizedBox(height: 12),
          AuthOptionCard(
            badge: 'Técnico',
            icon: Icons.engineering_outlined,
            title: 'Ofrecer mis servicios',
            subtitle: 'Publica tu perfil · requiere revisión.',
            onTap: () {
              HapticFeedback.selectionClick();
              context.push(RoutePaths.registerTechnician);
            },
          ),
          const SizedBox(height: 12),
          AuthOptionCard(
            badge: 'Negocio',
            icon: Icons.storefront_outlined,
            title: 'Vender productos',
            subtitle: 'Tienda con RUC · también tendrás perfil cliente.',
            onTap: () {
              HapticFeedback.selectionClick();
              context.push(RoutePaths.registerSeller);
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Técnicos y negocios pasan por verificación antes de aparecer en público.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 11.5,
              height: 1.4,
              color: AppBrandColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
