import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/service_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import 'technician_services_edit_sheet.dart';

/// Sheet owner-only para ver, quitar y agregar especialidades (máx. 3).
/// Sin precios: esa opción no se lanza a producción.
Future<void> showManageSpecialtiesSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (_) => _ManageSpecialtiesSheet(
      profile: profile,
      userId: userId,
    ),
  );
}

class _ManageSpecialtiesSheet extends ConsumerStatefulWidget {
  const _ManageSpecialtiesSheet({
    required this.profile,
    required this.userId,
  });

  final TechnicianApplicationModel profile;
  final int userId;

  @override
  ConsumerState<_ManageSpecialtiesSheet> createState() =>
      _ManageSpecialtiesSheetState();
}

class _ManageSpecialtiesSheetState
    extends ConsumerState<_ManageSpecialtiesSheet> {
  bool _busy = false;

  TechnicianApplicationModel get _profile =>
      ref.watch(myTechnicianProfileProvider).valueOrNull ?? widget.profile;

  int _serviceCount(int subcategoryId) => _profile.subSubCategories
      .where((service) => service.subcategoryId == subcategoryId)
      .length;

  bool get _canAddMore =>
      _profile.subcategories.length <
      ServiceConstants.maxRegistrationSpecialties;

  Future<void> _addOrEditSpecialties() async {
    if (_busy) return;

    setState(() => _busy = true);
    try {
      // Abrir el picker encima (sin cerrar este sheet). Así context/ref
      // siguen montados y el guardado + lista se refrescan al volver.
      await showEditSpecialtiesSheet(
        context,
        ref,
        profile: _profile,
        userId: widget.userId,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeSpecialty(TechnicianSubcategoryModel specialty) async {
    if (_busy) return;

    if (_profile.subcategories.length <=
        ServiceConstants.minRegistrationSpecialties) {
      showErrorSnackBar(
        context,
        'Debes conservar al menos ${ServiceConstants.minRegistrationSpecialties} especialidad',
      );
      return;
    }

    final serviceCount = _serviceCount(specialty.id);
    HapticFeedback.mediumImpact();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          '¿Quitar “${specialty.name}”?',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w800),
        ),
        content: Text(
          serviceCount > 0
              ? 'También se quitarán sus $serviceCount servicio${serviceCount == 1 ? '' : 's'} del perfil.'
              : 'Dejará de mostrarse en tu perfil público.',
          style: GoogleFonts.poppins(fontSize: 13.5, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final remainingIds = _profile.subcategories
        .where((item) => item.id != specialty.id)
        .map((item) => item.id)
        .toList();

    setState(() => _busy = true);
    try {
      await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
            UpdateTechnicianProfileRequest(subcategoryIds: remainingIds),
          );
      ref.invalidate(technicianDetailProvider(widget.userId));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Especialidad quitada',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          backgroundColor: AppBrandColors.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final specialties = _profile.subcategories;
    final max = ServiceConstants.maxRegistrationSpecialties;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Tus especialidades',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppBrandColors.textDark,
                    ),
                  ),
                ),
                Text(
                  '${specialties.length}/$max',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Puedes tener hasta $max rubros. Los servicios se gestionan en cada carrusel del perfil.',
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                height: 1.4,
                color: AppBrandColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            if (specialties.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Text(
                  'Aún no tienes especialidades. Agrega la primera para mostrar tus servicios.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: AppBrandColors.textMuted,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: specialties.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final specialty = specialties[index];
                    final count = _serviceCount(specialty.id);
                    return Material(
                      color: AppBrandColors.scaffoldBackground,
                      borderRadius: BorderRadius.circular(14),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          specialty.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          count == 0
                              ? 'Sin servicios aún'
                              : '$count servicio${count == 1 ? '' : 's'}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                        trailing: IconButton(
                          tooltip: 'Quitar especialidad',
                          onPressed: _busy
                              ? null
                              : () => _removeSpecialty(specialty),
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            if (_canAddMore)
              FilledButton.icon(
                onPressed: _busy ? null : _addOrEditSpecialties,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  specialties.isEmpty
                      ? 'Agregar especialidad'
                      : 'Agregar o editar especialidades',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppBrandColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              )
            else ...[
              OutlinedButton.icon(
                onPressed: _busy ? null : _addOrEditSpecialties,
                icon: const Icon(Icons.tune_rounded),
                label: Text(
                  'Cambiar especialidades',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppBrandColors.primaryGreen,
                  side: const BorderSide(color: AppBrandColors.primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Límite de $max especialidades alcanzado',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppBrandColors.textMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
