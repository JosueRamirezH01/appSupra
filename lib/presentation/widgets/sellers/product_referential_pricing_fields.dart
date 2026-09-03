import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/product_sale_unit.dart';
import '../auth/auth_ui.dart';

/// Precio referencial + unidad de venta + precio anterior opcional (oferta).
class ProductReferentialPricingFields extends StatefulWidget {
  const ProductReferentialPricingFields({
    super.key,
    required this.priceController,
    required this.compareAtController,
    required this.showCompareAt,
    required this.onShowCompareAtChanged,
    required this.saleUnit,
    required this.onSaleUnitChanged,
    this.enabled = true,
  });

  final TextEditingController priceController;
  final TextEditingController compareAtController;
  final bool showCompareAt;
  final ValueChanged<bool> onShowCompareAtChanged;
  final String? saleUnit;
  final ValueChanged<String?> onSaleUnitChanged;
  final bool enabled;

  @override
  State<ProductReferentialPricingFields> createState() =>
      _ProductReferentialPricingFieldsState();
}

class _ProductReferentialPricingFieldsState
    extends State<ProductReferentialPricingFields> {
  @override
  void initState() {
    super.initState();
    widget.priceController.addListener(_syncSaleUnitWithPrice);
  }

  @override
  void didUpdateWidget(covariant ProductReferentialPricingFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.priceController != widget.priceController) {
      oldWidget.priceController.removeListener(_syncSaleUnitWithPrice);
      widget.priceController.addListener(_syncSaleUnitWithPrice);
    }
  }

  @override
  void dispose() {
    widget.priceController.removeListener(_syncSaleUnitWithPrice);
    super.dispose();
  }

  void _syncSaleUnitWithPrice() {
    if (!mounted) return;
    setState(() {});

    final hasPrice = parseProductMoney(widget.priceController.text) != null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!hasPrice) {
        if (widget.saleUnit != null) widget.onSaleUnitChanged(null);
        return;
      }
      if (widget.saleUnit == null) {
        widget.onSaleUnitChanged(kDefaultProductSaleUnit);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final price = parseProductMoney(widget.priceController.text);
    final hasPrice = price != null;
    final saleUnit = normalizeProductSaleUnit(widget.saleUnit);

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
          controller: widget.priceController,
          label: 'Precio actual (S/)',
          readOnly: !widget.enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            final text = value?.trim() ?? '';
            if (text.isEmpty) {
              if (widget.showCompareAt) {
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
        if (hasPrice) ...[
          const SizedBox(height: 14),
          Text(
            'Se vende por',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppBrandColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Elige la unidad del precio para que el cliente no se confunda.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppBrandColors.textMuted,
            ),
          ),
          const SizedBox(height: 10),
          FormField<String>(
            key: ValueKey('sale-unit-${saleUnit ?? 'none'}'),
            initialValue: saleUnit,
            validator: (value) {
              if (parseProductMoney(widget.priceController.text) == null) {
                return null;
              }
              if (normalizeProductSaleUnit(value) == null) {
                return 'Elige cómo se vende (unidad, metro, bolsa…)';
              }
              return null;
            },
            builder: (state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final unit in kProductSaleUnits)
                        AuthChoiceChip(
                          label: productSaleUnitChipLabel(unit),
                          selected: saleUnit == unit,
                          onSelected: widget.enabled
                              ? (_) {
                                  widget.onSaleUnitChanged(unit);
                                  state.didChange(unit);
                                }
                              : (_) {},
                        ),
                    ],
                  ),
                  if (state.hasError) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.errorText!,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: const Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          if (saleUnit != null) ...[
            const SizedBox(height: 12),
            _PricePreviewBanner(
              price: price,
              saleUnit: saleUnit,
            ),
          ],
        ],
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
          value: widget.showCompareAt,
          activeTrackColor: AppBrandColors.primaryGreen,
          onChanged: widget.enabled ? widget.onShowCompareAtChanged : null,
        ),
        if (widget.showCompareAt) ...[
          AuthRoundedField(
            controller: widget.compareAtController,
            label: 'Precio anterior (S/)',
            readOnly: !widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              final currentPrice = parseProductMoney(widget.priceController.text);
              final compareAt = parseProductMoney(value);
              if (compareAt == null) {
                return 'Ingresa el precio anterior';
              }
              if (currentPrice == null) {
                return 'Primero indica el precio actual';
              }
              if (compareAt <= currentPrice) {
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

class _PricePreviewBanner extends StatelessWidget {
  const _PricePreviewBanner({
    required this.price,
    required this.saleUnit,
  });

  final double price;
  final String saleUnit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppBrandColors.primaryGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppBrandColors.primaryGreen.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.visibility_outlined,
            size: 18,
            color: AppBrandColors.primaryGreen.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 12.5,
                  color: AppBrandColors.textDark,
                ),
                children: [
                  const TextSpan(text: 'El cliente verá: '),
                  TextSpan(
                    text: formatProductSolesWithUnit(price, saleUnit),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
