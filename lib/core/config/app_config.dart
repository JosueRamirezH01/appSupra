class AppConfig {
  AppConfig._();

  /// Sobrescribe con --dart-define o --dart-define-from-file (ver config/env.*.json).
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
      defaultValue: 'https://demosupra.cimakperu.com/api/v1',
    //defaultValue: 'https://demosupra.cimakperu.com/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);
  /// GET de listados/fichas. Uploads siguen con [receiveTimeout].
  static const Duration listConnectTimeout = Duration(seconds: 10);
  static const Duration listReceiveTimeout = Duration(seconds: 10);

  /// Web Client ID de Google Cloud (mismo valor que GOOGLE_CLIENT_ID del backend).
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '67654682347-cn98fbt6rqi3hoau786a55gkf195at4n.apps.googleusercontent.com',
  );

  /// Maps SDK key (Android: local.properties GOOGLE_MAPS_API_KEY; iOS: GMSApiKey en Info.plist).
  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static bool get isProductionApi =>
      !baseUrl.contains('ngrok') &&
      !baseUrl.contains('localhost') &&
      !baseUrl.contains('10.0.2.2') &&
      !baseUrl.contains('192.168.');
}
