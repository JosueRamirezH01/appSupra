class SellerLocationModel {
  const SellerLocationModel({
    required this.lat,
    required this.lng,
    this.address,
  });

  factory SellerLocationModel.fromJson(Map<String, dynamic> json) {
    return SellerLocationModel(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String?,
    );
  }

  final double lat;
  final double lng;
  final String? address;
}

class SellerPublicModel {
  const SellerPublicModel({
    required this.id,
    required this.name,
    required this.businessName,
    required this.ruc,
    required this.legalRepresentativeName,
    required this.phone,
    this.description,
    this.logoUrl,
    this.locationAddress,
    required this.verified,
    required this.verificationStatus,
    required this.productCount,
  });

  factory SellerPublicModel.fromJson(Map<String, dynamic> json) {
    return SellerPublicModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      businessName: json['businessName'] as String,
      ruc: json['ruc'] as String,
      legalRepresentativeName: json['legalRepresentativeName'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      locationAddress: json['locationAddress'] as String?,
      verified: json['verified'] as bool? ?? false,
      verificationStatus: json['verificationStatus'] as String? ?? 'sin_verificar',
      productCount: json['productCount'] as int? ?? 0,
    );
  }

  final int id;
  final String name;
  final String businessName;
  final String ruc;
  final String legalRepresentativeName;
  final String phone;
  final String? description;
  final String? logoUrl;
  final String? locationAddress;
  final bool verified;
  final String verificationStatus;
  final int productCount;
}

class SellerApplicationModel extends SellerPublicModel {
  const SellerApplicationModel({
    required super.id,
    required super.name,
    required super.businessName,
    required super.ruc,
    required super.legalRepresentativeName,
    required super.phone,
    super.description,
    super.logoUrl,
    super.locationAddress,
    required super.verified,
    required super.verificationStatus,
    required super.productCount,
    this.location,
    required this.hasLocation,
    this.rucDocumentUrl,
    this.rejectionReason,
    required this.submittedAt,
    this.reviewedAt,
    required this.canSubmitVerification,
  });

  factory SellerApplicationModel.fromJson(Map<String, dynamic> json) {
    return SellerApplicationModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      businessName: json['businessName'] as String,
      ruc: json['ruc'] as String,
      legalRepresentativeName: json['legalRepresentativeName'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      locationAddress: json['locationAddress'] as String?,
      verified: json['verified'] as bool? ?? false,
      verificationStatus: json['verificationStatus'] as String? ?? 'sin_verificar',
      productCount: json['productCount'] as int? ?? 0,
      location: json['location'] == null
          ? null
          : SellerLocationModel.fromJson(json['location'] as Map<String, dynamic>),
      hasLocation: json['hasLocation'] as bool? ?? false,
      rucDocumentUrl: json['rucDocumentUrl'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      submittedAt: json['submittedAt'] as String? ?? '',
      reviewedAt: json['reviewedAt'] as String?,
      canSubmitVerification: json['canSubmitVerification'] as bool? ?? false,
    );
  }

  final SellerLocationModel? location;
  final bool hasLocation;

  final String? rucDocumentUrl;
  final String? rejectionReason;
  final String submittedAt;
  final String? reviewedAt;
  final bool canSubmitVerification;
}

enum SellerContactChannel {
  phone,
  whatsapp;

  String get apiValue => name;
}

class SubmitSellerContactRequest {
  const SubmitSellerContactRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.channel,
    required this.acceptedTerms,
    this.message,
    this.productId,
    this.subcategoryId,
    this.marketingConsent = false,
  });

  final String name;
  final String email;
  final String phone;
  final SellerContactChannel channel;
  final String? message;
  final int? productId;
  final int? subcategoryId;
  final bool acceptedTerms;
  final bool marketingConsent;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'channel': channel.apiValue,
        if (message != null && message!.trim().isNotEmpty) 'message': message!.trim(),
        if (productId != null) 'productId': productId,
        if (subcategoryId != null) 'subcategoryId': subcategoryId,
        'acceptedTerms': acceptedTerms,
        'marketingConsent': marketingConsent,
      };
}

class SubmitSellerVerificationRequest {
  const SubmitSellerVerificationRequest({
    required this.rucDocumentUrl,
    this.logoUrl,
  });

  final String rucDocumentUrl;
  final String? logoUrl;

  Map<String, dynamic> toJson() => {
        'rucDocumentUrl': rucDocumentUrl,
        if (logoUrl != null && logoUrl!.isNotEmpty) 'logoUrl': logoUrl,
      };
}

class UpdateSellerProfileRequest {
  const UpdateSellerProfileRequest({
    this.businessName,
    this.phone,
    this.description,
    this.logoUrl,
    this.locationAddress,
    this.locationLat,
    this.locationLng,
  });

  final String? businessName;
  final String? phone;
  final String? description;
  final String? logoUrl;
  final String? locationAddress;
  final double? locationLat;
  final double? locationLng;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (businessName != null) json['businessName'] = businessName;
    if (phone != null) json['phone'] = phone;
    if (description != null) json['description'] = description;
    if (logoUrl != null) json['logoUrl'] = logoUrl;
    if (locationAddress != null) json['locationAddress'] = locationAddress;
    if (locationLat != null) json['locationLat'] = locationLat;
    if (locationLng != null) json['locationLng'] = locationLng;
    return json;
  }
}

class SellerContactLeadResult {
  const SellerContactLeadResult({
    required this.id,
    required this.sellerId,
    required this.channel,
    required this.createdAt,
    this.productId,
  });

  factory SellerContactLeadResult.fromJson(Map<String, dynamic> json) {
    return SellerContactLeadResult(
      id: json['id'] as int,
      sellerId: json['sellerId'] as int,
      productId: json['productId'] as int?,
      channel: json['channel'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  final int id;
  final int sellerId;
  final int? productId;
  final String channel;
  final String createdAt;
}
