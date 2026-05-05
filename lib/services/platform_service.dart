import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../config/app_config.dart';

// Conditionally import dart:io only for non-web platforms
import 'dart:io' as io show Platform;

/// Service for managing platform-specific functionality
class PlatformService {
  /// Website URL
  static String get websiteUrl => AppConfig.websiteUrl;
  
  /// Play Store URL
  static String get playStoreUrl => AppConfig.playStoreUrl;
  
  /// App Store URL (for future iOS app)
  static String get appStoreUrl => AppConfig.appStoreUrl;

  /// Check if platform is iOS
  static bool get isIOS {
    if (kIsWeb) return false;
    try {
      return io.Platform.isIOS;
    } catch (e) {
      return false;
    }
  }

  /// Check if platform is Android
  static bool get isAndroid {
    if (kIsWeb) return false;
    try {
      return io.Platform.isAndroid;
    } catch (e) {
      return false;
    }
  }

  /// Check if platform is Web
  static bool get isWeb => kIsWeb;

  /// Launch website
  static Future<bool> launchWebsite() async {
    return _launchURL(websiteUrl);
  }

  /// Launch Play Store
  static Future<bool> launchPlayStore() async {
    return _launchURL(playStoreUrl);
  }

  /// Launch App Store
  static Future<bool> launchAppStore() async {
    return _launchURL(appStoreUrl);
  }

  /// Generic URL launcher
  static Future<bool> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Cannot launch URL: $url');
        return false;
      }
    } catch (e) {
      print('Error launching URL: $e');
      return false;
    }
  }

  /// Get device platform name
  static String getPlatformName() {
    if (isIOS) return 'iOS';
    if (isAndroid) return 'Android';
    return 'Web';
  }

  /// Get platform description
  static String getPlatformDescription() {
    if (isIOS) {
      return 'iPhone/iPad (iOS)';
    }
    if (isAndroid) {
      return 'Android Device';
    }
    return 'Web Browser';
  }
}
