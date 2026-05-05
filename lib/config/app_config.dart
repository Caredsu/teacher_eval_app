/// App Configuration
/// This centralized configuration makes it easy to manage app-wide settings
class AppConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://fullbright-teacher-eval.netlify.app/api';
  
  // Website & External Links
  static const String websiteUrl = 'https://fullbright-teacher-eval.netlify.app';
  static const String schoolEmail = 'fullbrightcollege@yahoo.com';
  static const String schoolPhone = '+63-XXX-XXXX'; // Update with actual number
  
  // Store Links
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.fullbright.teacher_eval_app';
  static const String appStoreUrl = 'https://apps.apple.com/app/teacher-eval/id123456789';
  
  // School Information
  static const String schoolName = 'Fullbright College Inc.';
  static const String schoolAddress = 'KM 5 National Highway, San Jose, Puerto Princesa, Philippines, 5300';
  
  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableAnalytics = false;
  static const bool enableBetaFeatures = false;
  
  // App Information
  static const String appName = 'Teacher Evaluation';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // Timeouts (in milliseconds)
  static const int apiTimeout = 30000;
  static const int connectionTimeout = 10000;
  
  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxNameLength = 100;
  
  // Colors (used in multiple places)
  static const String primaryColor = '#667eea';
  static const String primaryDarkColor = '#764ba2';
  static const String backgroundColor = '#1a202c';
  
  /// Get full website URL
  static String getFullWebsiteUrl(String path) {
    return '$websiteUrl$path';
  }
  
  /// Get full API URL
  static String getFullApiUrl(String endpoint) {
    return '$apiBaseUrl$endpoint';
  }
  
  /// Update Play Store URL (call this if package name changes)
  static String getPlayStoreUrl(String packageName) {
    return 'https://play.google.com/store/apps/details?id=$packageName';
  }
}
