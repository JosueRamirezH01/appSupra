import 'technician_activity_model.dart';

enum TechnicianPerformancePeriodKey {
  thisWeek('this_week', 'Esta semana'),
  thisMonth('this_month', 'Este mes'),
  previousMonth('previous_month', 'Mes anterior'),
  last3Months('last_3_months', 'Últimos 3 meses');

  const TechnicianPerformancePeriodKey(this.apiValue, this.label);

  final String apiValue;
  final String label;

  static TechnicianPerformancePeriodKey fromApi(String value) {
    return TechnicianPerformancePeriodKey.values.firstWhere(
      (item) => item.apiValue == value,
      orElse: () => TechnicianPerformancePeriodKey.thisMonth,
    );
  }
}

class TechnicianPerformancePeriodMetaModel {
  const TechnicianPerformancePeriodMetaModel({
    required this.key,
    required this.label,
    required this.from,
    required this.to,
  });

  final TechnicianPerformancePeriodKey key;
  final String label;
  final DateTime from;
  final DateTime to;

  factory TechnicianPerformancePeriodMetaModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TechnicianPerformancePeriodMetaModel(
      key: TechnicianPerformancePeriodKey.fromApi(json['key'] as String? ?? ''),
      label: json['label'] as String? ?? '',
      from: DateTime.tryParse(json['from'] as String? ?? '') ?? DateTime.now(),
      to: DateTime.tryParse(json['to'] as String? ?? '') ?? DateTime.now(),
    );
  }
}

class TechnicianPerformanceComparisonModel {
  const TechnicianPerformanceComparisonModel({
    required this.profileViewsDelta,
    required this.contactsDelta,
    required this.conversionRateDelta,
    required this.previousPeriodLabel,
  });

  final int profileViewsDelta;
  final int contactsDelta;
  final double? conversionRateDelta;
  final String previousPeriodLabel;

  factory TechnicianPerformanceComparisonModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TechnicianPerformanceComparisonModel(
      profileViewsDelta: json['profileViewsDelta'] as int? ?? 0,
      contactsDelta: json['contactsDelta'] as int? ?? 0,
      conversionRateDelta: (json['conversionRateDelta'] as num?)?.toDouble(),
      previousPeriodLabel: json['previousPeriodLabel'] as String? ?? '',
    );
  }
}

class TechnicianPerformanceBucketModel {
  const TechnicianPerformanceBucketModel({
    required this.label,
    required this.from,
    required this.to,
    required this.profileViews,
    required this.contacts,
  });

  final String label;
  final DateTime from;
  final DateTime to;
  final int profileViews;
  final TechnicianContactStatsModel contacts;

  factory TechnicianPerformanceBucketModel.fromJson(Map<String, dynamic> json) {
    return TechnicianPerformanceBucketModel(
      label: json['label'] as String? ?? '',
      from: DateTime.tryParse(json['from'] as String? ?? '') ?? DateTime.now(),
      to: DateTime.tryParse(json['to'] as String? ?? '') ?? DateTime.now(),
      profileViews: json['profileViews'] as int? ?? 0,
      contacts: TechnicianContactStatsModel.fromJson(
        json['contacts'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class TechnicianPerformanceReportModel {
  const TechnicianPerformanceReportModel({
    required this.period,
    required this.profileViews,
    required this.contacts,
    required this.conversionRate,
    required this.comparisonPreviousPeriod,
    required this.trendBuckets,
    required this.summaryMessage,
  });

  final TechnicianPerformancePeriodMetaModel period;
  final int profileViews;
  final TechnicianContactStatsModel contacts;
  final double? conversionRate;
  final TechnicianPerformanceComparisonModel? comparisonPreviousPeriod;
  final List<TechnicianPerformanceBucketModel> trendBuckets;
  final String summaryMessage;

  factory TechnicianPerformanceReportModel.fromJson(Map<String, dynamic> json) {
    return TechnicianPerformanceReportModel(
      period: TechnicianPerformancePeriodMetaModel.fromJson(
        json['period'] as Map<String, dynamic>? ?? const {},
      ),
      profileViews: json['profileViews'] as int? ?? 0,
      contacts: TechnicianContactStatsModel.fromJson(
        json['contacts'] as Map<String, dynamic>? ?? const {},
      ),
      conversionRate: (json['conversionRate'] as num?)?.toDouble(),
      comparisonPreviousPeriod: json['comparisonPreviousPeriod'] == null
          ? null
          : TechnicianPerformanceComparisonModel.fromJson(
              json['comparisonPreviousPeriod'] as Map<String, dynamic>,
            ),
      trendBuckets: (json['trendBuckets'] as List<dynamic>? ?? const [])
          .map(
            (item) => TechnicianPerformanceBucketModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList(),
      summaryMessage: json['summaryMessage'] as String? ?? '',
    );
  }
}
