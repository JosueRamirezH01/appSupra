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

  return 'S/ $minLabel – $maxLabel';
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

/// Nombre completo de la métrica (detalle de servicio).
String? contactMetricFullLabel(String? contactMetricType) {
  return switch (contactMetricType) {
    'area' => 'Metro cuadrado',
    'linear_meter' => 'Metro lineal',
    'quantity' => 'Unidad',
    'point' => 'Punto',
    _ => null,
  };
}

/// Modo de contratación para el detalle de servicio (mano de obra / todo costo).
class ServiceHiringModePrice {
  const ServiceHiringModePrice({
    required this.title,
    required this.priceRange,
    this.subtitle,
  });

  final String title;
  final String priceRange;
  final String? subtitle;
}

/// Lista de modos con métrica en nombre completo (detalle).
List<ServiceHiringModePrice> serviceHiringModePrices(
  TechnicianSubSubCategoryModel service,
) {
  final mode = service.resolvedPricingMode;
  final unit = contactMetricFullLabel(service.contactMetricType);
  final modes = <ServiceHiringModePrice>[];

  if (mode.allowsLabor) {
    final range = formatTechnicianPriceRangeCompact(
      priceMin: service.effectiveLaborMin,
      priceMax: service.effectiveLaborMax,
    );
    if (range != null) {
      modes.add(
        ServiceHiringModePrice(
          title: unit == null ? 'Mano de obra' : 'Mano de obra/ $unit',
          priceRange: range,
        ),
      );
    }
  }

  if (mode.allowsTurnkey) {
    final range = formatTechnicianPriceRangeCompact(
      priceMin: service.turnkeyPriceMin,
      priceMax: service.turnkeyPriceMax,
    );
    if (range != null) {
      modes.add(
        ServiceHiringModePrice(
          title: unit == null ? 'Todo costo' : 'Todo costo/ $unit',
          subtitle: '(Mano de obra + materiales)',
          priceRange: range,
        ),
      );
    }
  }

  return modes;
}

/// Abreviatura de unidad para el precio del carrusel (según métrica del servicio).
String? contactMetricUnitAbbreviation(String? contactMetricType) {
  return switch (contactMetricType) {
    'area' => 'M²',
    'linear_meter' => 'ML',
    'quantity' => 'UND',
    'point' => 'punto',
    _ => null,
  };
}

/// Un solo label para la tarjeta del perfil (carrusel).
/// Formato:
/// `Mano de obra/ M²`
/// `S/ 50 – S/ 80`
String? serviceProfilePriceLabel(TechnicianSubSubCategoryModel service) {
  final display = service.resolvedProfilePriceDisplay;
  final range = display == ProfilePriceDisplay.turnkey
      ? formatTechnicianPriceRangeCompact(
          priceMin: service.turnkeyPriceMin,
          priceMax: service.turnkeyPriceMax,
        )
      : formatTechnicianPriceRangeCompact(
          priceMin: service.effectiveLaborMin,
          priceMax: service.effectiveLaborMax,
        );
  if (range == null) return null;

  final kind =
      display == ProfilePriceDisplay.turnkey ? 'Todo incluido' : 'Mano de obra';
  final unit = contactMetricUnitAbbreviation(service.contactMetricType);
  final header = unit == null ? kind : '$kind/ $unit';
  return '$header\n$range';
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
  if (compact) return 'Cotización mín. S/ $amount';
  return 'Cotización mín. S/ $amount';
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

/// Estimación referencial de un caso del catálogo.
/// - Solo min o min==max → `S/ 80.00` (sin "Desde")
/// - Rango → `S/ 80.00 – S/ 120.00`
String formatWorkCaseEstimatedRange({
  double? estimatedCost,
  double? estimatedCostMin,
  double? estimatedCostMax,
  bool withPrefix = true,
}) {
  final min = estimatedCostMin ?? estimatedCost;
  final max = estimatedCostMax ?? estimatedCostMin ?? estimatedCost;
  if (min == null) {
    return withPrefix ? 'Sin estimado' : '';
  }

  final effectiveMax = max ?? min;
  String money(double value) => value.toStringAsFixed(2);

  if (min == effectiveMax) {
    return 'S/ ${money(min)}';
  }
  return 'S/ ${money(min)} – S/ ${money(effectiveMax)}';
}

/// Valida estimación de caso: Desde obligatorio; Hasta opcional.
String? validateWorkCaseEstimateInputs({
  required String minText,
  required String maxText,
}) {
  if (minText.trim().isEmpty) {
    return 'Ingresa el precio desde';
  }

  final minValue = parsePriceInput(minText);
  if (minValue == null || minValue <= 0) {
    return 'Ingresa una estimación válida en soles';
  }

  if (maxText.trim().isEmpty) {
    return null;
  }

  final maxValue = parsePriceInput(maxText);
  if (maxValue == null || maxValue <= 0) {
    return 'Ingresa un hasta válido en soles';
  }
  if (minValue > maxValue) {
    return 'El mínimo no puede ser mayor que el máximo';
  }
  return null;
}

/// Resuelve min/max del caso: si Hasta está vacío, max = min.
({double min, double max})? resolveWorkCaseEstimateRange({
  required String minText,
  required String maxText,
}) {
  if (validateWorkCaseEstimateInputs(minText: minText, maxText: maxText) != null) {
    return null;
  }
  final minValue = parsePriceInput(minText)!;
  final maxValue = maxText.trim().isEmpty
      ? minValue
      : parsePriceInput(maxText)!;
  return (min: minValue, max: maxValue);
}
