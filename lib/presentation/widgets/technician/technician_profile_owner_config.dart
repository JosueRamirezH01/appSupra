import 'package:flutter/material.dart';

import '../../../data/models/technicians/technician_model.dart';

/// Acciones de edición disponibles en la vista previa del perfil público del técnico.
class TechnicianProfileOwnerConfig {
  const TechnicianProfileOwnerConfig({
    required this.canEdit,
    this.coverageRadiusKm,
    this.coversAllPeru = false,
    this.coverageDistricts = const [],
    this.onEditAbout,
    this.onEditExperience,
    this.onEditWorkGallery,
    this.onEditServiceArea,
    this.onEditProfilePhoto,
    this.onEditServices,
    this.onManagePendingServices,
  });

  final bool canEdit;
  final int? coverageRadiusKm;
  final bool coversAllPeru;
  final List<TechnicianCoverageDistrictModel> coverageDistricts;
  final VoidCallback? onEditAbout;
  final VoidCallback? onEditExperience;
  final VoidCallback? onEditWorkGallery;
  final VoidCallback? onEditServiceArea;
  final VoidCallback? onEditProfilePhoto;
  final VoidCallback? onEditServices;
  final VoidCallback? onManagePendingServices;
}
