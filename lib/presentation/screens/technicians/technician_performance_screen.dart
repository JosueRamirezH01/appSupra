import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/models/technicians/technician_performance_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/technician/technician_channel_cards.dart';
import '../../widgets/technician/technician_panel_theme.dart';
import '../../widgets/technician/technician_panel_widgets.dart';

class TechnicianPerformanceScreen extends ConsumerStatefulWidget {
  const TechnicianPerformanceScreen({super.key});

  @override
  ConsumerState<TechnicianPerformanceScreen> createState() =>
      _TechnicianPerformanceScreenState();
}

class _TechnicianPerformanceScreenState
    extends ConsumerState<TechnicianPerformanceScreen> {
  TechnicianPerformancePeriodKey _selectedPeriod =
      TechnicianPerformancePeriodKey.thisWeek;

  Future<void> _refresh() async {
    ref.invalidate(
      myTechnicianPerformanceProvider(_selectedPeriod.apiValue),
    );
    await ref.read(
      myTechnicianPerformanceProvider(_selectedPeriod.apiValue).future,
    );
  }

  void _selectPeriod(TechnicianPerformancePeriodKey period) {
    if (_selectedPeriod == period) return;
    setState(() => _selectedPeriod = period);
  }

  String _trendSubtitle(TechnicianPerformancePeriodKey key) {
    return switch (key) {
      TechnicianPerformancePeriodKey.thisWeek => 'Vistas y contactos por día',
      TechnicianPerformancePeriodKey.last3Months => 'Vistas y contactos por mes',
      _ => 'Vistas y contactos por semana',
    };
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(
      myTechnicianPerformanceProvider(_selectedPeriod.apiValue),
    );

    return TechnicianPanelScaffold(
      title: 'Mi rendimiento',
      body: reportAsync.when(
        loading: () => const LoadingView(message: 'Cargando tu rendimiento...'),
        error: (error, _) => ErrorView(error: error, onRetry: _refresh),
        data: (report) => RefreshIndicator(
          color: TechnicianPanelColors.primary,
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Text(
                'Analiza cómo te encuentran y cuántos clientes dejan sus datos antes de contactarte.',
                style: TechnicianPanelTheme.subtitle,
              ),
              const SizedBox(height: 16),
              _PeriodSelector(
                selected: _selectedPeriod,
                onSelected: _selectPeriod,
              ),
              const SizedBox(height: 16),
              _SummaryHero(report: report),
              if (report.comparisonPreviousPeriod != null) ...[
                const SizedBox(height: 12),
                _ComparisonRow(comparison: report.comparisonPreviousPeriod!),
              ],
              const SizedBox(height: 20),
              TechnicianPanelSection(
                title: 'Tendencia',
                subtitle: _trendSubtitle(report.period.key),
                child: _TrendChart(buckets: report.trendBuckets),
              ),
              const SizedBox(height: 20),
              TechnicianPanelSection(
                title: 'Embudo del periodo',
                child: _FunnelSummary(report: report),
              ),
              if (report.contacts.total > 0) ...[
                const SizedBox(height: 20),
                TechnicianPanelSection(
                  title: 'Canales elegidos',
                  subtitle: 'Después de completar el formulario',
                  child: TechnicianChannelCards(
                    phone: report.contacts.phone,
                    whatsapp: report.contacts.whatsapp,
                  ),
                ),
              ],
              if (report.summaryMessage.isNotEmpty) ...[
                const SizedBox(height: 20),
                _InsightBanner(message: report.summaryMessage),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selected,
    required this.onSelected,
  });

  final TechnicianPerformancePeriodKey selected;
  final ValueChanged<TechnicianPerformancePeriodKey> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: TechnicianPerformancePeriodKey.values.map((period) {
          final isSelected = period == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(period.label),
              selected: isSelected,
              onSelected: (_) => onSelected(period),
              showCheckmark: false,
              labelStyle: TechnicianPanelTheme.chip.copyWith(
                color: isSelected ? Colors.white : TechnicianPanelColors.ink,
              ),
              selectedColor: TechnicianPanelColors.primary,
              backgroundColor: TechnicianPanelColors.surface,
              side: BorderSide(
                color: isSelected
                    ? TechnicianPanelColors.primary
                    : TechnicianPanelColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({required this.report});

  final TechnicianPerformanceReportModel report;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            TechnicianPanelColors.primary.withValues(alpha: 0.14),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TechnicianPanelColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.period.label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: TechnicianPanelColors.inkSoft,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  icon: Icons.visibility_outlined,
                  value: '${report.profileViews}',
                  label: 'Vieron tu perfil',
                ),
              ),
              Container(
                width: 1,
                height: 48,
                color: TechnicianPanelColors.border,
              ),
              Expanded(
                child: _HeroMetric(
                  icon: Icons.assignment_outlined,
                  value: '${report.contacts.total}',
                  label: 'Dejaron sus datos',
                ),
              ),
            ],
          ),
          if (report.conversionRate != null && report.profileViews > 0) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: TechnicianPanelColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${report.conversionRate!.toStringAsFixed(1)}% de las visitas completaron el formulario',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: TechnicianPanelColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
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
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: TechnicianPanelColors.ink,
            height: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TechnicianPanelTheme.label,
        ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({required this.comparison});

  final TechnicianPerformanceComparisonModel comparison;

  @override
  Widget build(BuildContext context) {
    return TechnicianPanelCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vs ${comparison.previousPeriodLabel}',
            style: TechnicianPanelTheme.label,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _DeltaChip(
                label: 'Vistas',
                delta: comparison.profileViewsDelta,
              ),
              _DeltaChip(
                label: 'Con datos',
                delta: comparison.contactsDelta,
              ),
              if (comparison.conversionRateDelta != null)
                _DeltaChip(
                  label: 'Conversión',
                  delta: comparison.conversionRateDelta!.round(),
                  suffix: ' pp',
                  showSign: true,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({
    required this.label,
    required this.delta,
    this.suffix = '',
    this.showSign = false,
  });

  final String label;
  final int delta;
  final String suffix;
  final bool showSign;

  @override
  Widget build(BuildContext context) {
    final isPositive = delta > 0;
    final isNeutral = delta == 0;
    final color = isNeutral
        ? TechnicianPanelColors.inkSoft
        : isPositive
            ? TechnicianPanelColors.success
            : const Color(0xFFDC2626);
    final bg = isNeutral
        ? TechnicianPanelColors.background
        : isPositive
            ? TechnicianPanelColors.successSoft
            : const Color(0xFFFEF2F2);
    final sign = showSign && delta > 0 ? '+' : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isNeutral)
            Icon(
              isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 14,
              color: color,
            ),
          if (!isNeutral) const SizedBox(width: 4),
          Text(
            '$label: $sign$delta$suffix',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.buckets});

  final List<TechnicianPerformanceBucketModel> buckets;

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) {
      return TechnicianPanelCard(
        child: Text(
          'Aún no hay datos suficientes para mostrar la tendencia.',
          style: TechnicianPanelTheme.body,
        ),
      );
    }

    final maxViews = buckets
        .map((b) => b.profileViews)
        .fold(0, (a, b) => a > b ? a : b);
    final maxContacts = buckets
        .map((b) => b.contacts.total)
        .fold(0, (a, b) => a > b ? a : b);
    final maxValue = [maxViews, maxContacts, 1].reduce((a, b) => a > b ? a : b);

    return TechnicianPanelCard(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: buckets.map((bucket) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _Bar(
                                value: bucket.profileViews,
                                maxValue: maxValue,
                                color: TechnicianPanelColors.primary
                                    .withValues(alpha: 0.85),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: _Bar(
                                value: bucket.contacts.total,
                                maxValue: maxValue,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bucket.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TechnicianPanelTheme.label.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _ChartLegend(
                color: Color(0xCC76B72A),
                label: 'Vistas',
              ),
              SizedBox(width: 16),
              _ChartLegend(
                color: Color(0xFF2563EB),
                label: 'Con datos',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.maxValue,
    required this.color,
  });

  final int value;
  final int maxValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = value / maxValue;
    final height = (120 * fraction).clamp(value > 0 ? 6.0 : 0.0, 120.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: TechnicianPanelTheme.label),
      ],
    );
  }
}

class _FunnelSummary extends StatelessWidget {
  const _FunnelSummary({required this.report});

  final TechnicianPerformanceReportModel report;

  @override
  Widget build(BuildContext context) {
    final views = report.profileViews;
    final contacts = report.contacts.total;
    final viewsFlex = views > 0 ? views : 1;
    final contactsFlex = contacts > 0 ? contacts : 0;

    return TechnicianPanelCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              children: [
                _FunnelStep(
                  label: 'Vieron tu perfil',
                  value: views,
                  flex: viewsFlex,
                  color: TechnicianPanelColors.primary.withValues(alpha: 0.2),
                  textColor: TechnicianPanelColors.primary,
                ),
                if (contactsFlex > 0)
                  _FunnelStep(
                    label: 'Dejaron sus datos',
                    value: contacts,
                    flex: contactsFlex,
                    color: const Color(0xFF2563EB).withValues(alpha: 0.18),
                    textColor: const Color(0xFF2563EB),
                  ),
              ],
            ),
          ),
          if (views == 0 && contacts == 0) ...[
            const SizedBox(height: 12),
            Text(
              'Comparte tu perfil y completa fotos, servicios y zona para empezar a recibir visitas.',
              style: TechnicianPanelTheme.subtitle,
            ),
          ],
        ],
      ),
    );
  }
}

class _FunnelStep extends StatelessWidget {
  const _FunnelStep({
    required this.label,
    required this.value,
    required this.flex,
    required this.color,
    required this.textColor,
  });

  final String label;
  final int value;
  final int flex;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widthFactor = (flex / (flex + 4)).clamp(0.45, 1.0);
        return Container(
          width: double.infinity,
          color: color,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: widthFactor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    '$value',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InsightBanner extends StatelessWidget {
  const _InsightBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TechnicianPanelColors.warningSoft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: TechnicianPanelColors.warning.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline_rounded,
            size: 20,
            color: TechnicianPanelColors.warning,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: TechnicianPanelColors.ink,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
