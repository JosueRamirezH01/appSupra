class TechnicianContactStatsModel {
  const TechnicianContactStatsModel({
    required this.total,
    required this.phone,
    required this.whatsapp,
  });

  final int total;
  final int phone;
  final int whatsapp;

  factory TechnicianContactStatsModel.fromJson(Map<String, dynamic> json) {
    return TechnicianContactStatsModel(
      total: json['total'] as int? ?? 0,
      phone: json['phone'] as int? ?? 0,
      whatsapp: json['whatsapp'] as int? ?? 0,
    );
  }
}

class TechnicianActivityPeriodModel {
  const TechnicianActivityPeriodModel({
    required this.profileViews,
    required this.contacts,
  });

  final int profileViews;
  final TechnicianContactStatsModel contacts;

  factory TechnicianActivityPeriodModel.fromJson(Map<String, dynamic> json) {
    return TechnicianActivityPeriodModel(
      profileViews: json['profileViews'] as int? ?? 0,
      contacts: TechnicianContactStatsModel.fromJson(
        json['contacts'] as Map<String, dynamic>? ?? const {},
      ),
    );
  }
}

class TechnicianActivityStatsModel {
  const TechnicianActivityStatsModel({
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.conversionRateThisWeek,
  });

  final TechnicianActivityPeriodModel today;
  final TechnicianActivityPeriodModel thisWeek;
  final TechnicianActivityPeriodModel thisMonth;
  final double? conversionRateThisWeek;

  factory TechnicianActivityStatsModel.fromJson(Map<String, dynamic> json) {
    return TechnicianActivityStatsModel(
      today: TechnicianActivityPeriodModel.fromJson(
        json['today'] as Map<String, dynamic>? ?? const {},
      ),
      thisWeek: TechnicianActivityPeriodModel.fromJson(
        json['thisWeek'] as Map<String, dynamic>? ?? const {},
      ),
      thisMonth: TechnicianActivityPeriodModel.fromJson(
        json['thisMonth'] as Map<String, dynamic>? ?? const {},
      ),
      conversionRateThisWeek:
          (json['conversionRateThisWeek'] as num?)?.toDouble(),
    );
  }
}

class RecordTechnicianProfileViewResult {
  const RecordTechnicianProfileViewResult({required this.recorded});

  final bool recorded;

  factory RecordTechnicianProfileViewResult.fromJson(Map<String, dynamic> json) {
    return RecordTechnicianProfileViewResult(
      recorded: json['recorded'] as bool? ?? false,
    );
  }
}
