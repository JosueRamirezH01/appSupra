import '../../data/models/technicians/contact_lead_model.dart';
import '../../data/models/technicians/technician_model.dart';

abstract final class ContactMetricUtils {
  static String metricFieldLabel(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area => 'Área aproximada (m²) *',
      ContactMetricType.quantity => 'Cantidad *',
      ContactMetricType.linearMeter => 'Metros lineales (m) *',
      ContactMetricType.none => '',
    };
  }

  static String? metricHint(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area => 'Ej. 45',
      ContactMetricType.quantity => 'Ej. 2 puertas',
      ContactMetricType.linearMeter => 'Ej. 25',
      ContactMetricType.none => null,
    };
  }

  static String metricContextPrefix(ContactMetricType? type) {
    return switch (type) {
      ContactMetricType.area => 'Área',
      ContactMetricType.linearMeter => 'Metros lineales',
      ContactMetricType.quantity => 'Cantidad',
      ContactMetricType.none || null => '',
    };
  }

  static String? validateMetric(String? value, ContactMetricType type) {
    if (type == ContactMetricType.none) return null;

    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return switch (type) {
        ContactMetricType.area => 'Indica el área aproximada',
        ContactMetricType.linearMeter => 'Indica los metros lineales',
        ContactMetricType.quantity => 'Indica la cantidad',
        ContactMetricType.none => null,
      };
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

    if (type == ContactMetricType.linearMeter) {
      if (parsed < 0.1 || parsed > 50000) {
        return 'Los metros lineales deben estar entre 0.1 y 50,000 m';
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

    final label = value % 1 == 0
        ? value.toInt().toString()
        : value.toStringAsFixed(2);

    return switch (type) {
      ContactMetricType.area => '$label m²',
      ContactMetricType.linearMeter => '$label m',
      ContactMetricType.quantity => '$label unidades',
      ContactMetricType.none => '',
    };
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
    final prefix = metricContextPrefix(metricType);
    if (metric.isNotEmpty && prefix.isNotEmpty) {
      buffer.write('\n$prefix: $metric.');
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
    final prefix = metricContextPrefix(metricType);
    if (metric.isNotEmpty && prefix.isNotEmpty) {
      buffer.write('\n$prefix: $metric.');
    }
    return buffer.toString();
  }
}
