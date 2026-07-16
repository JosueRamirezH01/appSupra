import 'package:flutter/material.dart';

import '../widgets/technician/technician_panel_theme.dart';

/// Etiquetas y copy de UX para el estado de verificación del técnico.
class TechnicianVerificationStatus {
  TechnicianVerificationStatus._();

  static const pendingPollInterval = Duration(seconds: 90);

  /// Copy reutilizable: la verificación no bloquea el perfil técnico.
  static const profileActiveNote =
      'Tu perfil técnico sigue activo. La verificación solo otorga la insignia de confianza visible para los clientes.';

  static bool isApproved({required String? status, required bool verified}) =>
      verified || status == 'aprobado';

  static bool isPending(String? status) => status == 'pendiente';

  static bool isRejected(String? status) => status == 'rechazado';

  static bool isUnverified(String? status, {required bool verified}) =>
      !verified &&
      (status == null || status == 'sin_verificar' || status.isEmpty);

  /// Etiqueta corta para chips y stats.
  static String shortLabel({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) return 'Insignia activa';
    return switch (status) {
      'pendiente' => 'Insignia en revisión',
      'rechazado' => 'Rechazada',
      'sin_verificar' => 'Sin enviar',
      _ => 'Pendiente',
    };
  }

  /// Título principal en pantalla de solicitud.
  static String title({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) {
      return '¡Insignia verificada!';
    }
    return switch (status) {
      'pendiente' => 'Verificación de identidad en revisión',
      'rechazado' => 'Documentos de verificación rechazados',
      'sin_verificar' => 'Obtén tu insignia verificada',
      _ => 'Estado de verificación',
    };
  }

  /// Mensaje descriptivo para banner y pantalla de solicitud.
  static String message({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) {
      return 'Tu insignia de confianza ya es visible para los clientes.';
    }
    return switch (status) {
      'pendiente' =>
        'Recibimos tus documentos. Te avisaremos cuando finalice la revisión (24–48 h hábiles). $profileActiveNote',
      'rechazado' =>
        'Revisa el motivo indicado y vuelve a enviar los documentos corregidos. $profileActiveNote',
      'sin_verificar' =>
        'Sube tu documento y foto de rostro para obtener la insignia verificada. Es opcional: puedes seguir usando la app como técnico.',
      _ => 'Completa la verificación de identidad para mostrar la insignia de confianza a los clientes.',
    };
  }

  /// Subtítulo del tile "Estado de solicitud" en acciones rápidas.
  static String quickActionSubtitle({
    required String? status,
    required bool verified,
    DateTime? submittedAt,
  }) {
    if (isApproved(status: status, verified: verified)) {
      return 'Insignia activa en tu perfil público';
    }
    if (isPending(status)) {
      if (submittedAt != null) {
        return 'Insignia en revisión — enviado el ${formatShortDate(submittedAt)}';
      }
      return 'Insignia en revisión — te avisaremos cuando termine';
    }
    if (isRejected(status)) {
      return 'Rechazada — reenvía documentos para la insignia';
    }
    return 'Opcional — sube documentos para la insignia';
  }

  /// Badge opcional en acciones rápidas.
  static String? quickActionBadge({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) return 'Insignia';
    if (isPending(status)) return 'En revisión';
    if (isRejected(status)) return 'Acción';
    if (isUnverified(status, verified: verified)) return 'Pendiente';
    return null;
  }

  static Color accentColor({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) {
      return TechnicianPanelColors.success;
    }
    return switch (status) {
      'pendiente' => TechnicianPanelColors.warning,
      'rechazado' => const Color(0xFFB91C1C),
      _ => TechnicianPanelColors.primary,
    };
  }

  static Color accentBackground({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) {
      return TechnicianPanelColors.successSoft;
    }
    return switch (status) {
      'pendiente' => TechnicianPanelColors.warningSoft,
      'rechazado' => const Color(0xFFFEF2F2),
      _ => TechnicianPanelColors.primarySoft,
    };
  }

  static IconData icon({required String? status, required bool verified}) {
    if (isApproved(status: status, verified: verified)) {
      return Icons.verified_rounded;
    }
    return switch (status) {
      'pendiente' => Icons.hourglass_top_rounded,
      'rechazado' => Icons.error_outline_rounded,
      _ => Icons.verified_user_outlined,
    };
  }

  static String formatShortDate(DateTime dateTime) {
    const months = [
      'ene',
      'feb',
      'mar',
      'abr',
      'may',
      'jun',
      'jul',
      'ago',
      'sep',
      'oct',
      'nov',
      'dic',
    ];
    final local = dateTime.toLocal();
    final month = months[local.month - 1];
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day} $month, $hour:$minute';
  }

  static String formatRelative(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'hace un momento';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'hace ${diff.inDays} d';
    return formatShortDate(dateTime);
  }
}
