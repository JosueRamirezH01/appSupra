import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth/auth_notifier.dart';
import '../../widgets/technician/technician_owner_public_profile.dart';

/// Perfil público editable del técnico (misma vista que ven los clientes).
class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(authNotifierProvider).valueOrNull?.id;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Inicia sesión para ver tu perfil')),
      );
    }

    return TechnicianOwnerPublicProfile(userId: userId);
  }
}
