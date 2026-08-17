import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/work_portfolio_constants.dart';
import '../../../data/models/auth/user_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_onboarding_status.dart';
import '../../utils/technician_submitted_documents.dart';
import '../../utils/technician_verification_status.dart';
import '../../utils/collapsible_list_utils.dart';
import '../../widgets/common/collapsible_chip_wrap.dart';
import '../../widgets/common/expandable_panel_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/technician_activation_panel.dart';
import '../../widgets/technician/technician_activity_panel.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/technician_profile_edit_sheets.dart';
import '../../widgets/technician_verification_badge.dart';

class TechnicianHomeScreen extends ConsumerStatefulWidget {
  const TechnicianHomeScreen({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<TechnicianHomeScreen> createState() =>
      _TechnicianHomeScreenState();
}

class _TechnicianHomeScreenState extends ConsumerState<TechnicianHomeScreen>
    with WidgetsBindingObserver {
  bool _pendingPanelDismissed = false;
  bool _profileSummaryExpanded = false;
  bool _photoNoticeDismissed = false;
  bool _addingPhoto = false;
  Timer? _pendingPollTimer;
  String? _trackedVerificationStatus;
  bool _trackedVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProfile(trackTransition: false);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pendingPollTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshProfile(trackTransition: true);
    }
  }

  void _ensureTrackingInitialized(TechnicianApplicationModel profile) {
    if (_trackedVerificationStatus != null) return;
    _trackedVerificationStatus = profile.verificationStatus;
    _trackedVerified = profile.verified;
  }

  void _syncPendingPoll(TechnicianApplicationModel profile) {
    if (!TechnicianVerificationStatus.isPending(profile.verificationStatus)) {
      _pendingPollTimer?.cancel();
      _pendingPollTimer = null;
      return;
    }

    _pendingPollTimer ??= Timer.periodic(
      TechnicianVerificationStatus.pendingPollInterval,
      (_) => _refreshProfile(trackTransition: true),
    );
  }

