import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/technicians/technician_model.dart';

/// Tema visual del perfil según tipo (mockup: verde / azul).
class ClientTechnicianProfileTheme {
  const ClientTechnicianProfileTheme({
    required this.accent,
    required this.accentSoft,
    required this.accentBorder,
    required this.primaryCtaLabel,
    required this.isEmpresa,
  });

  final Color accent;
  final Color accentSoft;
  final Color accentBorder;
  final String primaryCtaLabel;
  final bool isEmpresa;

  factory ClientTechnicianProfileTheme.fromProfileType(String profileType) {
    if (profileType == 'empresa') {
      return const ClientTechnicianProfileTheme(
        accent: Color(0xFF0D3B66),
        accentSoft: Color(0xFFEFF6FF),
        accentBorder: Color(0xFFBFDBFE),
        primaryCtaLabel: 'Solicitar cotización',
        isEmpresa: true,
      );
    }

    return const ClientTechnicianProfileTheme(
      accent: AppBrandColors.primaryGreen,
      accentSoft: AppBrandColors.fieldFill,
      accentBorder: Color(0xFFBBF7D0),
      primaryCtaLabel: 'Solicitar servicio',
      isEmpresa: false,
    );
  }
}

class ProfileTrustBadgeUi {
  const ProfileTrustBadgeUi({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class ProfileMetricUi {
  const ProfileMetricUi({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;
}

/// Capa de presentación: mapea [TechnicianPublicModel] → UI (solo datos reales del API).
class ClientTechnicianProfileUiModel {
  ClientTechnicianProfileUiModel._({
    required this.technician,
    required this.theme,
    required this.trustBadges,
    required this.metrics,
    required this.specialtiesTitle,
    required this.workPhotosTitle,
    required this.portfolioTitle,
    required this.aboutTitle,
  });

  final TechnicianPublicModel technician;
  final ClientTechnicianProfileTheme theme;
  final List<ProfileTrustBadgeUi> trustBadges;
  final List<ProfileMetricUi> metrics;
  final String specialtiesTitle;
  final String workPhotosTitle;
  final String portfolioTitle;
  final String aboutTitle;

  factory ClientTechnicianProfileUiModel.from(TechnicianPublicModel technician) {
    final theme = ClientTechnicianProfileTheme.fromProfileType(
      technician.profileType,
    );

    return ClientTechnicianProfileUiModel._(
      technician: technician,
      theme: theme,
      trustBadges: _buildTrustBadges(technician, theme),
      metrics: _buildMetrics(technician, theme.isEmpresa),
      specialtiesTitle:
          theme.isEmpresa ? 'Servicios que ofrecemos' : 'Especialidades',
      workPhotosTitle:
          theme.isEmpresa ? 'Galería de trabajos' : 'Trabajos realizados',
      portfolioTitle:
          theme.isEmpresa ? 'Proyectos destacados' : 'Portafolio',
      aboutTitle: theme.isEmpresa ? 'Sobre la empresa' : 'Sobre mí',
    );
  }

  bool get isVerified =>
      technician.verified || technician.verificationStatus == 'aprobado';

  String? get coverUrl {
    if (technician.workPhotos.isNotEmpty) {
      return technician.workPhotos.first.imageUrl;
    }
    for (final item in technician.portfolio) {
      if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
        return item.imageUrl;
      }
    }
    return technician.profilePhotoUrl;
  }

  String? get serviceArea =>
      technician.location?.address ?? technician.address;

  String? get shortLocation {
    final area = serviceArea;
    if (area == null || area.isEmpty) return null;
    final parts = area.split(',');
    return parts.take(2).join(',').trim();
  }

  bool get hasAbout =>
      technician.description != null &&
      technician.description!.trim().isNotEmpty;

  bool get hasSchedule {
    final schedule = technician.schedule;
    if (schedule == null) return false;
    return [
      schedule.monday,
      schedule.tuesday,
      schedule.wednesday,
      schedule.thursday,
      schedule.friday,
      schedule.saturday,
      schedule.sunday,
    ].any((day) => day?.enabled == true);
  }

  bool get hasPhone =>
      technician.phone != null && technician.phone!.trim().isNotEmpty;

  static List<ProfileTrustBadgeUi> _buildTrustBadges(
    TechnicianPublicModel technician,
    ClientTechnicianProfileTheme theme,
  ) {
    final badges = <ProfileTrustBadgeUi>[];

    if (technician.verified || technician.verificationStatus == 'aprobado') {
      badges.add(
        ProfileTrustBadgeUi(
          icon: theme.isEmpresa
              ? Icons.apartment_rounded
              : Icons.verified_user_rounded,
          label: theme.isEmpresa
              ? 'Empresa verificada'
              : 'Identidad verificada',
        ),
      );
    }

    if (_hasSchedule(technician)) {
      badges.add(
        const ProfileTrustBadgeUi(
          icon: Icons.schedule_rounded,
          label: 'Horario publicado',
        ),
      );
    }

    if (technician.location != null) {
      badges.add(
        const ProfileTrustBadgeUi(
          icon: Icons.location_on_rounded,
          label: 'Zona de servicio',
        ),
      );
    }

    return badges;
  }

  static bool _hasSchedule(TechnicianPublicModel technician) {
    final schedule = technician.schedule;
    if (schedule == null) return false;
    return [
      schedule.monday,
      schedule.tuesday,
      schedule.wednesday,
      schedule.thursday,
      schedule.friday,
      schedule.saturday,
      schedule.sunday,
    ].any((day) => day?.enabled == true);
  }

  static List<ProfileMetricUi> _buildMetrics(
    TechnicianPublicModel technician,
    bool isEmpresa,
  ) {
    final metrics = <ProfileMetricUi>[];

    if (technician.averageRating != null) {
      metrics.add(
        ProfileMetricUi(
          icon: Icons.star_rounded,
          label: 'Calificación',
          value: technician.averageRating!.toStringAsFixed(1),
        ),
      );
    }

    if (technician.ratingCount > 0) {
      metrics.add(
        ProfileMetricUi(
          icon: Icons.rate_review_outlined,
          label: isEmpresa ? 'Valoraciones' : 'Opiniones',
          value: '${technician.ratingCount}',
        ),
      );
    }

    if (technician.experienceYears != null) {
      metrics.add(
        ProfileMetricUi(
          icon: Icons.workspace_premium_outlined,
          label: isEmpresa ? 'En el mercado' : 'Experiencia',
          value: '${technician.experienceYears} años',
        ),
      );
    }

    if (isEmpresa && technician.subcategories.isNotEmpty) {
      metrics.add(
        ProfileMetricUi(
          icon: Icons.grid_view_rounded,
          label: 'Servicios',
          value: '${technician.subcategories.length}',
        ),
      );
    } else if (!isEmpresa && technician.workPhotos.isNotEmpty) {
      metrics.add(
        ProfileMetricUi(
          icon: Icons.photo_library_outlined,
          label: 'Trabajos',
          value: '${technician.workPhotos.length}',
        ),
      );
    } else if (technician.portfolio.isNotEmpty) {
      metrics.add(
        ProfileMetricUi(
          icon: Icons.collections_outlined,
          label: 'Proyectos',
          value: '${technician.portfolio.length}',
        ),
      );
    }

    return metrics.take(4).toList();
  }

}
