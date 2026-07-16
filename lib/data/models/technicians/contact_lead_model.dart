enum TechnicianContactChannel {
  phone,
  whatsapp;

  String get apiValue => name;
}

enum ContactMetricType {
  none,
  area,
  quantity;

  static ContactMetricType fromJson(String? value) {
    return ContactMetricType.values.firstWhere(
      (item) => item.name == value,
      orElse: () => ContactMetricType.none,
    );
  }
}

class SubmitTechnicianContactRequest {
  const SubmitTechnicianContactRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.channel,
    required this.acceptedTerms,
    this.message,
    this.subcategoryId,
    this.subSubCategoryId,
    this.metricValue,
    this.marketingConsent = false,
  });

  final String name;
  final String email;
  final String phone;
  final TechnicianContactChannel channel;
  final String? message;
  final int? subcategoryId;
  final int? subSubCategoryId;
  final double? metricValue;
  final bool acceptedTerms;
  final bool marketingConsent;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'channel': channel.apiValue,
        if (message != null && message!.trim().isNotEmpty) 'message': message!.trim(),
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
        if (subSubCategoryId != null) 'subSubCategoryId': subSubCategoryId,
        if (metricValue != null) 'metricValue': metricValue,
        'acceptedTerms': acceptedTerms,
        'marketingConsent': marketingConsent,
      };
}

class TechnicianContactLeadResult {
  const TechnicianContactLeadResult({
    required this.id,
    required this.technicianId,
    required this.channel,
    required this.createdAt,
  });

  factory TechnicianContactLeadResult.fromJson(Map<String, dynamic> json) {
    return TechnicianContactLeadResult(
      id: json['id'] as int,
      technicianId: json['technicianId'] as int,
      channel: json['channel'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  final int id;
  final int technicianId;
  final String channel;
  final String createdAt;
}

class TechnicianContactLeadItemModel {
  const TechnicianContactLeadItemModel({
    required this.id,
    required this.channel,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.createdAt,
    this.message,
    this.subcategoryName,
    this.subSubCategoryName,
    this.contactMetricType,
    this.metricValue,
  });

  factory TechnicianContactLeadItemModel.fromJson(Map<String, dynamic> json) {
    return TechnicianContactLeadItemModel(
      id: json['id'] as int,
      channel: json['channel'] as String,
      guestName: json['guestName'] as String,
      guestEmail: json['guestEmail'] as String,
      guestPhone: json['guestPhone'] as String,
      message: json['message'] as String?,
      subcategoryName: json['subcategoryName'] as String?,
      subSubCategoryName: json['subSubCategoryName'] as String?,
      contactMetricType: json['contactMetricType'] == null
          ? null
          : ContactMetricType.fromJson(json['contactMetricType'] as String?),
      metricValue: (json['metricValue'] as num?)?.toDouble(),
      createdAt: json['createdAt'] as String,
    );
  }

  final int id;
  final String channel;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final String? message;
  final String? subcategoryName;
  final String? subSubCategoryName;
  final ContactMetricType? contactMetricType;
  final double? metricValue;
  final String createdAt;
}

class TechnicianContactLeadsPageModel {
  const TechnicianContactLeadsPageModel({
    required this.contacts,
    required this.page,
    required this.limit,
    required this.total,
  });

  factory TechnicianContactLeadsPageModel.fromJson(Map<String, dynamic> json) {
    final contacts = (json['contacts'] as List<dynamic>? ?? const [])
        .map(
          (item) => TechnicianContactLeadItemModel.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();

    return TechnicianContactLeadsPageModel(
      contacts: contacts,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 10,
      total: json['total'] as int? ?? contacts.length,
    );
  }

  final List<TechnicianContactLeadItemModel> contacts;
  final int page;
  final int limit;
  final int total;
}
