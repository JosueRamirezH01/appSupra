import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../core/utils/media_url_utils.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/sellers/seller_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/app_view_notifier.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/sellers/sellers_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/seller_onboarding_status.dart';
import '../../utils/technician_onboarding_status.dart';
import '../../widgets/auth/auth_ui.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/home/client_profile_completion_banner.dart';
import '../../widgets/settings/become_technician_promo_card.dart';
import '../../widgets/settings/settings_tile.dart';

class ClientSettingsScreen extends ConsumerWidget {
  const ClientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);

    return AppScaffold(
      title: 'Configuración',
      body: auth.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(authNotifierProvider),
        ),
        data: (user) {
          if (user == null) {
            return const LoadingView();
          }

          // Cada perfil usa SU provider (técnico ≠ vendedor).
          final technicianProfile = user.hasTechnicianProfile
              ? ref.watch(myTechnicianProfileProvider)
              : null;
          final sellerProfile = user.hasSellerProfile
              ? ref.watch(mySellerApplicationProvider)
              : null;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _AccountSummaryCard(user: user),
                if (user.needsClientProfileCompletion) ...[
                  const SizedBox(height: 16),
                  ClientProfileCompletionBanner(
                    completion: user.profileCompletion!,
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  'Mi cuenta',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                SettingsTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Editar perfil',
                  subtitle: 'Nombre, celular y foto',
                  onTap: () => context.push(RoutePaths.clientEditProfile),
                ),
                if (user.hasTechnicianProfile) ...[
                  const SizedBox(height: 8),
                  _TechnicianProfileSettingsTile(
                    profileAsync: technicianProfile,
                    onOpen: () async {
                      try {
                        final profile = await ref.read(
                          myTechnicianProfileProvider.future,
                        );
                        if (!context.mounted) return;

                        if (!profile.hasServiceArea) {
                          context.push(
                            '${RoutePaths.technicianActivateLocation}?source=profile',
                          );
                          return;
                        }

                        ref
                            .read(activeAppViewProvider.notifier)
                            .preferTechnician();
                        context.go(RoutePaths.panel);
                      } catch (error) {
                        if (context.mounted) {
                          showErrorSnackBar(context, error);
                        }
                      }
                    },
                  ),
                ],
                if (user.hasSellerProfile) ...[
                  const SizedBox(height: 8),
                  _SellerProfileSettingsTile(
                    profileAsync: sellerProfile,
                    onOpen: () {
                      ref.read(activeAppViewProvider.notifier).preferSeller();
                      context.go(RoutePaths.panel);
                    },
                  ),
                ],
                if (user.navigation?.technicianApplicationPending == true &&
                    !user.hasTechnicianProfile) ...[
                  const SizedBox(height: 8),
                  _PendingApplicationBanner(),
                ],
                if (user.navigation?.canBecomeTechnician == true) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Ofrecer servicios',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  BecomeTechnicianPromoCard(
                    onTap: () => context.push(RoutePaths.becomeTechnician),
                  ),
                ],
                if (user.navigation?.canBecomeSeller == true) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Vender productos',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.storefront_outlined),
                      title: const Text('Registrar mi negocio'),
                      subtitle: const Text(
                        'Solo negocios con RUC. Mantienes tu perfil de cliente.',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push(RoutePaths.becomeSeller),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AccountSummaryCard extends StatelessWidget {
  const _AccountSummaryCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
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
    );
  }
}

class _TechnicianProfileSettingsTile extends StatelessWidget {
  const _TechnicianProfileSettingsTile({
    required this.profileAsync,
    required this.onOpen,
  });

  final AsyncValue<TechnicianApplicationModel>? profileAsync;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        profileAsync?.whenOrNull(
          data: (profile) {
            if (!profile.hasServiceArea) {
              return 'Configura tu ubicación para activar el perfil';
            }
            if (profile.verificationStatus == 'pendiente') {
              return 'Insignia en revisión';
            }
            if (TechnicianOnboardingStatus.isFullyActivated(profile)) {
              return 'Gestiona tu perfil profesional';
            }
            if (profile.canSubmitVerification) {
              return 'Opcional: obtén la insignia verificada';
            }
            return 'Gestiona tu perfil profesional';
          },
        ) ??
        'Gestiona tu perfil profesional';

    return SettingsTile(
      icon: Icons.handyman_outlined,
      title: 'Mi perfil técnico',
      subtitle: subtitle,
      onTap: onOpen,
    );
  }
}

class _SellerProfileSettingsTile extends StatelessWidget {
  const _SellerProfileSettingsTile({
    required this.profileAsync,
    required this.onOpen,
  });

  final AsyncValue<SellerApplicationModel>? profileAsync;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final subtitle =
        profileAsync?.whenOrNull(
          data: (profile) {
            if (!profile.hasLocation) {
              return 'Configura la ubicación de tu negocio';
            }
            if (profile.verificationStatus == 'pendiente') {
              return 'Negocio en revisión';
            }
            if (profile.verified || profile.verificationStatus == 'aprobado') {
              return 'Gestiona tu negocio y productos';
            }
            if (profile.canSubmitVerification ||
                SellerOnboardingStatus.needsOnboarding(profile)) {
              return 'Completa la verificación de tu negocio';
            }
            return 'Gestiona tu negocio y productos';
          },
        ) ??
        'Gestiona tu negocio y productos';

    return SettingsTile(
      icon: Icons.storefront_outlined,
      title: 'Mi perfil vendedor',
      subtitle: subtitle,
      onTap: onOpen,
    );
  }
}

class _PendingApplicationBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFED7AA)),
      ),
      child: Row(
        children: [
          const Icon(Icons.hourglass_top_rounded, color: Color(0xFFEA580C)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tus documentos para la insignia verificada están en revisión. Tu perfil técnico sigue activo.',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
