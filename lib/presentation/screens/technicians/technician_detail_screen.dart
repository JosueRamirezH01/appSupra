import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_public_profile_mapper.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/client_technician_profile_view.dart';
import '../../widgets/technician/technician_profile_owner_actions.dart';
import '../../widgets/technician/technician_profile_view_tracker.dart';

class TechnicianDetailScreen extends ConsumerWidget {
  const TechnicianDetailScreen({
    super.key,
    required this.userId,
    this.contextSubSubCategoryId,
  });

  final int userId;
  final int? contextSubSubCategoryId;

  bool _isOwner(WidgetRef ref) {
    final user = ref.watch(authNotifierProvider).valueOrNull;
    return user?.id == userId;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (_isOwner(ref)) {
      final myProfile = ref.watch(myTechnicianProfileProvider);

      return myProfile.when(
        loading: () => const Scaffold(
          body: LoadingView(message: 'Cargando perfil...'),
        ),
        error: (e, _) => Scaffold(
          appBar: AppBar(title: const Text('Mi perfil público')),
          body: ErrorView(
            error: e,
            onRetry: () => ref.invalidate(myTechnicianProfileProvider),
          ),
        ),
        data: (profile) {
          final public = technicianApplicationToPublic(profile);

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
                technician: public,
                ownerConfig: buildTechnicianProfileOwnerConfig(
                  context: context,
                  ref: ref,
                  profile: profile,
                  userId: userId,
                ),
                showBackButton: true,
              ),
            ),
          );
        },
      );
    }

    final technician = ref.watch(technicianDetailProvider(userId));

    return technician.when(
      loading: () => const Scaffold(
        body: LoadingView(message: 'Cargando perfil...'),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(technicianDetailProvider(userId)),
        ),
      ),
        data: (tech) => TechnicianProfileViewTracker(
        technicianUserId: userId,
        child: Scaffold(
          backgroundColor: AppBrandColors.scaffoldBackground,
          body: ClientTechnicianProfileView(
            technician: tech,
            contextSubSubCategoryId: contextSubSubCategoryId,
          ),
        ),
      ),
    );
  }
}
