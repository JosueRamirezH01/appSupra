import '../../data/models/common/api_error_model.dart';

class AppException implements Exception {
  const AppException({
    required this.message,
    required this.code,
    this.statusCode,
    this.errors,
  });

  final String message;
  final String code;
  final int? statusCode;
  final dynamic errors;

  factory AppException.fromApiError(ApiErrorModel error, {int? statusCode}) {
    return AppException(
      message: _localizedMessage(error.message, error.code, error.errors),
      code: error.code,
      statusCode: statusCode,
      errors: error.errors,
    );
  }

  static String _localizedMessage(
    String message,
    String code,
    dynamic errors,
  ) {
    final localized = switch (code) {
      'TECHNICIAN_VERIFICATION_PENDING' =>
        'Ya enviaste tus documentos. Revisaremos tu insignia verificada.',
      'TECHNICIAN_ALREADY_APPROVED' =>
        'Ya tienes la insignia de identidad verificada.',
      'TECHNICIAN_SERVICE_AREA_REQUIRED' =>
        'Configura tu zona de servicio antes de enviar la verificación.',
      'CUSTOM_SPECIALTY_REQUIRED' =>
        'Describe tu oficio con al menos 3 caracteres cuando eliges "Otros servicios técnicos".',
      'FILE_TOO_LARGE' =>
        'El archivo es demasiado grande. Usa una imagen más liviana o un PDF más pequeño.',
      'SELLER_RUC_EXISTS' =>
        'Este RUC ya está registrado en otro perfil. Verifica el número e inténtalo de nuevo.',
      'TECHNICIAN_RUC_EXISTS' =>
        'Este RUC ya está registrado en otro perfil. Verifica el número e inténtalo de nuevo.',
      'TECHNICIAN_DOCUMENT_EXISTS' =>
        'Este DNI/documento ya está registrado en otro técnico. Verifica el número e inténtalo de nuevo.',
      'PROFILE_PHONE_EXISTS' =>
        'Este teléfono ya está registrado en otro perfil. Usa otro número o revisa si ya tienes una cuenta.',
      'AUTH_PROFILE_EXISTS' =>
        'Ya tienes un perfil de vendedor registrado en esta cuenta.',
      'RESOURCE_EXISTS' =>
        'Este dato ya está registrado. Verifica la información e inténtalo de nuevo.',
      'AUTH_EMAIL_CODE_INVALID' =>
        'El código no es válido. Revísalo e inténtalo de nuevo.',
      'AUTH_EMAIL_CODE_EXPIRED' =>
        'El código expiró. Pide uno nuevo para continuar.',
      'AUTH_EMAIL_CODE_MAX_ATTEMPTS' =>
        'Demasiados intentos. Pide un código nuevo para continuar.',
      'AUTH_EMAIL_CODE_COOLDOWN' =>
        'Espera unos segundos antes de pedir otro código.',
      'AUTH_EMAIL_SEND_LIMIT' =>
        'Pediste demasiados códigos para este correo. Inténtalo más tarde.',
      'AUTH_RESET_TOKEN_INVALID' =>
        'La verificación expiró. Solicita un código nuevo.',
      'AUTH_RESET_TOKEN_EXPIRED' =>
        'La verificación expiró. Solicita un código nuevo.',
      _ => null,
    };
    if (localized != null) return localized;

    return _formatMessage(message, errors);
  }

  static String _formatMessage(String message, dynamic errors) {
    if (errors is! Map) return message;

    final details = <String>[];
    for (final entry in errors.entries) {
      final field = entry.key.toString();
      final value = entry.value;
      if (value is List && value.isNotEmpty) {
        details.add(
          '${_fieldLabel(field)}: ${_localizeFieldError(field, value.first.toString())}',
        );
      } else if (value != null) {
        details.add('${_fieldLabel(field)}: $value');
      }
    }

    if (details.isEmpty) return message;
    return details.join('\n');
  }

  static String _fieldLabel(String field) {
    return switch (field) {
      'experienceYears' => 'Años de experiencia',
      'address' => 'Dirección',
      'phone' => 'Teléfono',
      'ruc' => 'RUC',
      'businessName' => 'Razón social',
      'legalRepresentativeName' => 'Representante legal',
      'profileType' => 'Tipo de perfil',
      'documentFrontImageUrl' => 'DNI frontal',
      'documentBackImageUrl' => 'DNI reverso',
      'facePhotoUrl' => 'Foto de rostro',
      'companyLogoUrl' => 'Logo de empresa',
      'legalRepresentativeDocumentFrontUrl' => 'DNI representante (frontal)',
      'legalRepresentativeDocumentBackUrl' => 'DNI representante (reverso)',
      'workPhotos' => 'Fotos de trabajos',
      'documentNumber' => 'Número de documento',
      'subcategoryIds' => 'Subcategoría',
      'specialty' => 'Oficio',
      'profilePhotoUrl' => 'Foto de perfil',
      _ => field,
    };
  }

  static String _localizeFieldError(String field, String raw) {
    if (field == 'workPhotos') {
      final normalized = raw.toLowerCase();
      if (normalized.contains('too small') || normalized.contains('>= 6')) {
        return 'Debes mantener al menos 6 fotos. Si cambias una imagen, usa Reemplazar.';
      }
      if (normalized.contains('too big') || normalized.contains('<= 10')) {
        return 'Puedes tener como máximo 10 fotos de trabajos.';
      }
    }
    return raw;
  }

  factory AppException.network([String? message]) => AppException(
        message: message ?? 'Error de conexión. Verifica tu red.',
        code: 'NETWORK_ERROR',
      );

  factory AppException.unauthorized() => const AppException(
        message: 'Sesión expirada. Inicia sesión nuevamente.',
        code: 'UNAUTHORIZED',
        statusCode: 401,
      );

  factory AppException.unknown([String? message]) => AppException(
        message: message ?? 'Ocurrió un error inesperado.',
        code: 'UNKNOWN',
      );

  @override
  String toString() => 'AppException($code): $message';
}
