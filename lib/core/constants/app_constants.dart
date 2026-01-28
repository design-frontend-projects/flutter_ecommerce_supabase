/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'E-Commerce Inventory';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int pageSize = 20;
  static const int searchDebounceMs = 400;
  static const int minSearchLength = 2;

  // Cache Keys
  static const String userKey = 'user';
  static const String roleKey = 'role';
  static const String cartKey = 'cart';
  static const String favoritesKey = 'favorites';
  static const String themeKey = 'theme';
  static const String onboardingKey = 'onboarding_complete';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration requestTimeout = Duration(seconds: 15);

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
}
