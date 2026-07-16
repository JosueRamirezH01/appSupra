import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth/auth_ui.dart';

class VerificationStatusCard extends StatelessWidget {
  const VerificationStatusCard({
    super.key,
    required this.status,
    required this.verified,
    this.rejectionReason,
    this.onAction,
    this.actionLabel,
  });

  final String? status;
  final bool verified;
  final String? rejectionReason;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final data = _resolve(status, verified);

    return Card(
      elevation: 0,
      color: data.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: data.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(data.icon, color: data.foreground),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    data.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: data.foreground,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              data.subtitle,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppBrandColors.textDark,
                height: 1.4,
              ),
            ),
            if (rejectionReason != null && rejectionReason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Motivo: $rejectionReason',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.red.shade700,
                ),
              ),
            ],
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _StatusData _resolve(String? status, bool verified) {
    if (verified || status == 'aprobado') {
      return const _StatusData(
        title: 'Insignia verificada',
        subtitle:
            'Tu perfil técnico sigue activo. Los clientes verán tu insignia de confianza.',
        icon: Icons.verified,
        foreground: Color(0xFF15803D),
        background: Color(0xFFE8F8EE),
        border: Color(0xFF86EFAC),
      );
    }

    return switch (status) {
      'pendiente' => const _StatusData(
          title: 'Insignia en revisión',
          subtitle:
              'Recibimos tus documentos. Te avisaremos cuando finalice la revisión. Tu perfil técnico sigue activo.',
          icon: Icons.hourglass_top_rounded,
          foreground: Color(0xFFB45309),
          background: Color(0xFFFFF7ED),
          border: Color(0xFFFDBA74),
        ),
      'rechazado' => const _StatusData(
          title: 'Documentos rechazados',
          subtitle:
              'Revisa el motivo y reenvía documentos para obtener la insignia. Tu perfil técnico sigue activo.',
          icon: Icons.error_outline,
          foreground: Color(0xFFB91C1C),
          background: Color(0xFFFEF2F2),
          border: Color(0xFFFCA5A5),
        ),
      _ => const _StatusData(
          title: 'Sin insignia verificada',
          subtitle:
              'Sube tus documentos para mostrar la insignia de confianza. Es opcional: puedes seguir usando la app como técnico.',
          icon: Icons.verified_user_outlined,
          foreground: Color(0xFF1D4ED8),
          background: Color(0xFFEFF6FF),
          border: Color(0xFF93C5FD),
        ),
    };
  }
}

class _StatusData {
  const _StatusData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color foreground;
  final Color background;
  final Color border;
}
