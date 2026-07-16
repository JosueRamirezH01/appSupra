import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/technicians/technician_model.dart';
import '../../utils/technician_verification_status.dart';
import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

enum _TimelineStepState { done, active, upcoming }

class _TimelineStep {
  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.state,
  });

  final String title;
  final String subtitle;
  final _TimelineStepState state;
}

class TechnicianVerificationTimeline extends StatelessWidget {
  const TechnicianVerificationTimeline({super.key, required this.profile});

  final TechnicianApplicationModel profile;

  List<_TimelineStep> _buildSteps() {
    final status = profile.verificationStatus;
    final approved = TechnicianVerificationStatus.isApproved(
      status: status,
      verified: profile.verified,
    );
    final pending = TechnicianVerificationStatus.isPending(status);
    final rejected = TechnicianVerificationStatus.isRejected(status);

    final submittedSubtitle = profile.submittedAt != null
        ? TechnicianVerificationStatus.formatShortDate(profile.submittedAt!)
        : 'Pendiente de envío';

    final reviewSubtitle = approved && profile.reviewedAt != null
        ? 'Aprobado el ${TechnicianVerificationStatus.formatShortDate(profile.reviewedAt!)}'
        : rejected && profile.reviewedAt != null
            ? 'Revisado el ${TechnicianVerificationStatus.formatShortDate(profile.reviewedAt!)}'
            : pending
                ? 'En curso — 24–48 h hábiles'
                : 'Pendiente';

    final verifiedSubtitle = approved
        ? 'Insignia visible en tu perfil'
        : rejected
            ? 'Reenvía documentos corregidos'
            : pending
                ? 'Te avisaremos al finalizar'
                : 'Completa el paso anterior';

    _TimelineStepState stepState(int index) {
      if (approved) {
        return _TimelineStepState.done;
      }
      if (rejected) {
        return index == 0
            ? _TimelineStepState.done
            : index == 1
                ? _TimelineStepState.active
                : _TimelineStepState.upcoming;
      }
      if (pending) {
        return index == 0
            ? _TimelineStepState.done
            : index == 1
                ? _TimelineStepState.active
                : _TimelineStepState.upcoming;
      }
      return index == 0 ? _TimelineStepState.active : _TimelineStepState.upcoming;
    }

    return [
      _TimelineStep(
        title: 'Documentos enviados',
        subtitle: submittedSubtitle,
        state: stepState(0),
      ),
      _TimelineStep(
        title: rejected ? 'Revisión con observaciones' : 'Insignia en revisión',
        subtitle: reviewSubtitle,
        state: stepState(1),
      ),
      _TimelineStep(
        title: 'Insignia activa',
        subtitle: verifiedSubtitle,
        state: stepState(2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final steps = _buildSteps();
    final accent = TechnicianVerificationStatus.accentColor(
      status: profile.verificationStatus,
      verified: profile.verified,
    );

    return TechnicianPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progreso', style: TechnicianPanelTheme.title),
          const SizedBox(height: 16),
          for (var i = 0; i < steps.length; i++) ...[
            _TimelineRow(
              step: steps[i],
              accent: accent,
              isLast: i == steps.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.step,
    required this.accent,
    required this.isLast,
  });

  final _TimelineStep step;
  final Color accent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final dotColor = switch (step.state) {
      _TimelineStepState.done => TechnicianPanelColors.success,
      _TimelineStepState.active => accent,
      _TimelineStepState.upcoming => TechnicianPanelColors.border,
    };

    final titleColor = step.state == _TimelineStepState.upcoming
        ? TechnicianPanelColors.inkSoft
        : TechnicianPanelColors.ink;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Column(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: step.state == _TimelineStepState.done
                        ? TechnicianPanelColors.successSoft
                        : step.state == _TimelineStepState.active
                            ? accent.withValues(alpha: 0.15)
                            : TechnicianPanelColors.background,
                    shape: BoxShape.circle,
                    border: Border.all(color: dotColor, width: 2),
                  ),
                  child: step.state == _TimelineStepState.done
                      ? Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: TechnicianPanelColors.success,
                        )
                      : step.state == _TimelineStepState.active
                          ? Icon(Icons.more_horiz_rounded, size: 14, color: accent)
                          : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: step.state == _TimelineStepState.done
                          ? TechnicianPanelColors.success.withValues(alpha: 0.35)
                          : TechnicianPanelColors.border,
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.subtitle,
                    style: TechnicianPanelTheme.subtitle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
