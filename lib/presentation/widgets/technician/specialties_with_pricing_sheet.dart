import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/error_utils.dart';
import '../../../data/models/categories/category_model.dart';
import '../../../data/models/technicians/technician_model.dart';
import '../../utils/technician_pricing_utils.dart';
import '../auth/auth_ui.dart';

class SpecialtyPricingRow {
  const SpecialtyPricingRow({
    required this.id,
    required this.name,
    this.priceMin,
    this.priceMax,
  });

  final int id;
  final String name;
  final double? priceMin;
  final double? priceMax;
}

List<SpecialtyPricingRow> buildSpecialtyPricingRows({
  required List<SubcategoryModel> picked,
  required List<TechnicianSubcategoryModel> existing,
}) {
  final existingById = {for (final item in existing) item.id: item};

  return picked
      .map(
        (subcategory) => SpecialtyPricingRow(
          id: subcategory.id,
          name: subcategory.name,
          priceMin: existingById[subcategory.id]?.priceMin,
          priceMax: existingById[subcategory.id]?.priceMax,
        ),
      )
      .toList();
}

/// Paso 2: tarifas referenciales por cada especialidad elegida.
Future<List<SubcategoryPricingInputModel>?> showSpecialtyPricingStepSheet(
  BuildContext context, {
  required List<SpecialtyPricingRow> specialties,
}) {
  return showModalBottomSheet<List<SubcategoryPricingInputModel>>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    isDismissible: true,
    enableDrag: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _SpecialtyPricingStepSheet(specialties: specialties),
  );
}

class _SpecialtyPricingStepSheet extends StatefulWidget {
  const _SpecialtyPricingStepSheet({required this.specialties});

  final List<SpecialtyPricingRow> specialties;

  @override
  State<_SpecialtyPricingStepSheet> createState() => _SpecialtyPricingStepSheetState();
}

class _SpecialtyPricingStepSheetState extends State<_SpecialtyPricingStepSheet> {
  late final Map<int, TextEditingController> _minControllers;
  late final Map<int, TextEditingController> _maxControllers;

  @override
  void initState() {
    super.initState();
    _minControllers = {
      for (final specialty in widget.specialties)
        specialty.id: TextEditingController(
          text: specialty.priceMin?.toString() ?? '',
        ),
    };
    _maxControllers = {
      for (final specialty in widget.specialties)
        specialty.id: TextEditingController(
          text: specialty.priceMax?.toString() ?? '',
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

  List<SubcategoryPricingInputModel>? _buildPayload({required bool validate}) {
    for (final specialty in widget.specialties) {
      final error = validatePriceRangeInputs(
        minText: _minControllers[specialty.id]!.text,
        maxText: _maxControllers[specialty.id]!.text,
      );

      if (validate && error != null) {
        showErrorSnackBar(context, '${specialty.name}: $error');
        return null;
      }
    }

    return buildSubcategoryPricingPayloadById(
      subcategoryIds: widget.specialties.map((item) => item.id).toList(),
      minBySubcategoryId: {
        for (final entry in _minControllers.entries) entry.key: entry.value.text,
      },
      maxBySubcategoryId: {
        for (final entry in _maxControllers.entries) entry.key: entry.value.text,
      },
    );
  }

  void _save({required bool validate}) {
    final payload = _buildPayload(validate: validate);
    if (payload != null) {
      Navigator.pop(context, payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final navBarInset = MediaQuery.viewPaddingOf(context).bottom;
    final safeBottom = keyboardInset > 0 ? keyboardInset : navBarInset;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
             children: [
               Center(
                 child: Container(
                   width: 40,
                   height: 4,
                   decoration: BoxDecoration(
                     color: const Color(0xFFE5E7EB),
                     borderRadius: BorderRadius.circular(99),
                   ),
                 ),
               ),
               const SizedBox(height: 16),
               Text(
                 'Paso 2 de 2',
                 style: GoogleFonts.poppins(
                   fontSize: 12,
                   fontWeight: FontWeight.w700,
                   color: AppBrandColors.primaryGreen,
                 ),
               ),
               const SizedBox(height: 4),
               Text(
                 '¿Cuánto cobras aproximadamente?',
                 style: GoogleFonts.montserrat(
                   fontSize: 18,
                   fontWeight: FontWeight.w800,
                 ),
               ),
               const SizedBox(height: 8),
               Text(
                 'Opcional. Un rango referencial por servicio ayuda a que los clientes '
                     'sepan qué esperar antes de contactarte.',
                 style: GoogleFonts.poppins(
                   fontSize: 13,
                   color: AppBrandColors.textMuted,
                   height: 1.45,
                 ),
               ),
               const SizedBox(height: 12),
               Container(
                 padding: const EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: const Color(0xFFF0FDF4),
                   borderRadius: BorderRadius.circular(12),
                   border: Border.all(color: const Color(0xFFBBF7D0)),
                 ),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Icon(
                       Icons.info_outline_rounded,
                       size: 18,
                       color: AppBrandColors.primaryGreen,
                     ),
                     const SizedBox(width: 10),
                     Expanded(
                       child: Text(
                         'No es una cotización final. Si completas un rubro, indica '
                             'mínimo y máximo.',
                         style: GoogleFonts.poppins(
                           fontSize: 12,
                           color: AppBrandColors.textDark,
                           height: 1.4,
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               const SizedBox(height: 16),
               for (final specialty in widget.specialties) ...[
                 Container(
                   padding: const EdgeInsets.all(14),
                   decoration: BoxDecoration(
                     color: const Color(0xFFF8FAFC),
                     borderRadius: BorderRadius.circular(14),
                     border: Border.all(color: const Color(0xFFE2E8F0)),
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.stretch,
                     children: [
                       Text(
                         specialty.name,
                         style: GoogleFonts.montserrat(
                           fontSize: 14,
                           fontWeight: FontWeight.w800,
                           color: AppBrandColors.primaryGreen,
                         ),
                       ),
                       const SizedBox(height: 10),
                       Row(
                         children: [
                           Expanded(
                             child: AuthRoundedField(
                               controller: _minControllers[specialty.id]!,
                               label: 'Mínimo (S/)',
                               keyboardType:
                               const TextInputType.numberWithOptions(decimal: true),
                             ),
                           ),
                           const SizedBox(width: 12),
                           Expanded(
                             child: AuthRoundedField(
                               controller: _maxControllers[specialty.id]!,
                               label: 'Máximo (S/)',
                               keyboardType:
                               const TextInputType.numberWithOptions(decimal: true),
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(height: 12),
               ],
             ],
            ),
          )),
          Padding(padding: EdgeInsets.only(top: 12, bottom: 16 + safeBottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuthPrimaryButton(
                  label: 'Guardar especialidades',
                  isLoading: false,
                  onPressed: () => _save(validate: true),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => _save(validate: false),
                  child: Text(
                    'Omitir tarifas por ahora',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Volver a elegir rubros',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppBrandColors.textMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
