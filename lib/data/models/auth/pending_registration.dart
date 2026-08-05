import 'dart:convert';

/// Registro en curso guardado localmente (secure storage) mientras el usuario
/// verifica su correo. La cuenta NO existe en el backend hasta confirmar el OTP.
class PendingRegistration {
  const PendingRegistration({
    required this.role,
    required this.email,
    required this.payload,
  });

  /// 'cliente' | 'tecnico' | 'vendedor'
  final String role;
  final String email;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {
        'role': role,
        'email': email,
        'payload': payload,
      };

  factory PendingRegistration.fromJson(Map<String, dynamic> json) {
    return PendingRegistration(
      role: json['role'] as String,
      email: json['email'] as String,
      payload: Map<String, dynamic>.from(json['payload'] as Map),
    );
  }

  String encode() => jsonEncode(toJson());

  static PendingRegistration decode(String raw) =>
      PendingRegistration.fromJson(jsonDecode(raw) as Map<String, dynamic>);
}
