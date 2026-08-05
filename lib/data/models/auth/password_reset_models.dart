/// Respuesta de `POST /auth/forgot-password/verify`.
class PasswordResetVerifyResult {
  const PasswordResetVerifyResult({
    required this.resetToken,
    required this.expiresInSeconds,
  });

  final String resetToken;
  final int expiresInSeconds;

  factory PasswordResetVerifyResult.fromJson(Map<String, dynamic> json) {
    return PasswordResetVerifyResult(
      resetToken: json['resetToken'] as String? ?? '',
      expiresInSeconds: (json['expiresInSeconds'] as num?)?.toInt() ?? 600,
    );
  }
}

/// Args para la pantalla de nueva contraseña (via `GoRouterState.extra`).
class PasswordResetNewArgs {
  const PasswordResetNewArgs({
    required this.email,
    required this.resetToken,
  });

  final String email;
  final String resetToken;
}
