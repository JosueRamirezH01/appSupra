import '../../../data/models/technicians/technician_model.dart';

enum ServicePricingMode {
  both,
  labor,
  turnkey;

  static ServicePricingMode fromJson(String? value) {
    return switch (value) {
      'labor' => ServicePricingMode.labor,
      'turnkey' => ServicePricingMode.turnkey,
      _ => ServicePricingMode.both,
    };
  }

  bool get allowsLabor => this == ServicePricingMode.both || this == ServicePricingMode.labor;

  bool get allowsTurnkey =>
      this == ServicePricingMode.both || this == ServicePricingMode.turnkey;
}

enum ProfilePriceDisplay {
  labor,
  turnkey;

  static ProfilePriceDisplay fromJson(String? value) {
    return value == 'turnkey'
        ? ProfilePriceDisplay.turnkey
        : ProfilePriceDisplay.labor;
  }

  String get apiValue => this == ProfilePriceDisplay.turnkey ? 'turnkey' : 'labor';
}

extension TechnicianServicePricingX on TechnicianSubSubCategoryModel {
  ServicePricingMode get resolvedPricingMode =>
      ServicePricingMode.fromJson(pricingMode);

  ProfilePriceDisplay get resolvedProfilePriceDisplay {
    final mode = resolvedPricingMode;
    if (mode == ServicePricingMode.labor) return ProfilePriceDisplay.labor;
    if (mode == ServicePricingMode.turnkey) return ProfilePriceDisplay.turnkey;
    return ProfilePriceDisplay.fromJson(profilePriceDisplay);
  }

  double? get effectiveLaborMin => laborPriceMin ?? priceMin;

  double? get effectiveLaborMax => laborPriceMax ?? priceMax;

  bool get hasLaborPricing =>
      hasTechnicianServicePricing(
        priceMin: effectiveLaborMin,
        priceMax: effectiveLaborMax,
      );

  bool get hasTurnkeyPricing =>
      hasTechnicianServicePricing(
        priceMin: turnkeyPriceMin,
        priceMax: turnkeyPriceMax,
      );

  bool get hasAnyServicePricing =>
      (resolvedPricingMode.allowsLabor && hasLaborPricing) ||
      (resolvedPricingMode.allowsTurnkey && hasTurnkeyPricing);
}

String? formatTechnicianPriceRange({
  required double? priceMin,
  required double? priceMax,
  String suffix = ' (referencial)',
}) {
  if (priceMin == null || priceMax == null) {
    return null;
  }

  final minLabel = priceMin % 1 == 0 ? priceMin.toInt().toString() : priceMin.toStringAsFixed(2);
  final maxLabel = priceMax % 1 == 0 ? priceMax.toInt().toString() : priceMax.toStringAsFixed(2);

  if (priceMin == priceMax) {
    return 'Desde S/ $minLabel$suffix';
  }

  return 'S/ $minLabel – S/ $maxLabel$suffix';
}

String? formatTechnicianPriceRangeCompact({
  required double? priceMin,
  required double? priceMax,
}) {
  if (priceMin == null || priceMax == null) {
    return null;
  }

  final minLabel = priceMin % 1 == 0 ? priceMin.toInt().toString() : priceMin.toStringAsFixed(2);
  final maxLabel = priceMax % 1 == 0 ? priceMax.toInt().toString() : priceMax.toStringAsFixed(2);

  if (priceMin == priceMax) {
    return 'Desde S/ $minLabel';
  }

  return 'S/ $minLabel – S/ $maxLabel';
}

String? formatLaborPriceLabel({
  required double? priceMin,
  required double? priceMax,
  bool compact = false,
}) {
  final range = compact
      ? formatTechnicianPriceRangeCompact(priceMin: priceMin, priceMax: priceMax)
      : formatTechnicianPriceRange(priceMin: priceMin, priceMax: priceMax, suffix: '');
  if (range == null) return null;
  // Cliente: nombre completo, sin jerga ("M.O.").
  return compact ? 'Mano de obra · $range' : 'Mano de obra: $range';
}

String? formatTurnkeyPriceLabel({
  required double? priceMin,
  required double? priceMax,
  bool compact = false,
}) {
  final range = compact
      ? formatTechnicianPriceRangeCompact(priceMin: priceMin, priceMax: priceMax)
      : formatTechnicianPriceRange(priceMin: priceMin, priceMax: priceMax, suffix: '');
  if (range == null) return null;
  // Cliente: "Todo incluido" es más claro que "a todo costo".
  return compact ? 'Todo incluido · $range' : 'Todo incluido: $range';
}

List<String> servicePricingChipLabels(TechnicianSubSubCategoryModel service) {
  final mode = service.resolvedPricingMode;
  final labels = <String>[];

  if (mode.allowsLabor) {
    final labor = formatLaborPriceLabel(
      priceMin: service.effectiveLaborMin,
      priceMax: service.effectiveLaborMax,
    );
    if (labor != null) labels.add(labor);
  }

  if (mode.allowsTurnkey) {
    final turnkey = formatTurnkeyPriceLabel(
      priceMin: service.turnkeyPriceMin,
      priceMax: service.turnkeyPriceMax,
    );
    if (turnkey != null) labels.add(turnkey);
  }

  return labels;
}

