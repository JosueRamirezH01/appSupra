import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/technicians/technician_activity_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import 'technician_channel_cards.dart';
import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

class TechnicianActivityPanel extends StatelessWidget {
  const TechnicianActivityPanel({
    super.key,
    required this.stats,
    this.onViewFullPerformance,
  });

  final TechnicianActivityStatsModel stats;
  final VoidCallback? onViewFullPerformance;

  @override
  Widget build(BuildContext context) {
    final week = stats.thisWeek;
    final isEmptyWeek = week.profileViews == 0 && week.contacts.total == 0;

    return TechnicianPanelSection(
      title: 'Esta semana',
      trailing: onViewFullPerformance == null
          ? null
          : TechnicianViewCompleteAction(onPressed: onViewFullPerformance!),
      child: _WeekSnapshotCard(
        profileViews: week.profileViews,
        contacts: week.contacts.total,
        conversionRate: stats.conversionRateThisWeek,
        emptyHint: isEmptyWeek
            ? 'Cuando vean tu perfil, aquí verás las visitas y quién dejó sus datos.'
            : null,
      ),
    );
  }
}

class TechnicianHomeActivityPanel extends ConsumerWidget {
  const TechnicianHomeActivityPanel({
    super.key,
    this.onViewFullPerformance,
  });

  final VoidCallback? onViewFullPerformance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(myTechnicianActivityProvider);

    return activity.when(
      loading: () => const TechnicianPanelCard(
        padding: EdgeInsets.symmetric(vertical: 18),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (error, stackTrace) => TechnicianPanelCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Esta semana', style: TechnicianPanelTheme.title),
            const SizedBox(height: 6),
            Text(
              'No pudimos cargar tus métricas. Desliza hacia abajo para reintentar.',
              style: TechnicianPanelTheme.label,
            ),
          ],
        ),
      ),
      data: (stats) => TechnicianActivityPanel(
        stats: stats,
        onViewFullPerformance: onViewFullPerformance,
      ),
    );
  }
}

class _WeekSnapshotCard extends StatelessWidget {
  const _WeekSnapshotCard({
    required this.profileViews,
    required this.contacts,
    required this.conversionRate,
    this.emptyHint,
  });

  final int profileViews;
  final int contacts;
  final double? conversionRate;
  final String? emptyHint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TechnicianPanelColors.primary.withValues(alpha: 0.12),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TechnicianPanelColors.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _FunnelStat(
                  icon: Icons.visibility_outlined,
                  value: '$profileViews',
                  label: 'Vieron tu perfil',
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: TechnicianPanelColors.inkSoft,
                size: 18,
              ),
              Expanded(
                child: _FunnelStat(
                  icon: Icons.assignment_outlined,
                  value: '$contacts',
                  label: 'Dejaron sus datos',
                ),
              ),
            ],
          ),
          if (conversionRate != null && profileViews > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${conversionRate!.toStringAsFixed(1)}% completó el formulario',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: TechnicianPanelColors.primary,
              ),
            ),
          ],
          if (emptyHint != null) ...[
            const SizedBox(height: 8),
            Text(emptyHint!, style: TechnicianPanelTheme.subtitle),
          ],
        ],
      ),
    );
  }
}

class _FunnelStat extends StatelessWidget {
  const _FunnelStat({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: TechnicianPanelColors.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: TechnicianPanelColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TechnicianPanelTheme.label,
        ),
      ],
    );
  }
}
