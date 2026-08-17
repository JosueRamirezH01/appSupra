import '../../data/models/technicians/contact_lead_model.dart';
import '../../data/models/technicians/technician_model.dart';
import '../config/app_config.dart';
import 'media_url_utils.dart';

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

  /// Texto guía para que el dueño estime el caso según la métrica del servicio.
  static String workCaseEstimateGuidance(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area =>
        'Estima el rango según el área (m²) del trabajo de la foto. '
            'Es referencial y no reemplaza la cotización del servicio.',
      ContactMetricType.linearMeter =>
        'Estima el rango según los metros lineales (m) del trabajo de la foto. '
            'Es referencial y no reemplaza la cotización del servicio.',
      ContactMetricType.quantity =>
        'Estima el rango según la cantidad del trabajo de la foto '
            '(unidades, piezas, etc.). Es referencial y no reemplaza la cotización del servicio.',
      ContactMetricType.none =>
        'Describe lo realizado y una estimación referencial (desde / hasta). '
            'No reemplaza la cotización del servicio.',
    };
  }

  static String? workCaseEstimateRangeHint(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area => 'Según los m² del trabajo mostrado',
      ContactMetricType.linearMeter => 'Según los metros lineales del trabajo',
      ContactMetricType.quantity => 'Según la cantidad del trabajo mostrado',
      ContactMetricType.none => null,
    };
  }

  /// Etiqueta corta de métrica para UI (`m²`, `m`, `und.`).
  static String? workCaseMetricSlashLabel(ContactMetricType type) {
    return switch (type) {
      ContactMetricType.area => 'm²',
      ContactMetricType.linearMeter => 'm',
      ContactMetricType.quantity => 'und.',
      ContactMetricType.none => null,
    };
  }

  /// Ej.: `Mano de obra / m²` o solo `Mano de obra` si no hay métrica.
  static String workCaseEstimateModeLabel({
    required String estimatePricingType,
    required ContactMetricType contactMetricType,
  }) {
    final mode = estimatePricingType == 'turnkey'
        ? 'Todo incluido'
        : 'Mano de obra';
    final metric = workCaseMetricSlashLabel(contactMetricType);
    if (metric == null || metric.isEmpty) return mode;
    return '$mode / $metric';
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

  static String formatMetricSummary({required ContactMetricType? type, required double? value,}) {
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

  static String formatWorkCaseEstimatedCost({
    double? estimatedCost,
    double? estimatedCostMin,
    double? estimatedCostMax,
  }) {
    final min = estimatedCostMin ?? estimatedCost;
    final max = estimatedCostMax ?? estimatedCostMin ?? estimatedCost;
    if (min == null) return '';

    final effectiveMax = max ?? min;
    String money(double value) => value.toStringAsFixed(2);

    if (min == effectiveMax) return 'S/ ${money(min)}';
    return 'S/ ${money(min)} – S/ ${money(effectiveMax)}';
  }

  /// URL pública de la foto del caso (para armar el link de share).
  static String? workCaseImageUrlForWhatsApp(TechnicianWorkPhotoModel? workCase) {
    if (workCase == null) return null;
    final imageUrl = MediaUrlUtils.resolve(workCase.imageUrl)?.trim();
    if (imageUrl == null ||
        imageUrl.isEmpty ||
        imageUrl.startsWith('localfile:')) {
      return null;
    }
    if (!imageUrl.startsWith('https://') && !imageUrl.startsWith('http://')) {
      return null;
    }
    return imageUrl;
  }

  /// Página OG `/share/trabajo` para preview estable en WhatsApp.
  static String? workCaseShareUrlForWhatsApp(TechnicianWorkPhotoModel? workCase, {String? title, String? description}) {
    final imageUrl = workCaseImageUrlForWhatsApp(workCase);
    if (imageUrl == null) return null;

    final api = Uri.parse(AppConfig.baseUrl);
    final query = <String, String>{
      'img': imageUrl,
      if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
      if (description != null && description.trim().isNotEmpty)
        'desc': description.trim(),
    };

    return Uri(
      scheme: api.scheme,
      host: api.host,
      port: api.hasPort ? api.port : null,
      path: '/share/trabajo',
      queryParameters: query,
    ).toString();
  }

  static String buildWhatsAppContext({
    required TechnicianSubSubCategoryModel? service,
    required ContactMetricType? metricType,
    required double? metricValue,
    TechnicianWorkPhotoModel? workCase,
  }) {
    final buffer = StringBuffer();
    if (service != null) {
      buffer.write('\nServicio: ${service.name}.');
    }
    if (workCase != null) {
      final caption = workCase.caption?.trim();
      final title = (caption != null && caption.isNotEmpty)
          ? caption
          : 'Trabajo realizado';
      buffer.write('\nCaso del catálogo: $title.');
      final estimated = formatWorkCaseEstimatedCost(
        estimatedCost: workCase.estimatedCost,
        estimatedCostMin: workCase.estimatedCostMin,
        estimatedCostMax: workCase.estimatedCostMax,
      );
      if (estimated.isNotEmpty) {
        final modeLabel = workCaseEstimateModeLabel(
          estimatePricingType: workCase.estimatePricingType,
          contactMetricType: ContactMetricType.fromJson(
            service?.contactMetricType,
          ),
        );
        buffer.write('\nEstimado referencial ($modeLabel): $estimated.');
      }
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
