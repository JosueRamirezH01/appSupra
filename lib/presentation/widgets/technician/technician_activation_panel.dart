import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import '../../utils/technician_onboarding_status.dart';
import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

class TechnicianActivationPanel extends StatelessWidget {
  const TechnicianActivationPanel({
    super.key,
    required this.profile,
    this.onDismiss,
  });

  final TechnicianApplicationModel profile;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final step = TechnicianOnboardingStatus.currentStep(profile);
    final progress = TechnicianOnboardingStatus.activationProgress(profile);
    final dismissible = TechnicianOnboardingStatus.panelIsDismissible(profile);

    final title = switch (step) {
      TechnicianActivationStep.serviceArea => 'Activa tu perfil profesional',
      TechnicianActivationStep.verification => 'Activa tu perfil profesional',
      TechnicianActivationStep.pendingReview => 'Insignia en revisión',
      TechnicianActivationStep.complete => '',
    };

    final subtitle = switch (step) {
      TechnicianActivationStep.serviceArea =>
        'Configura dónde prestas servicio para activar tu perfil.',
      TechnicianActivationStep.verification =>
        'Opcional: obtén la insignia verificada subiendo tu documento.',
      TechnicianActivationStep.pendingReview =>
        'Revisaremos tus documentos en 24–48 horas hábiles. Tu perfil técnico sigue activo mientras tanto.',
      TechnicianActivationStep.complete => '',
    };

    final ctaLabel = switch (step) {
      TechnicianActivationStep.serviceArea => 'Configurar ubicación',
      TechnicianActivationStep.verification => 'Obtener insignia verificada',
      TechnicianActivationStep.pendingReview => 'Ver estado de verificación',
      TechnicianActivationStep.complete => 'Continuar',
    };

    void onContinue() {
      switch (step) {
        case TechnicianActivationStep.serviceArea:
          context.push(RoutePaths.technicianActivateLocation);
        case TechnicianActivationStep.verification:
          context.push(RoutePaths.technicianVerification);
        case TechnicianActivationStep.pendingReview:
          context.push(RoutePaths.myApplication);
        case TechnicianActivationStep.complete:
          break;
      }
    }

    return TechnicianPanelCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: TechnicianPanelColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  step == TechnicianActivationStep.pendingReview
                      ? Icons.hourglass_top_rounded
                      : Icons.rocket_launch_outlined,
                  color: TechnicianPanelColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: TechnicianPanelColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.4,
                        color: TechnicianPanelColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (dismissible && onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: TechnicianPanelColors.inkMuted,
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
            ],
          ),
          if (step != TechnicianActivationStep.pendingReview) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress / TechnicianOnboardingStatus.activationStepsTotal,
                minHeight: 5,
                backgroundColor: TechnicianPanelColors.background,
                color: TechnicianPanelColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            _ActivationChecklist(step: step),
          ],
          const SizedBox(height: 14),
          TechnicianPanelPrimaryButton(
            label: ctaLabel,
            icon: step == TechnicianActivationStep.verification
                ? Icons.verified_user_outlined
                : step == TechnicianActivationStep.serviceArea
                    ? Icons.location_on_outlined
                    : Icons.arrow_forward_rounded,
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}

class _ActivationChecklist extends StatelessWidget {
  const _ActivationChecklist({required this.step});

  final TechnicianActivationStep step;

  @override
  Widget build(BuildContext context) {
    final serviceDone = step != TechnicianActivationStep.serviceArea;
    final verifyDone = step == TechnicianActivationStep.pendingReview ||
        step == TechnicianActivationStep.complete;

    return Column(
      children: [
        _CheckRow(label: 'Registro completado', done: true),
        _CheckRow(label: 'Ubicación de servicio', done: serviceDone),
        _CheckRow(
          label: 'Insignia verificada (opcional)',
          done: verifyDone,
        ),
      ],
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.label, required this.done});

  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            size: 16,
            color: done
                ? TechnicianPanelColors.primary
                : TechnicianPanelColors.inkMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: done ? FontWeight.w600 : FontWeight.w400,
                color: done
                    ? TechnicianPanelColors.ink
                    : TechnicianPanelColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
