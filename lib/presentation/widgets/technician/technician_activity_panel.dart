import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/technicians/technician_activity_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import 'technician_recent_contacts_panel.dart';
import 'technician_channel_cards.dart';
import 'technician_panel_theme.dart';
import 'technician_panel_widgets.dart';

class TechnicianActivityPanel extends StatelessWidget {
  const TechnicianActivityPanel({
    super.key,
    required this.stats,
    this.onRefresh,
    this.onViewPublicProfile,
    this.onViewFullPerformance,
  });

  final TechnicianActivityStatsModel stats;
  final VoidCallback? onRefresh;
  final VoidCallback? onViewPublicProfile;
  final VoidCallback? onViewFullPerformance;

  Widget? _buildTrailing() {
    if (onRefresh == null) return null;

    return IconButton(
      onPressed: onRefresh,
      icon: const Icon(Icons.refresh_rounded, size: 20),
      tooltip: 'Actualizar',
      visualDensity: VisualDensity.compact,
    );
  }

  @override
  Widget build(BuildContext context) {
    final week = stats.thisWeek;
    final isEmptyWeek = week.profileViews == 0 && week.contacts.total == 0;

    return TechnicianPanelSection(
      title: 'Tu actividad en la app',
      subtitle:
          'Cuántos clientes vieron tu perfil y completaron el formulario antes de llamarte o escribirte por WhatsApp.',
      trailing: _buildTrailing(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FunnelCard(
            profileViews: week.profileViews,
            contacts: week.contacts.total,
            conversionRate: stats.conversionRateThisWeek,
            onViewFullPerformance: onViewFullPerformance,
          ),
          if (isEmptyWeek) ...[
            const SizedBox(height: 12),
            _ActivityEmptyState(onViewPublicProfile: onViewPublicProfile),
          ] else ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Hoy',
                    profileViews: stats.today.profileViews,
                    contacts: stats.today.contacts.total,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricTile(
                    label: 'Este mes',
                    profileViews: stats.thisMonth.profileViews,
                    contacts: stats.thisMonth.contacts.total,
                  ),
                ),
              ],
            ),
            if (week.contacts.total > 0) ...[
              const SizedBox(height: 14),
              Text(
                'Canal que eligieron para contactarte',
                style: TechnicianPanelTheme.label,
              ),
              const SizedBox(height: 8),
              TechnicianChannelCards(
                phone: week.contacts.phone,
                whatsapp: week.contacts.whatsapp,
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class TechnicianHomeActivityPanel extends ConsumerWidget {
  const TechnicianHomeActivityPanel({
    super.key,
    required this.technicianUserId,
    required this.onViewPublicProfile,
    this.onViewFullPerformance,
  });

  final int technicianUserId;
  final VoidCallback onViewPublicProfile;
  final VoidCallback? onViewFullPerformance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(myTechnicianActivityProvider);

    return activity.when(
      loading: () => const TechnicianPanelCard(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
      error: (error, stackTrace) => TechnicianPanelCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tu actividad en la app', style: TechnicianPanelTheme.title),
            const SizedBox(height: 6),
            Text(
              'No pudimos cargar tus métricas. Desliza hacia abajo para reintentar.',
              style: TechnicianPanelTheme.label,
            ),
          ],
        ),
      ),
      data: (stats) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TechnicianActivityPanel(
            stats: stats,
            onRefresh: () => ref.invalidate(myTechnicianActivityProvider),
            onViewPublicProfile: onViewPublicProfile,
            onViewFullPerformance: onViewFullPerformance,
          ),
          const TechnicianRecentContactsPanel(),
        ],
      ),
    );
  }
}

class _ActivityEmptyState extends StatelessWidget {
  const _ActivityEmptyState({this.onViewPublicProfile});

  final VoidCallback? onViewPublicProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TechnicianPanelColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: TechnicianPanelColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.insights_outlined,
            size: 36,
            color: TechnicianPanelColors.primary.withValues(alpha: 0.85),
          ),
          const SizedBox(height: 12),
          Text(
            'Aún no hay actividad esta semana',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: TechnicianPanelColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completa tu zona de cobertura, fotos y servicios para que más clientes te encuentren en la app.',
            textAlign: TextAlign.center,
            style: TechnicianPanelTheme.subtitle,
          ),
          if (onViewPublicProfile != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewPublicProfile,
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('Ver mi perfil público'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: TechnicianPanelColors.primary,
                  side: BorderSide(
                    color: TechnicianPanelColors.primary.withValues(alpha: 0.45),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FunnelCard extends StatelessWidget {
  const _FunnelCard({
    required this.profileViews,
    required this.contacts,
    required this.conversionRate,
    this.onViewFullPerformance,
  });

  final int profileViews;
  final int contacts;
  final double? conversionRate;
  final VoidCallback? onViewFullPerformance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
                child: Text(
                  'Esta semana',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: TechnicianPanelColors.inkSoft,
                  ),
                ),
              ),
              if (onViewFullPerformance != null)
                TechnicianViewCompleteAction(onPressed: onViewFullPerformance!),
            ],
          ),
          const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Text(
              '${conversionRate!.toStringAsFixed(1)}% de las visitas completaron el formulario',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: TechnicianPanelColors.primary,
              ),
            ),
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
        Icon(icon, size: 20, color: TechnicianPanelColors.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 22,
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

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.profileViews,
    required this.contacts,
  });

  final String label;
  final int profileViews;
  final int contacts;

  @override
  Widget build(BuildContext context) {
    return TechnicianPanelCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TechnicianPanelTheme.label),
          const SizedBox(height: 8),
          Text(
            '$profileViews ${profileViews == 1 ? 'vista' : 'vistas'} · '
            '$contacts con datos',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TechnicianPanelColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}
