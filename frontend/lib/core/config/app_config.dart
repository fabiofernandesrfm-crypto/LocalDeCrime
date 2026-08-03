class AppConfig {
  static const String appName = 'PCPE Local de Crime';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  AppConfig._();
}