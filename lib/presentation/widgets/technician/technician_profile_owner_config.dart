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
    this.onEditFeaturedProjects,
    this.onEditServiceArea,
    this.onEditProfilePhoto,
    this.onManageSpecialties,
    this.onManagePendingServices,
    this.onAddServiceToSpecialty,
    this.onRemoveService,
  });

  final bool canEdit;
  final int? coverageRadiusKm;
  final bool coversAllPeru;
  final List<TechnicianCoverageDistrictModel> coverageDistricts;
  final VoidCallback? onEditAbout;
  final VoidCallback? onEditExperience;
  final VoidCallback? onEditWorkGallery;
  final VoidCallback? onEditFeaturedProjects;
  final VoidCallback? onEditServiceArea;
  final VoidCallback? onEditProfilePhoto;

  /// Gestionar especialidades (subcatálogos): agregar / quitar, máx. 3.
  final VoidCallback? onManageSpecialties;
  final VoidCallback? onManagePendingServices;

  /// Agrega un servicio del catálogo a una especialidad puntual del técnico.
  final Future<void> Function(TechnicianSubcategoryModel subcategory)?
  onAddServiceToSpecialty;

  /// Quita un servicio (sub-subcategoría) de la lista de asignados.
  final Future<void> Function(TechnicianSubSubCategoryModel service)?
  onRemoveService;
}
