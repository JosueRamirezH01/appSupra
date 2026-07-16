import '../../data/models/technicians/contact_lead_model.dart';
import '../../data/models/technicians/technician_model.dart';

abstract final class ContactMetricUtils {
  static String metricFieldLabel(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area => 'Área aproximada (m²) *',
      ContactMetricType.quantity => 'Cantidad *',
      ContactMetricType.none => '',
    };
  }

  static String? metricHint(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area => 'Ej. 45',
      ContactMetricType.quantity => 'Ej. 2 puertas',
      ContactMetricType.none => null,
    };
  }

  static String? validateMetric(String? value, ContactMetricType type) {
    if (type == ContactMetricType.none) return null;

    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return type == ContactMetricType.area
          ? 'Indica el área aproximada'
          : 'Indica la cantidad';
    }

    final parsed = double.tryParse(trimmed.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return 'Ingresa un número válido';
    }

    if (type == ContactMetricType.area) {
      if (parsed < 0.1 || parsed > 50000) {
        return 'El área debe estar entre 0.1 y 50,000 m²';
      }
      return null;
    }

    if (parsed != parsed.roundToDouble() || parsed < 1 || parsed > 9999) {
      return 'La cantidad debe ser un entero entre 1 y 9,999';
    }

    return null;
  }

  static double? parseMetricValue(String? value, ContactMetricType type) {
    if (type == ContactMetricType.none) return null;
    final parsed = double.tryParse(value?.trim().replaceAll(',', '.') ?? '');
    if (parsed == null) return null;
    return type == ContactMetricType.quantity ? parsed.roundToDouble() : parsed;
  }

  static String formatMetricSummary({
    required ContactMetricType? type,
    required double? value,
  }) {
    if (type == null || type == ContactMetricType.none || value == null) {
      return '';
    }
    return type == ContactMetricType.area ? '$value m²' : '$value unidades';
  }

  static String buildWhatsAppContext({
    required TechnicianSubSubCategoryModel? service,
    required ContactMetricType? metricType,
    required double? metricValue,
  }) {
    final buffer = StringBuffer();
    if (service != null) {
      buffer.write('\nServicio: ${service.name}.');
    }
    final metric = formatMetricSummary(type: metricType, value: metricValue);
    if (metric.isNotEmpty) {
      buffer.write(
        metricType == ContactMetricType.area
            ? '\nÁrea: $metric.'
            : '\nCantidad: $metric.',
      );
    }
    return buffer.toString();
  }

  /// Contexto para WhatsApp / mensaje al contactar un producto (vendedor).
  static String buildProductContactContext({
    String? materialName,
    String? productTitle,
    required ContactMetricType metricType,
    required double? metricValue,
  }) {
    final buffer = StringBuffer();
    if (productTitle != null && productTitle.trim().isNotEmpty) {
      buffer.write('\nProducto: ${productTitle.trim()}.');
    }
    if (materialName != null && materialName.trim().isNotEmpty) {
      buffer.write('\nMaterial: ${materialName.trim()}.');
    }
    final metric = formatMetricSummary(type: metricType, value: metricValue);
    if (metric.isNotEmpty) {
      buffer.write(
        metricType == ContactMetricType.area
            ? '\nÁrea: $metric.'
            : '\nCantidad: $metric.',
      );
    }
    return buffer.toString();
  }
}
