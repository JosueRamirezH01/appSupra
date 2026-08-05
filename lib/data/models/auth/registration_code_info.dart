/// Respuesta de envío de OTP (registro o recuperación).
class RegistrationCodeInfo {
  const RegistrationCodeInfo({
    required this.email,
    required this.expiresInSeconds,
    required this.resendAvailableInSeconds,
    this.codeSent = true,
  });

  final String email;
  final int expiresInSeconds;
  final int resendAvailableInSeconds;

  /// En recuperación: false si el correo no es elegible (no existe / Google / inactivo).
  /// En registro suele omitirse y se asume true.
  final bool codeSent;

  factory RegistrationCodeInfo.fromJson(Map<String, dynamic> json) {
    return RegistrationCodeInfo(
      email: json['email'] as String? ?? '',
      expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 600,
      resendAvailableInSeconds:
          (json['resendAvailableInSeconds'] as num?)?.toInt() ?? 60,
      codeSent: json['codeSent'] as bool? ?? true,
    );
  }
}
