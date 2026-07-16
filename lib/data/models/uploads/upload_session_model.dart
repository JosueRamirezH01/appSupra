class UploadSessionModel {
  const UploadSessionModel({
    required this.sessionId,
    required this.uploadToken,
    required this.expiresAt,
    required this.expiresInSeconds,
  });

  final String sessionId;
  final String uploadToken;
  final String expiresAt;
  final int expiresInSeconds;

  factory UploadSessionModel.fromJson(Map<String, dynamic> json) {
    return UploadSessionModel(
      sessionId: json['sessionId'] as String,
      uploadToken: json['uploadToken'] as String,
      expiresAt: json['expiresAt'] as String,
      expiresInSeconds: (json['expiresInSeconds'] as num).toInt(),
    );
  }
}
