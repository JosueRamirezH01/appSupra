import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/catalog_constants.dart';
import '../../../core/constants/service_constants.dart';
import '../../../core/utils/error_utils.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../providers/categories/categories_notifier.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../auth/auth_ui.dart';
import 'specialties_with_pricing_sheet.dart';
import '../sub_sub_category_multi_picker.dart';
import '../subcategory_multi_picker.dart';

Future<void> showEditWhatYouOfferSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) async {
  final canHaveServices = profile.subcategories.isNotEmpty &&
      profile.subcategories.every(
        (item) => !CatalogConstants.isOtrosSubcategoryName(item.name),
      );

  final action = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _WhatYouOfferEditMenuSheet(
      hasPending: profile.pendingServices.isNotEmpty,
      canEditServices: canHaveServices,
    ),
  );

  if (!context.mounted || action == null) return;

  switch (action) {
    case 'specialties':
      await showEditSpecialtiesSheet(
        context,
        ref,
        profile: profile,
        userId: userId,
      );
    case 'catalog':
      await _pickCatalogServices(
        context,
        ref,
        profile: profile,
        userId: userId,
      );
    case 'suggest':
      await _showSuggestServiceDialog(
        context,
        ref,
        profile: profile,
        userId: userId,
      );
    case 'pending':
      await showPendingServicesSheet(
        context,
        ref,
        profile: profile,
        userId: userId,
      );
  }
}

Future<void> showEditSpecialtiesSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) async {
  final subs = await ref.read(professionSubcategoriesProvider.future);
  if (!context.mounted) return;

  final picked = await showSubcategoryMultiPicker(
    context,
    subcategories: subs,
    selectedIds: profile.subcategories.map((item) => item.id).toSet(),
    flowStepLabel: 'Paso 1 de 2',
    confirmLabel: 'Continuar',
  );

  if (picked == null || !context.mounted) return;

  final pricingRows = buildSpecialtyPricingRows(
    picked: picked,
    existing: profile.subcategories,
  );

  final pricingPayload = await showSpecialtyPricingStepSheet(
    context,
    specialties: pricingRows,
  );

  if (pricingPayload == null || !context.mounted) return;

  final previousSubcategoryIds =
      profile.subcategories.map((item) => item.id).toSet();

  try {
    await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
          UpdateTechnicianProfileRequest(
            subcategoryIds: picked.map((item) => item.id).toList(),
            subcategoryPricing: pricingPayload,
          ),
        );
    ref.invalidate(technicianDetailProvider(userId));

    if (!context.mounted) return;

    final updated = ref.read(myTechnicianProfileProvider).valueOrNull;
    final missingServiceSubcategories = updated == null
        ? const <TechnicianSubcategoryModel>[]
        : updated.subcategories.where((subcategory) {
            final count = updated.subSubCategories
                .where((service) => service.subcategoryId == subcategory.id)
                .length;
            return count < ServiceConstants.minServicesPerSpecialty;
          }).toList();
    final needsServices = missingServiceSubcategories.isNotEmpty;
    final newSubcategories = missingServiceSubcategories
        .where((subcategory) => !previousSubcategoryIds.contains(subcategory.id))
        .toList();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          needsServices
              ? newSubcategories.isNotEmpty
                  ? 'Especialidades actualizadas. Elige los servicios de ${newSubcategories.map((item) => item.name).join(', ')}.'
                  : 'Especialidades actualizadas. Completa los servicios de cada rubro.'
              : 'Especialidades actualizadas',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppBrandColors.primaryGreen,
      ),
    );

    if (needsServices && context.mounted) {
      final freshProfile = ref.read(myTechnicianProfileProvider).valueOrNull;
      if (freshProfile != null) {
        await _pickCatalogServices(
          context,
          ref,
          profile: freshProfile,
          userId: userId,
        );
      }
    }
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}

Future<void> showEditServicesSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) {
  return showEditWhatYouOfferSheet(
    context,
    ref,
    profile: profile,
    userId: userId,
  );
}

