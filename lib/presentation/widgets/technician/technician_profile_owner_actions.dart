import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/technicians/technician_model.dart';
import '../../../routes/route_paths.dart';
import 'technician_profile_edit_sheets.dart';
import 'technician_profile_owner_config.dart';
import 'technician_service_assignment_actions.dart';
import 'technician_services_edit_sheet.dart';
import 'technician_specialties_manage_sheet.dart';

TechnicianProfileOwnerConfig buildTechnicianProfileOwnerConfig({
  required BuildContext context,
  required WidgetRef ref,
  required TechnicianApplicationModel profile,
  required int userId,
}) {
  final canEdit = profile.canEditProfile;

  return TechnicianProfileOwnerConfig(
    canEdit: canEdit,
    coverageRadiusKm: profile.hasServiceArea ? profile.coverageRadiusKm : null,
    coversAllPeru: profile.coversAllPeru,
    coverageDistricts: profile.coverageDistricts,
    onEditProfilePhoto: canEdit ? () => pickAndUpdateProfilePhoto(context, ref, userId: userId) : null,
    onEditAbout: canEdit ? () => showEditAboutSheet(context, ref, profile: profile, userId: userId)
        : null,
    onEditExperience: canEdit ? () => showEditExperienceSheet(context, ref, profile: profile, userId: userId,)
        : null,
    onEditWorkGallery: canEdit && profile.profileType == 'independiente'
        ? () => context.push(RoutePaths.technicianWorkPortfolio)
        : null,
    onEditFeaturedProjects: canEdit
        ? () => context.push(RoutePaths.technicianFeaturedProjects)
        : null,
    onEditServiceArea: canEdit
        ? () => context.push(
              '${RoutePaths.technicianServiceArea}?continue=false',
            )
        : null,
    onManageSpecialties: canEdit
        ? () async {
            // Sin especialidades: ir directo al picker (menos fricción).
            if (profile.subcategories.isEmpty) {
              await showEditSpecialtiesSheet(context, ref, profile: profile, userId: userId,);
              return;
            }
            await showManageSpecialtiesSheet(context, ref, profile: profile, userId: userId,);
          }
        : null,
    onManagePendingServices: canEdit && profile.pendingServices.isNotEmpty
        ? () => showPendingServicesSheet(
              context,
              ref,
              profile: profile,
              userId: userId,
            )
        : null,
    onAddServiceToSpecialty: canEdit
        ? (subcategory) => addServiceToSpecialty(
              context,
              ref,
              profile: profile,
              userId: userId,
              subcategory: subcategory,
            )
        : null,
    onRemoveService: canEdit
        ? (service) => removeServiceFromProfile(
              context,
              ref,
              profile: profile,
              userId: userId,
              service: service,
            )
        : null,
  );
}