  void _maybeCelebrateApproval(TechnicianApplicationModel profile) {
    final wasPending = _trackedVerificationStatus == 'pendiente' &&
        !_trackedVerified;
    final nowApproved = TechnicianVerificationStatus.isApproved(
      status: profile.verificationStatus,
      verified: profile.verified,
    );

    if (wasPending && nowApproved && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Insignia verificada! Ya es visible en tu perfil.',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: TechnicianPanelColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }

    _trackedVerificationStatus = profile.verificationStatus;
    _trackedVerified = profile.verified;
  }

  bool _shouldShowPhotoNotice(TechnicianApplicationModel profile) {
    if (_photoNoticeDismissed) return false;
    final photo = profile.profilePhotoUrl?.trim();
    return photo == null || photo.isEmpty;
  }

  Future<void> _addProfilePhoto() async {
    setState(() => _addingPhoto = true);
    try {
      await pickAndUpdateProfilePhoto(context, ref, userId: widget.user.id);
    } finally {
      if (mounted) setState(() => _addingPhoto = false);
    }
  }

  Future<void> _refreshProfile({required bool trackTransition}) async {
    setState(() => _pendingPanelDismissed = false);
    ref.invalidate(myTechnicianProfileProvider);
    ref.invalidate(myTechnicianActivityProvider);

    try {
      final profile = await ref.read(myTechnicianProfileProvider.future);
      await ref.read(authNotifierProvider.notifier).refreshProfile();

      if (!mounted) return;

      if (trackTransition) {
        _maybeCelebrateApproval(profile);
      } else {
        _ensureTrackingInitialized(profile);
      }

      _syncPendingPoll(profile);
    } catch (_) {
      // ErrorView handles display.
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myTechnicianProfileProvider);
    final summary = widget.user.technicianSummary;
    // Keep previous data while refreshing so expandable UI state is not disposed.
    final data = profile.asData?.value;

    if (data == null) {
      if (profile.hasError) {
        return ErrorView(
          error: profile.error!,
          onRetry: () => _refreshProfile(trackTransition: true),
        );
      }
      return const LoadingView(message: 'Cargando tu perfil...');
    }

    _ensureTrackingInitialized(data);
    _syncPendingPoll(data);

    final showActivationPanel =
        TechnicianOnboardingStatus.needsActivationPanel(data) && (!_pendingPanelDismissed || !TechnicianOnboardingStatus.panelIsDismissible(data));

    return RefreshIndicator(
      color: TechnicianPanelColors.primary,
      onRefresh: () => _refreshProfile(trackTransition: true),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _TechnicianHero(profile: data),
          if (_shouldShowPhotoNotice(data)) ...[
            const SizedBox(height: 16),
            _AddPhotoNotice(
              loading: _addingPhoto,
              onAdd: _addProfilePhoto,
              onDismiss: () => setState(() => _photoNoticeDismissed = true),
            ),
          ],
          if (showActivationPanel) ...[
            const SizedBox(height: 16),
            TechnicianActivationPanel(
              profile: data,
              onDismiss: TechnicianOnboardingStatus.panelIsDismissible(data)
                  ? () => setState(() => _pendingPanelDismissed = true)
                  : null,
            ),
          ],
          const SizedBox(height: 16),
          TechnicianHomeActivityPanel(
            technicianUserId: widget.user.id,
            onViewPublicProfile: () => context.push(RoutePaths.technicianDetailPath(widget.user.id)),
            onViewFullPerformance: () => context.push(RoutePaths.technicianPerformance),
          ),
          if (!showActivationPanel) ...[
            const SizedBox(height: 20),
            TechnicianPanelStatusBanner.fromVerification(
              status: data.verificationStatus ?? summary?.verificationStatus,
              verified: data.verified || (summary?.verified ?? false),
              rejectionReason: data.rejectionReason ?? summary?.rejectionReason,
              actionLabel: data.canSubmitVerification ? 'Completar verificación' : null,
              onAction: data.canSubmitVerification ? () => context.push(RoutePaths.technicianVerification) : null),
          ],
          if (showActivationPanel) const SizedBox(height: 4),
          if (!showActivationPanel) const SizedBox(height: 20),
          _StatsStrip(profile: data),
          const SizedBox(height: 20),
          TechnicianPanelSection(
            title: 'Resumen del perfil',
            subtitle: 'Información visible para clientes',
            child: _ProfileSummaryCard(
              profile: data,
              expanded: _profileSummaryExpanded,
              onExpandedChanged: (value) {
                setState(() => _profileSummaryExpanded = value);
              },
            ),
          ),
          const SizedBox(height: 20),
          TechnicianPanelSection(
            title: 'Acciones rápidas',
            child: _QuickActions(
              userId: widget.user.id,
              profile: data,
              canEdit: data.canEditProfile,
              canSubmitVerification: data.canSubmitVerification,
              activationIncomplete: TechnicianOnboardingStatus.needsActivationPanel(data),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechnicianHero extends StatelessWidget {
  const _TechnicianHero({required this.profile});

  final TechnicianApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: TechnicianPanelTheme.heroDecoration(),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              TechnicianAvatarWithBadge(
                name: profile.name,
                photoUrl: profile.profilePhotoUrl,
                verified: profile.verified,
                verificationStatus: profile.verificationStatus,
                radius: 36,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (profile.specialty != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    profile.specialty!,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    TechnicianPanelChip(
                      label: profile.profileType == 'empresa' ? 'Empresa' : 'Independiente',
                      icon: profile.profileType == 'empresa' ? Icons.business_outlined : Icons.person_outline,
                      tint: Colors.white.withValues(alpha: 0.9),
                    ),
                    if (profile.ruc != null)
                      TechnicianPanelChip(
                        label: 'RUC ${profile.ruc}',
                        icon: Icons.badge_outlined,
                        tint: Colors.white.withValues(alpha: 0.9),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPhotoNotice extends StatelessWidget {
  const _AddPhotoNotice({
    required this.onAdd,
    required this.onDismiss,
    required this.loading,
  });

  final VoidCallback onAdd;
  final VoidCallback onDismiss;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TechnicianPanelColors.primarySoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TechnicianPanelColors.primaryMuted),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TechnicianPanelColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_a_photo_rounded,
                  color: TechnicianPanelColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Agrega tu foto de perfil',
                      style: TechnicianPanelTheme.title.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Los clientes confían más en técnicos con foto. '
                      'Puedes agregarla ahora o cambiarla cuando quieras.',
                      style: TechnicianPanelTheme.subtitle,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: loading ? null : onDismiss,
                borderRadius: BorderRadius.circular(20),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: TechnicianPanelColors.inkSoft,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: loading ? null : onAdd,
              style: FilledButton.styleFrom(
                backgroundColor: TechnicianPanelColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.photo_camera_rounded, size: 18),
              label: Text(
                loading ? 'Subiendo…' : 'Agregar foto',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.profile});

  final TechnicianApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*Expanded(
          child: _StatCard(
            label: 'Experiencia',
            value: profile.experienceYears != null
                ? '${profile.experienceYears} años'
                : '—',
            icon: Icons.work_history_outlined,
          ),
        ),
        const SizedBox(width: 10),*/
        Expanded(
          child: _StatCard(
            label: 'Habilidades',
            value: '${profile.subSubCategories.length}',
            icon: Icons.construction_outlined,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _StatCard(
            label: 'Estado',
            value: _statusLabel(profile),
            icon: Icons.verified_user_outlined,
          ),
        ),
      ],
    );
  }

  String _statusLabel(TechnicianApplicationModel profile) {
    return TechnicianVerificationStatus.shortLabel(
      status: profile.verificationStatus,
      verified: profile.verified,
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TechnicianPanelCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: TechnicianPanelColors.primary),
          const SizedBox(height: 8),
          Text(value, style: TechnicianPanelTheme.title.copyWith(fontSize: 14)),
          const SizedBox(height: 2),
          Text(label, style: TechnicianPanelTheme.label),
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.profile,
    required this.expanded,
    required this.onExpandedChanged,
  });

  final TechnicianApplicationModel profile;
  final bool expanded;
  final ValueChanged<bool> onExpandedChanged;

  String? get _phone => profile.phone?.trim().isNotEmpty == true
      ? profile.phone!.trim()
      : null;

  List<String> get _specialtyNames =>
      profile.subcategories.map((item) => item.name).toList(growable: false);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanelCard(
      expanded: expanded,
      onExpandedChanged: onExpandedChanged,
      accentColor: TechnicianPanelColors.primary,
      expandLabel: 'Ver resumen completo',
      collapseLabel: 'Ocultar resumen',
      decoration: BoxDecoration(
        color: TechnicianPanelColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TechnicianPanelColors.border),
      ),
      collapsedPreview: _CollapsedProfilePreview(
        phone: _phone,
        specialtyNames: _specialtyNames,
        skillsCount: profile.subSubCategories.length,
      ),
      expandedChild: _ExpandedProfileDetails(profile: profile),
    );
  }
}

class _CollapsedProfilePreview extends StatelessWidget {
  const _CollapsedProfilePreview({
    required this.phone,
    required this.specialtyNames,
    required this.skillsCount,
  });

  final String? phone;
  final List<String> specialtyNames;
  final int skillsCount;

  @override
  Widget build(BuildContext context) {
    final visibleSpecialties = CollapsibleListUtils.slice(
      specialtyNames,
      previewLimit: 2,
      expanded: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (phone != null) ...[
          _InfoRow('Teléfono', phone!),
        ] else
          Text(
            'Completa tu teléfono para que te contacten más fácil.',
            style: TechnicianPanelTheme.subtitle,
          ),
        if (visibleSpecialties.visible.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text('Especialidades', style: TechnicianPanelTheme.label),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in visibleSpecialties.visible)
                TechnicianPanelChip(
                  label: name,
                  tint: TechnicianPanelColors.background,
                ),
              if (visibleSpecialties.hiddenCount > 0)
                TechnicianPanelChip(
                  label: '+${visibleSpecialties.hiddenCount}',
                  tint: TechnicianPanelColors.primarySoft,
                ),
            ],
          ),
        ],
        if (skillsCount > 0) ...[
          const SizedBox(height: 10),
          Text(
            skillsCount == 1
                ? '1 habilidad registrada'
                : '$skillsCount habilidades registradas',
            style: TechnicianPanelTheme.label,
          ),
        ],
      ],
    );
  }
}

