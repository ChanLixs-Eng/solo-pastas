class ApiConfig {
  static const String _host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'localhost',
  );
  static final String baseUrl = 'http://$_host:8000/api/v1';
  static const String appPin = '1234';
  static const Duration timeout = Duration(seconds: 15);
}
