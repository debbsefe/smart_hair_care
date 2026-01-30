/// API constants for network configuration.
abstract final class ApiConstants {
  /// Open Beauty Facts API base URL (root domain for CGI endpoints).
  static const String openBeautyFactsBaseUrl =
      'https://world.openbeautyfacts.org';

  /// Open Food Facts API base URL (root domain for CGI endpoints).
  static const String openFoodFactsBaseUrl = 'https://world.openfoodfacts.org';

  /// Connection timeout in milliseconds.
  static const int connectTimeout = 30000;

  /// Receive timeout in milliseconds.
  static const int receiveTimeout = 30000;

  /// Send timeout in milliseconds.
  static const int sendTimeout = 30000;
}
