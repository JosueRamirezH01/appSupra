import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../providers/auth/auth_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../utils/technician_verification_status.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';
import '../../widgets/technician/technician_verification_timeline.dart';

class MyApplicationScreen extends ConsumerStatefulWidget {
  const MyApplicationScreen({super.key});

  @override
  ConsumerState<MyApplicationScreen> createState() =>
      _MyApplicationScreenState();
}

class _MyApplicationScreenState extends ConsumerState<MyApplicationScreen>
    with WidgetsBindingObserver {
  DateTime? _lastRefreshedAt;
  Timer? _pendingPollTimer;
  String? _trackedVerificationStatus;
  bool _trackedVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh(force: true));
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
      _refresh(force: true, trackTransition: true);
    }
  }

  void _ensureTrackingInitialized(TechnicianApplicationModel profile) {
    if (_trackedVerificationStatus != null) return;
    _trackedVerificationStatus = profile.verificationStatus;
    _trackedVerified = profile.verified;
  }

  void _syncPendingPoll(String? status) {
    if (!TechnicianVerificationStatus.isPending(status)) {
      _pendingPollTimer?.cancel();
      _pendingPollTimer = null;
      return;
    }

    _pendingPollTimer ??= Timer.periodic(
      TechnicianVerificationStatus.pendingPollInterval,
      (_) => _refresh(force: true, trackTransition: true),
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
            '¡Verificación aprobada! Tu insignia ya está visible.',
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

  Future<void> _refresh({
    bool force = false,
    bool trackTransition = false,
  }) async {
    if (force) {
      ref.invalidate(myTechnicianProfileProvider);
    }
    try {
      final profile = await ref.read(myTechnicianProfileProvider.future);
      await ref.read(authNotifierProvider.notifier).refreshProfile();

      if (!mounted) return;

      if (trackTransition) {
        _maybeCelebrateApproval(profile);
      } else {
        _ensureTrackingInitialized(profile);
      }

      _syncPendingPoll(profile.verificationStatus);
      setState(() => _lastRefreshedAt = DateTime.now());
    } catch (_) {
      // ErrorView handles display.
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(myTechnicianProfileProvider);

    return AppScaffold(
      title: 'Verificación de identidad',
      body: profile.when(
        loading: () => const LoadingView(message: 'Consultando estado...'),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => _refresh(force: true),
        ),
        data: (app) {
          _ensureTrackingInitialized(app);
          _syncPendingPoll(app.verificationStatus);

          final status = app.verificationStatus;
          final approved = TechnicianVerificationStatus.isApproved(
            status: status,
            verified: app.verified,
          );
          final accent = TechnicianVerificationStatus.accentColor(
            status: status,
            verified: app.verified,
          );
          final background = TechnicianVerificationStatus.accentBackground(
            status: status,
            verified: app.verified,
          );

          return RefreshIndicator(
            color: TechnicianPanelColors.primary,
            onRefresh: () => _refresh(force: true, trackTransition: true),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                TechnicianPanelStatusBanner(
                  title: TechnicianVerificationStatus.title(
                    status: status,
                    verified: app.verified,
                  ),
                  message: TechnicianVerificationStatus.message(
                    status: status,
                    verified: app.verified,
                  ),
                  icon: TechnicianVerificationStatus.icon(
                    status: status,
                    verified: app.verified,
                  ),
                  accent: accent,
                  background: background,
                  extra: app.rejectionReason?.trim().isNotEmpty == true
                      ? 'Motivo: ${app.rejectionReason!.trim()}'
                      : null,
                  actionLabel: app.canSubmitVerification
                      ? 'Enviar verificación'
                      : app.canResubmit
                          ? 'Corregir y reenviar'
                          : null,
                  onAction: app.canSubmitVerification || app.canResubmit
                      ? () => context.push(RoutePaths.technicianVerification)
                      : null,
                ),
                const SizedBox(height: 16),
                TechnicianVerificationTimeline(profile: app),
                const SizedBox(height: 16),
                TechnicianPanelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Detalle', style: TechnicianPanelTheme.title),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Estado',
                        value: TechnicianVerificationStatus.shortLabel(
                          status: status,
                          verified: app.verified,
                        ),
                        valueColor: accent,
                      ),
                      if (app.submittedAt != null)
                        _DetailRow(
                          label: 'Enviado',
                          value: TechnicianVerificationStatus.formatShortDate(
                            app.submittedAt!,
                          ),
                        ),
                      if (app.reviewedAt != null)
                        _DetailRow(
                          label: approved ? 'Aprobado' : 'Revisado',
                          value: TechnicianVerificationStatus.formatShortDate(
                            app.reviewedAt!,
                          ),
                        ),
                      if (_lastRefreshedAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Actualizado ${TechnicianVerificationStatus.formatRelative(_lastRefreshedAt!)}',
                          style: TechnicianPanelTheme.label,
                        ),
                      ],
                    ],
                  ),
                ),
                if (TechnicianVerificationStatus.isPending(status)) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Esta pantalla se actualiza al deslizar hacia abajo. '
                    'También revisamos el estado automáticamente mientras tu insignia está en revisión.',
                    style: TechnicianPanelTheme.subtitle,
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

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(label, style: TechnicianPanelTheme.subtitle),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: valueColor ?? TechnicianPanelColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
