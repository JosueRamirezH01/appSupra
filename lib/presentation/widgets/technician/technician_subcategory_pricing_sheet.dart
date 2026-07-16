import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../providers/technicians/technicians_notifier.dart';
import '../auth/auth_ui.dart';
import '../../utils/technician_pricing_utils.dart';

Future<void> showEditSubcategoryPricingSheet(
  BuildContext context,
  WidgetRef ref, {
  required TechnicianApplicationModel profile,
  required int userId,
}) async {
  if (profile.subcategories.isEmpty) {
    showErrorSnackBar(context, 'Primero elige al menos una especialidad');
    return;
  }

  final payload = await showModalBottomSheet<List<SubcategoryPricingInputModel>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _SubcategoryPricingSheetBody(subcategories: profile.subcategories),
  );

  if (payload == null || !context.mounted) {
    return;
  }

  try {
    await ref.read(myTechnicianProfileProvider.notifier).updateProfile(
          UpdateTechnicianProfileRequest(subcategoryPricing: payload),
        );

    if (!context.mounted) {
      return;
    }

    // Espera a que el overlay del sheet termine de cerrarse antes de rebuild/snackbar.
    await Future<void>.delayed(Duration.zero);

    if (!context.mounted) {
      return;
    }

    ref.invalidate(technicianDetailProvider(userId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarifas referenciales actualizadas',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: AppBrandColors.primaryGreen,
      ),
    );
  } catch (e) {
    if (context.mounted) showErrorSnackBar(context, e);
  }
}

class _SubcategoryPricingSheetBody extends StatefulWidget {
  const _SubcategoryPricingSheetBody({required this.subcategories});

  final List<TechnicianSubcategoryModel> subcategories;

  @override
  State<_SubcategoryPricingSheetBody> createState() =>
      _SubcategoryPricingSheetBodyState();
}

class _SubcategoryPricingSheetBodyState extends State<_SubcategoryPricingSheetBody> {
  late final Map<int, TextEditingController> _minControllers;
  late final Map<int, TextEditingController> _maxControllers;

  @override
  void initState() {
    super.initState();
    _minControllers = {
      for (final subcategory in widget.subcategories)
        subcategory.id: TextEditingController(
          text: subcategory.priceMin?.toString() ?? '',
        ),
    };
    _maxControllers = {
      for (final subcategory in widget.subcategories)
        subcategory.id: TextEditingController(
          text: subcategory.priceMax?.toString() ?? '',
        ),
    };
  }

  @override
  void dispose() {
    for (final controller in _minControllers.values) {
      controller.dispose();
    }
    for (final controller in _maxControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    for (final subcategory in widget.subcategories) {
      final error = validatePriceRangeInputs(
        minText: _minControllers[subcategory.id]!.text,
        maxText: _maxControllers[subcategory.id]!.text,
      );

      if (error != null) {
        showErrorSnackBar(context, '${subcategory.name}: $error');
        return;
      }
    }

    final payload = buildSubcategoryPricingPayload(
      subcategories: widget.subcategories,
      minBySubcategoryId: {
        for (final entry in _minControllers.entries) entry.key: entry.value.text,
      },
      maxBySubcategoryId: {
        for (final entry in _maxControllers.entries) entry.key: entry.value.text,
      },
    );

    Navigator.pop(context, payload);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Tarifas referenciales',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Opcional. Si completas un rubro, indica mínimo y máximo por servicio.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            for (final subcategory in widget.subcategories) ...[
              Text(
                subcategory.name,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppBrandColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: AuthRoundedField(
                      controller: _minControllers[subcategory.id]!,
                      label: 'Mínimo (S/)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AuthRoundedField(
                      controller: _maxControllers[subcategory.id]!,
                      label: 'Máximo (S/)',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: _submit,
              child: const Text('Guardar tarifas'),
            ),
          ],
        ),
      ),
    );
  }
}