class _ExpandedProfileDetails extends StatelessWidget {
  const _ExpandedProfileDetails({required this.profile});

  final TechnicianApplicationModel profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile.phone != null) _InfoRow('Teléfono', profile.phone!),
        if (profile.email != null) _InfoRow('Email', profile.email!),
        if (profile.documentNumber != null)
          _InfoRow(
            profile.documentType ?? 'Documento',
            profile.documentNumber!,
          ),
        if (profile.description != null && profile.description!.isNotEmpty)
          _InfoRow('Descripción', profile.description!),
        if (profile.subcategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Especialidades', style: TechnicianPanelTheme.label),
          const SizedBox(height: 8),
          CollapsibleChipWrap(
            previewLimit: CollapsibleListUtils.defaultSpecialtyPreviewLimit,
            toggleColor: TechnicianPanelColors.primary,
            moreLabelBuilder: (hidden) => '+$hidden más',
            chips: profile.subcategories
                .map(
                  (item) => TechnicianPanelChip(
                    label: item.name,
                    tint: TechnicianPanelColors.background,
                  ),
                )
                .toList(),
          ),
        ],
        if (profile.subSubCategories.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Habilidades', style: TechnicianPanelTheme.label),
          const SizedBox(height: 8),
          CollapsibleChipWrap(
            previewLimit: CollapsibleListUtils.defaultChipPreviewLimit,
            toggleColor: TechnicianPanelColors.primary,
            moreLabelBuilder: (hidden) => '+$hidden más',
            chips: profile.subSubCategories.map(
                  (item) => TechnicianPanelChip(
                    label: item.name,
                    tint: TechnicianPanelColors.primarySoft,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TechnicianPanelTheme.label),
          ),
          Expanded(child: Text(value, style: TechnicianPanelTheme.body)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.userId,
    required this.profile,
    required this.canEdit,
    required this.canSubmitVerification,
    required this.activationIncomplete,
  });

  final int userId;
  final TechnicianApplicationModel profile;
  final bool canEdit;
  final bool canSubmitVerification;
  final bool activationIncomplete;

  @override
  Widget build(BuildContext context) {
    final documentCount = TechnicianSubmittedDocuments.fromProfile(profile).length;

    return Column(
      children: [
        TechnicianPanelActionTile(
          icon: Icons.folder_open_outlined,
          title: 'Documentos enviados',
          subtitle: documentCount > 0
              ? 'Revisa los $documentCount archivo${documentCount == 1 ? '' : 's'} de tu expediente'
              : 'Aún no has subido documentos',
          badge: documentCount > 0 ? '$documentCount' : null,
          onTap: () => context.push(RoutePaths.technicianDocuments),
        ),
        if (profile.profileType == 'independiente') ...[
          const SizedBox(height: 10),
          TechnicianPanelActionTile(
            icon: Icons.photo_library_outlined,
            title: 'Portafolio de trabajos',
            subtitle: profile.workPhotos.isNotEmpty
                ? '${profile.workPhotos.length} foto${profile.workPhotos.length == 1 ? '' : 's'} visibles para clientes'
                : 'Sube entre ${WorkPortfolioConstants.minPhotos} y ${WorkPortfolioConstants.maxPhotos} fotos de trabajos reales',
            badge: profile.workPhotos.isNotEmpty
                ? '${profile.workPhotos.length}/${WorkPortfolioConstants.maxPhotos}'
                : null,
            onTap: () => context.push(RoutePaths.technicianWorkPortfolio),
          ),
        ],
        const SizedBox(height: 10),
        TechnicianPanelActionTile(
          icon: Icons.visibility_outlined,
          title: 'Ver mi perfil público',
          subtitle: 'Edita y revisa cómo te ven los clientes',
          onTap: () => context.push(RoutePaths.technicianDetailPath(userId)),
        ),
        const SizedBox(height: 10),
        TechnicianPanelActionTile(
          icon: Icons.assignment_outlined,
          title: 'Estado de verificación',
          subtitle: TechnicianVerificationStatus.quickActionSubtitle(
            status: profile.verificationStatus,
            verified: profile.verified,
            submittedAt: profile.submittedAt,
          ),
          badge: TechnicianVerificationStatus.quickActionBadge(
            status: profile.verificationStatus,
            verified: profile.verified,
          ),
          onTap: () => context.push(RoutePaths.myApplication),
        ),
        if (!profile.hasServiceArea && !activationIncomplete) ...[
          const SizedBox(height: 10),
          TechnicianPanelActionTile(
            icon: Icons.location_on_outlined,
            title: 'Configurar zona de servicio',
            subtitle: 'Visible para clientes que buscan técnicos cercanos',
            badge: 'Pendiente',
            onTap: () => context.push(
              '${RoutePaths.technicianServiceArea}?continue=false',
            ),
          ),
        ],
        if (canSubmitVerification && !activationIncomplete) ...[
          const SizedBox(height: 10),
          TechnicianPanelActionTile(
            icon: Icons.verified_user_outlined,
            title: 'Verificar identidad',
            subtitle: 'Sube DNI y foto de rostro para la insignia de identidad',
            badge: 'Nuevo',
            onTap: () => context.push(RoutePaths.technicianVerification),
          ),
        ],
      ],
    );
  }
}
