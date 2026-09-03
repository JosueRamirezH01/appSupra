/// Unidades de venta del precio referencial (alineadas al backend).
const kProductSaleUnits = <String>[
  'unidad',
  'metro',
  'm2',
  'kg',
  'bolsa',
  'galon',
  'litro',
  'rollo',
  'plancha',
  'caja',
];

const kDefaultProductSaleUnit = 'unidad';

const kProductSaleUnitLabels = <String, String>{
  'unidad': 'Unidad',
  'metro': 'Metro',
  'm2': 'm²',
  'kg': 'Kg',
  'bolsa': 'Bolsa',
  'galon': 'Galón',
  'litro': 'Litro',
  'rollo': 'Rollo',
  'plancha': 'Plancha',
  'caja': 'Caja',
};

const kProductSaleUnitCardSuffix = <String, String>{
  'unidad': 'und',
  'metro': 'm',
  'm2': 'm²',
  'kg': 'kg',
  'bolsa': 'bolsa',
  'galon': 'gal',
  'litro': 'L',
  'rollo': 'rollo',
  'plancha': 'plancha',
  'caja': 'caja',
};

String? normalizeProductSaleUnit(String? raw) {
  if (raw == null) return null;
  final value = raw.trim().toLowerCase();
  if (value.isEmpty) return null;
  return kProductSaleUnits.contains(value) ? value : null;
}

String productSaleUnitChipLabel(String unit) =>
    kProductSaleUnitLabels[unit] ?? unit;

String productSaleUnitCardSuffix(String? unit) {
  final normalized = normalizeProductSaleUnit(unit);
  if (normalized == null) return 'und';
  return kProductSaleUnitCardSuffix[normalized] ?? normalized;
}

String productSaleUnitDetailLabel(String? unit) {
  final normalized = normalizeProductSaleUnit(unit) ?? kDefaultProductSaleUnit;
  switch (normalized) {
    case 'm2':
      return 'm²';
    case 'galon':
      return 'galón';
    default:
      return normalized;
  }
}

/// Card: `S/ 28 / bolsa`
String formatProductSolesWithUnit(double value, String? saleUnit) {
  final amount = value % 1 == 0
      ? value.toInt().toString()
      : value.toStringAsFixed(2);
  return 'S/ $amount / ${productSaleUnitCardSuffix(saleUnit)}';
}

/// Detalle: `por bolsa`
String formatProductSaleUnitPhrase(String? saleUnit) =>
    'por ${productSaleUnitDetailLabel(saleUnit)}';
