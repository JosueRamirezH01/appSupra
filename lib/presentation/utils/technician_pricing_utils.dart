import '../../../data/models/technicians/technician_model.dart';

String? formatTechnicianPriceRange({
  required double? priceMin,
  required double? priceMax,
}) {
  if (priceMin == null || priceMax == null) {
    return null;
  }

  final minLabel = priceMin % 1 == 0 ? priceMin.toInt().toString() : priceMin.toStringAsFixed(2);
  final maxLabel = priceMax % 1 == 0 ? priceMax.toInt().toString() : priceMax.toStringAsFixed(2);

  return 'S/ $minLabel – S/ $maxLabel referencial por servicio';
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
}) {
  final minEmpty = minText.trim().isEmpty;
  final maxEmpty = maxText.trim().isEmpty;

  if (minEmpty && maxEmpty) {
    return null;
  }

  if (minEmpty || maxEmpty) {
    return 'Ingresa mínimo y máximo, o deja ambos vacíos';
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
