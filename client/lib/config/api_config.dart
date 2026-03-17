class ApiConfig {
  static const String _host = String.fromEnvironment(
    'API_HOST',
    defaultValue: 'localhost',
  );
  static const String _port = String.fromEnvironment(
    'API_PORT',
    defaultValue: '8000',
  );
  static const String _scheme = String.fromEnvironment(
    'API_SCHEME',
    defaultValue: 'http',
  );
  static const String appPin = String.fromEnvironment(
    'APP_PIN',
    defaultValue: '1234',
  );
  static final String baseUrl = '$_scheme://$_host:$_port/api/v1';
  static const Duration timeout = Duration(seconds: 15);
}
