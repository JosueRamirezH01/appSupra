import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_public_profile_mapper.dart';
import '../common_widgets.dart';
import 'client_technician_profile_view.dart';
import 'technician_profile_owner_actions.dart';

/// Perfil público del técnico en modo propietario: misma vista que el cliente + edición.
class TechnicianOwnerPublicProfile extends ConsumerWidget {
  const TechnicianOwnerPublicProfile({
    super.key,
    required this.userId,
    this.showBackButton = true,
  });

  final int userId;
  final bool showBackButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(myTechnicianProfileProvider);

    return profile.when(
      loading: () => const Scaffold(
        body: LoadingView(message: 'Cargando tu perfil...'),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Mi perfil público')),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(myTechnicianProfileProvider),
        ),
      ),
      data: (data) {
        final publicProfile = technicianApplicationToPublic(data);
        final ownerConfig = buildTechnicianProfileOwnerConfig(
          context: context,
          ref: ref,
          profile: data,
          userId: userId,
        );

        return Scaffold(
          backgroundColor: AppBrandColors.scaffoldBackground,
          body: RefreshIndicator(
            color: AppBrandColors.primaryGreen,
            onRefresh: () async {
              ref.invalidate(myTechnicianProfileProvider);
              ref.invalidate(technicianDetailProvider(userId));
              await ref.read(myTechnicianProfileProvider.future);
            },
            child: ClientTechnicianProfileView(
              technician: publicProfile,
              ownerConfig: ownerConfig,
              showBackButton: showBackButton,
            ),
          ),
        );
      },
    );
  }
}
