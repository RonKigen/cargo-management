class ApiConfig {
  // Base URL for API endpoints
  static const String baseUrl = 'http://localhost:5001';

  // API timeout duration in seconds
  static const int timeoutDuration = 30;

  // API version
  static const String apiVersion = 'v1';

  // Additional configuration options could be added here
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // API endpoints paths
  static const String shipmentsEndpoint = '/shipments';
  static const String recentShipmentsEndpoint = '/shipments/recent';
}
