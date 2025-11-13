/// Application Configuration
/// 
/// This file contains all app-level configuration including
/// API URLs, timeouts, and environment-specific settings.

class AppConfig {
  // Prevent instantiation
  AppConfig._();
  
  /// Current environment
  /// Options: 'development', 'staging', 'production'
  static const String environment = 'development';

  /// API Base URL based on environment
  static String get apiBaseUrl {
    switch (environment) {
      case 'development':
        // Use 10.0.2.2 for Android emulator, localhost for iOS simulator
        return 'https://mirha.swapdez.app/api';
      case 'staging':
        return 'https://staging-api.yourdomain.com/api';
      case 'production':
      default:
        return 'https://api.yourdomain.com/api';
    }
  }
  
  /// Web URL for images and assets
  static String get webBaseUrl {
    return apiBaseUrl.replaceAll('/api', '');
  }
  
  /// Network timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  /// Pagination
  static const int defaultPageSize = 15;
  static const int maxPageSize = 100;
  
  /// Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeModeKey = 'theme_mode';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String languageKey = 'language_code';
  
  /// Cache Keys
  static const String propertiesCacheKey = 'properties_cache';
  static const String dashboardCacheKey = 'dashboard_cache';
  static const String notificationsCacheKey = 'notifications_cache';
  
  /// App Info
  static const String appName = 'Rental Management';
  static const String appVersion = '1.0.0';
  static const int appBuildNumber = 1;
  
  /// API Request Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  
  /// Feature Flags
  static const bool enableBiometric = true;
  static const bool enableGoogleSignIn = true;
  static const bool enablePhoneAuth = true;
  static const bool enableOfflineMode = true;
  static const bool enablePushNotifications = true;
  
  /// Image Configuration
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const double imageQuality = 0.8;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png'];
  
  /// Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int minPhoneLength = 10;
  
  /// Cache Duration
  static const Duration cacheDuration = Duration(hours: 24);
  static const Duration tokenRefreshBuffer = Duration(minutes: 5);
  
  /// Debug Mode
  static bool get isDebugMode => environment == 'development';
  static bool get isProduction => environment == 'production';
  
  /// Logging
  static bool get enableLogging => isDebugMode;
}
