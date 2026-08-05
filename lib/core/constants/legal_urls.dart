import '../config/app_config.dart';

/// URLs públicas de documentos legales servidos por el backend en `/legal`.
///
/// El backend expone estas páginas en el **origen** (scheme + host),
/// fuera del prefijo `/api/v1`. Por eso derivamos el origen desde
/// [AppConfig.baseUrl] en lugar de concatenar sobre la base del API.
abstract final class LegalUrls {
  static Uri get _origin {
    final api = Uri.parse(AppConfig.baseUrl);
    return Uri(
      scheme: api.hasScheme ? api.scheme : 'https',
      host: api.host,
      port: api.hasPort ? api.port : null,
    );
  }

  static Uri get termsAndConditions =>
      _origin.replace(path: '/legal/terminos-y-condiciones.html');

  static Uri get privacyPolicy =>
      _origin.replace(path: '/legal/politica-de-privacidad.html');
}
