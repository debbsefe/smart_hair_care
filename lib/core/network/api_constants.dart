/// API constants for network configuration.
abstract final class ApiConstants {
  /// Open Beauty Facts API base URL.
  static const String openBeautyFactsBaseUrl =
      'https://world.openbeautyfacts.org/api/v2';

  /// Open Food Facts API base URL (fallback for broader coverage).
  static const String openFoodFactsBaseUrl =
      'https://world.openfoodfacts.org/api/v2';

  /// Connection timeout in milliseconds.
  static const int connectTimeout = 30000;

  /// Receive timeout in milliseconds.
  static const int receiveTimeout = 30000;

  /// Send timeout in milliseconds.
  static const int sendTimeout = 30000;
}
