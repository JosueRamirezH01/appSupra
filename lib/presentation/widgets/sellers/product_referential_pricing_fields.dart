import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth/auth_ui.dart';

/// Precio referencial + precio anterior opcional (oferta).
class ProductReferentialPricingFields extends StatelessWidget {
  const ProductReferentialPricingFields({
    super.key,
    required this.priceController,
    required this.compareAtController,
    required this.showCompareAt,
    required this.onShowCompareAtChanged,
    this.enabled = true,
  });

  final TextEditingController priceController;
  final TextEditingController compareAtController;
  final bool showCompareAt;
  final ValueChanged<bool> onShowCompareAtChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Precio referencial',
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Así lo verá el cliente. Sigue cotizando; no es compra online.',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppBrandColors.textMuted,
          ),
        ),
        const SizedBox(height: 10),
        AuthRoundedField(
          controller: priceController,
          label: 'Precio actual (S/)',
          readOnly: !enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              if (showCompareAt) {
                return 'Ingresa el precio actual para la oferta';
              }
              return null;
            }
            final parsed = parseProductMoney(text);
            if (parsed == null) return 'Precio inválido';
            if (parsed > 999999.99) return 'El monto es demasiado alto';
            return null;
          },
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text(
            'Mostrar precio anterior',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: showCompareAt,
          activeTrackColor: AppBrandColors.primaryGreen,
          onChanged: enabled ? onShowCompareAtChanged : null,
        ),
        if (showCompareAt) ...[
          AuthRoundedField(
            controller: compareAtController,
            label: 'Precio anterior (S/)',
            readOnly: !enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final price = parseProductMoney(priceController.text);
              final compareAt = parseProductMoney(value);
              if (compareAt == null) {
                return 'Ingresa el precio anterior';
              }
              if (price == null) {
                return 'Primero indica el precio actual';
              }
              if (compareAt <= price) {
                return 'Debe ser mayor al precio actual';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }
}

double? parseProductMoney(String? raw) {
  if (raw == null) return null;
  final cleaned = raw.trim().replaceAll(',', '.');
  if (cleaned.isEmpty) return null;
  return double.tryParse(cleaned);
}

String formatProductSoles(double value) {
  final amount = value % 1 == 0
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  return 'S/ $amount';
}
