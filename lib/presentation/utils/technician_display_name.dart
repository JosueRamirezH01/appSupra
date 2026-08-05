import '../../data/models/technicians/technician_model.dart';

extension TechnicianPublicDisplayX on TechnicianPublicModel {
  /// Nombre visible en UI pública (cards, perfil, búsqueda).
  ///
  /// Empresa con razón social → `businessName`; si no → `displayName` del API o `name`.
  String get publicDisplayName {
    if (profileType == 'empresa') {
      final business = businessName?.trim();
      if (business != null && business.isNotEmpty) return business;
    }

    final fromApi = displayName?.trim();
    if (fromApi != null && fromApi.isNotEmpty) return fromApi;

    return name;
  }
}

extension TechnicianApplicationDisplayX on TechnicianApplicationModel {
  /// Misma regla para preview owner → modelo público.
  String get publicDisplayName {
    if (profileType == 'empresa') {
      final business = businessName?.trim();
      if (business != null && business.isNotEmpty) return business;
    }
    return name;
  }
}