Future<void> _pickCatalogServices(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) async {
  final subcategories = profile.subcategories
      .map(
        (item) => SubcategoryModel(
          id: item.id,
          categoryId: item.categoryId,
          name: item.name,
        ),
      )
      .toList();

  final catalog = <int, List<SubSubCategoryModel>>{};
  for (final subcategory in subcategories) {
    final items = await ref.read(
      subSubCategoriesListProvider(subcategory.id).future,
    );
    catalog[subcategory.id] = items;
  }

  if (!context.mounted) return;

  final selectedIds = profile.subSubCategories.map((item) => item.id).toSet();

  final picked = await showSubSubCategoryMultiPicker(
    context,
    subcategories: subcategories,
    catalogBySubcategory: catalog,
    selectedIds: selectedIds,
  );

  if (picked == null || !context.mounted) return;

  try {
    await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
          UpdateTechnicianProfileRequest(
            subSubCategoryIds: picked.map((item) => item.id).toList(),
          ),
        );
    ref.invalidate(technicianDetailProvider(userId));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Servicios actualizados',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}

Future<void> _showSuggestServiceDialog(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) async {
  final nameController = TextEditingController();
  var subcategoryId = profile.subcategories.first.id;

  final submitted = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Proponer servicio',
        style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (profile.subcategories.length > 1)
            DropdownButtonFormField<int>(
              initialValue: subcategoryId,
              decoration: authDropdownDecoration('Especialidad'),
              items: profile.subcategories
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.id,
                      child: Text(item.name),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) subcategoryId = value;
              },
            ),
          if (profile.subcategories.length > 1) const SizedBox(height: 12),
          AuthRoundedField(
            controller: nameController,
            label: 'Nombre del servicio',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Enviar'),
        ),
      ],
    ),
  );

  if (submitted != true || !context.mounted) {
    nameController.dispose();
    return;
  }

  final name = nameController.text.trim();
  nameController.dispose();

  if (name.length < 2) {
    showErrorSnackBar(context, 'Mínimo 2 caracteres');
    return;
  }

  try {
    await ref.read(myTechnicianProfileProvider.notifier).suggestService(
          subcategoryId: subcategoryId,
          proposedName: name,
        );
    ref.invalidate(technicianDetailProvider(userId));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Servicio agregado a tu perfil. Se revisará para el catálogo.',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}

class _WhatYouOfferEditMenuSheet extends StatelessWidget {
  const _WhatYouOfferEditMenuSheet({
    required this.hasPending,
    required this.canEditServices,
  });

  final bool hasPending;
  final bool canEditServices;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Qué ofreces',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.handyman_outlined),
              title: const Text('Editar especialidades'),
              subtitle: Text(
                'Rubros y tarifa referencial (${ServiceConstants.minRegistrationSpecialties}–${ServiceConstants.maxRegistrationSpecialties})',
              ),
              onTap: () => Navigator.pop(context, 'specialties'),
            ),
            if (canEditServices) ...[
              ListTile(
                leading: const Icon(Icons.checklist_rounded),
                title: const Text('Elegir servicios del catálogo'),
                subtitle: Text(
                  'Hasta ${ServiceConstants.maxServicesPerSpecialty} por especialidad',
                ),
                onTap: () => Navigator.pop(context, 'catalog'),
              ),
              ListTile(
                leading: const Icon(Icons.add_circle_outline),
                title: const Text('Proponer servicio'),
                subtitle: const Text('Si no está en el catálogo'),
                onTap: () => Navigator.pop(context, 'suggest'),
              ),
            ],
            if (hasPending)
              ListTile(
                leading: const Icon(Icons.pending_actions_outlined),
                title: const Text('Gestionar propuestas'),
                onTap: () => Navigator.pop(context, 'pending'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Gestión de servicios propuestos pendientes de revisión en catálogo.
Future<void> showPendingServicesSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) {
  if (profile.pendingServices.isEmpty) return Future.value();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _PendingServicesSheet(
      profile: profile,
      onRemove: (suggestionId) async {
        await ref
            .read(myTechnicianProfileProvider.notifier)
            .removeServiceSuggestion(suggestionId);
        ref.invalidate(technicianDetailProvider(userId));
      },
    ),
  );
}

class _PendingServicesSheet extends StatefulWidget {
  const _PendingServicesSheet({
    required this.profile,
    required this.onRemove,
  });

  final TechnicianApplicationModel profile;
  final Future<void> Function(int suggestionId) onRemove;

  @override
  State<_PendingServicesSheet> createState() => _PendingServicesSheetState();
}

class _PendingServicesSheetState extends State<_PendingServicesSheet> {
  late List<TechnicianPendingServiceModel> _pending;

  @override
  void initState() {
    super.initState();
    _pending = List.from(widget.profile.pendingServices);
  }

  String _subcategoryName(int subcategoryId) {
    for (final item in widget.profile.subcategories) {
      if (item.id == subcategoryId) return item.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Servicios en revisión',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Estos nombres son visibles en tu perfil mientras el equipo los evalúa para el catálogo.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppBrandColors.textMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          ..._pending.map((item) {
            final parent = _subcategoryName(item.subcategoryId);
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                item.name,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              subtitle: parent.isEmpty
                  ? null
                  : Text(
                      parent,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppBrandColors.textMuted,
                      ),
                    ),
              trailing: IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () async {
                  await widget.onRemove(item.id);
                  if (!mounted) return;
                  setState(() {
                    _pending.removeWhere((p) => p.id == item.id);
                  });
                  if (_pending.isEmpty && mounted) Navigator.pop(context);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
