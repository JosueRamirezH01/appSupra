import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/route_paths.dart';
import '../../widgets/auth/auth_ui.dart';

class RegisterTypeScreen extends StatelessWidget {
  const RegisterTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthFlowScaffold(
      title: '¿Cómo quieres usar la app?',
      subtitle:
          'Elige el tipo de cuenta. Siempre podrás solicitar otro perfil más adelante.',
      onBack: () => context.pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthOptionCard(
            icon: Icons.person_outline_rounded,
            title: 'Quiero contratar servicios',
            subtitle:
                'Registro como cliente para buscar técnicos verificados.',
            onTap: () => context.push(RoutePaths.registerClient),
          ),
          const SizedBox(height: 14),
          AuthOptionCard(
            icon: Icons.engineering_outlined,
            title: 'Quiero ofrecer servicios',
            subtitle:
                'Registro como técnico. Tu solicitud será revisada por un administrador.',
            highlighted: true,
            onTap: () => context.push(RoutePaths.registerTechnician),
          ),
          const SizedBox(height: 14),
          AuthOptionCard(
            icon: Icons.storefront_outlined,
            title: 'Quiero vender productos',
            subtitle:
                'Registro como negocio con RUC. También tendrás perfil de cliente.',
            onTap: () => context.push(RoutePaths.registerSeller),
          ),
        ],
      ),
    );
  }
}