List<String> servicePricingCompactLabels(TechnicianSubSubCategoryModel service) {
  final mode = service.resolvedPricingMode;
  final labels = <String>[];

  if (mode.allowsLabor) {
    final labor = formatLaborPriceLabel(
      priceMin: service.effectiveLaborMin,
      priceMax: service.effectiveLaborMax,
      compact: true,
    );
    if (labor != null) labels.add(labor);
  }

  if (mode.allowsTurnkey) {
    final turnkey = formatTurnkeyPriceLabel(
      priceMin: service.turnkeyPriceMin,
      priceMax: service.turnkeyPriceMax,
      compact: true,
    );
    if (turnkey != null) labels.add(turnkey);
  }

  return labels;
}

/// Un solo label para la tarjeta del perfil (carrusel).
String? serviceProfilePriceLabel(TechnicianSubSubCategoryModel service) {
  final display = service.resolvedProfilePriceDisplay;
  if (display == ProfilePriceDisplay.turnkey) {
    return formatTurnkeyPriceLabel(
      priceMin: service.turnkeyPriceMin,
      priceMax: service.turnkeyPriceMax,
      compact: true,
    );
  }
  return formatLaborPriceLabel(
    priceMin: service.effectiveLaborMin,
    priceMax: service.effectiveLaborMax,
    compact: true,
  );
}

/// Label de cotización mínima del perfil (piso comercial del técnico).
String? formatMinimumQuoteLabel(
  double? minimumQuote, {
  bool compact = true,
}) {
  if (minimumQuote == null) return null;
  final amount = minimumQuote % 1 == 0
      ? minimumQuote.toInt().toString()
      : minimumQuote.toStringAsFixed(2);
  if (compact) return 'Cotización min. S/$amount';
  return 'Cotización mínima · desde S/ $amount';
}

/// Valida monto libre (entero o decimal). Vacío = OK (opcional).
String? validateMinimumQuoteInput(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final value = parsePriceInput(trimmed);
  if (value == null) return 'Usa un monto válido (ej. 100 o 100.50)';
  if (value < 0) return 'El monto no puede ser negativo';
  if (value > 999999.99) return 'El monto es demasiado alto';
  return null;

}

double? parsePriceInput(String value) {
  final normalized = value.trim().replaceAll(',', '.');
  if (normalized.isEmpty) {
    return null;
  }

  return double.tryParse(normalized);
}

String? validatePriceRangeInputs({
  required String minText,
  required String maxText,
  bool required = false,
  String emptyMessage = 'El precio referencial es obligatorio',
  String partialMessage = 'Ingresa el precio mínimo y el máximo',
}) {
  final minEmpty = minText.trim().isEmpty;
  final maxEmpty = maxText.trim().isEmpty;

  if (minEmpty && maxEmpty) {
    return required ? emptyMessage : null;
  }

  if (minEmpty || maxEmpty) {
    return required
        ? partialMessage
        : 'Ingresa mínimo y máximo, o deja ambos vacíos';
  }

  final minValue = parsePriceInput(minText);
  final maxValue = parsePriceInput(maxText);

  if (minValue == null || maxValue == null) {
    return 'Usa solo números válidos';
  }

  if (minValue < 0 || maxValue < 0) {
    return 'Los montos no pueden ser negativos';
  }

  if (minValue > maxValue) {
    return 'El mínimo no puede ser mayor que el máximo';
  }

  return null;
}

List<SubcategoryPricingInputModel> buildSubcategoryPricingPayload({
  required List<TechnicianSubcategoryModel> subcategories,
  required Map<int, String> minBySubcategoryId,
  required Map<int, String> maxBySubcategoryId,
}) {
  return subcategories.map((subcategory) {
    return buildSubcategoryPricingInput(
      subcategoryId: subcategory.id,
      minText: minBySubcategoryId[subcategory.id] ?? '',
      maxText: maxBySubcategoryId[subcategory.id] ?? '',
    );
  }).toList();
}

List<SubcategoryPricingInputModel> buildSubcategoryPricingPayloadById({
  required List<int> subcategoryIds,
  required Map<int, String> minBySubcategoryId,
  required Map<int, String> maxBySubcategoryId,
}) {
  return subcategoryIds.map((subcategoryId) {
    return buildSubcategoryPricingInput(
      subcategoryId: subcategoryId,
      minText: minBySubcategoryId[subcategoryId] ?? '',
      maxText: maxBySubcategoryId[subcategoryId] ?? '',
    );
  }).toList();
}

SubcategoryPricingInputModel buildSubcategoryPricingInput({
  required int subcategoryId,
  required String minText,
  required String maxText,
}) {
  final minValue = parsePriceInput(minText);
  final maxValue = parsePriceInput(maxText);

  return SubcategoryPricingInputModel(
    subcategoryId: subcategoryId,
    priceMin: minValue,
    priceMax: maxValue,
  );
}

bool hasSubcategoryPricing({
  required double? priceMin,
  required double? priceMax,
}) {
  return priceMin != null && priceMax != null;
}

bool hasTechnicianServicePricing({
  required double? priceMin,
  required double? priceMax,
}) =>
    hasSubcategoryPricing(priceMin: priceMin, priceMax: priceMax);

({double? priceMin, double? priceMax}) parsePriceRangeInputs({
  required String minText,
  required String maxText,
}) {
  return (
    priceMin: parsePriceInput(minText),
    priceMax: parsePriceInput(maxText),
  );
}

int countSubcategoriesMissingPricing(List<TechnicianSubcategoryModel> subcategories) {
  return subcategories
      .where(
        (subcategory) => !hasSubcategoryPricing(
          priceMin: subcategory.priceMin,
          priceMax: subcategory.priceMax,
        ),
      )
      .length;
}
