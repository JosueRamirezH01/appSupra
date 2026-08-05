import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../providers/categories/categories_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../auth/auth_ui.dart';
import '../sub_sub_category_multi_picker.dart';

/// Agrega servicios (sub-subcategorías) del catálogo a una especialidad
/// puntual del técnico, reutilizando el mismo flujo de `updateProfile` que
/// usa el resto de la app para asignar servicios.
Future<void> addServiceToSpecialty(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
  required TechnicianSubcategoryModel subcategory,
}) async {
  final catalog = await ref.read(
    subSubCategoriesListProvider(subcategory.id).future,
  );
  if (!context.mounted) return;

  final subcategoryModel = SubcategoryModel(
    id: subcategory.id,
    categoryId: subcategory.categoryId,
    name: subcategory.name,
  );

  final currentIdsInSpecialty = profile.subSubCategories
      .where((item) => item.subcategoryId == subcategory.id)
      .map((item) => item.id)
      .toSet();

  final picked = await showSubSubCategoryMultiPicker(
    context,
    subcategories: [subcategoryModel],
    catalogBySubcategory: {subcategory.id: catalog},
    selectedIds: currentIdsInSpecialty,
  );

  if (picked == null || !context.mounted) return;

  final catalogIdsInSpecialty = catalog.map((item) => item.id).toSet();
  final idsFromOtherSpecialties = profile.subSubCategories
      .map((item) => item.id)
      .where((id) => !catalogIdsInSpecialty.contains(id));

  final newSubSubCategoryIds = <int>{
    ...idsFromOtherSpecialties,
    ...picked.map((item) => item.id),
  }.toList();

  try {
    await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
          UpdateTechnicianProfileRequest(
            subSubCategoryIds: newSubSubCategoryIds,
          ),
        );
    ref.invalidate(technicianDetailProvider(userId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Servicios actualizados',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppBrandColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (error) {
    if (context.mounted) showErrorSnackBar(context, error);
  }
}

/// Quita un servicio de la lista de sub-subcategorías asignadas al técnico.
/// No borra las fotos ya subidas para ese servicio (pueden quedar huérfanas
/// en backend), pero sí retira la asignación de inmediato.
Future<void> removeServiceFromProfile(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
  required TechnicianSubSubCategoryModel service,
}) async {
  final remainingIds = profile.subSubCategories
      .where((item) => item.id != service.id)
      .map((item) => item.id)
      .toList();

  try {
    await ref
        .read(myTechnicianProfileProvider.notifier)
        .updateProfile(
          UpdateTechnicianProfileRequest(subSubCategoryIds: remainingIds),
        );
    ref.invalidate(technicianDetailProvider(userId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '"${service.name}" se quitó de tu perfil',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          backgroundColor: AppBrandColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } catch (error) {
    if (context.mounted) showErrorSnackBar(context, error);
  }
}
