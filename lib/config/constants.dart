/// Configuration constants for the Teacher Evaluation App
/// 
/// Update the API_BASE_URL based on where your backend is running:
/// - Development on PC:      http://<YOUR_PC_IP>/teacher-eval/api
/// - Android Emulator:       http://10.0.2.2/teacher-eval/api
/// - Physical Android Phone: http://<YOUR_PC_IP>/teacher-eval/api
/// - iOS Simulator:          http://localhost/teacher-eval/api
/// - Production:             https://your-production-domain.com/teacher-eval/api

class AppConstants {
  // ==================== API Configuration ====================
  /// 🔧 UPDATE THIS: Replace with your backend server IP or domain
  /// Example: http://192.168.1.100/teacher-eval/api
  static const String API_BASE_URL = 'http://10.0.2.2/teacher-eval/api';

  // Alternative configurations (uncomment the one you need):
  // static const String API_BASE_URL = 'http://10.0.2.2/teacher-eval/api'; // Android Emulator
  // static const String API_BASE_URL = 'http://localhost/teacher-eval/api'; // iOS Simulator
  // static const String API_BASE_URL = 'https://your-domain.com/teacher-eval/api'; // Production

  // ==================== API Endpoints ====================
  static const String ENDPOINT_LOGIN = '/login';
  static const String ENDPOINT_TEACHERS = '/teachers';
  static const String ENDPOINT_EVALUATIONS = '/evaluations';
  static const String ENDPOINT_DEPARTMENTS = '/departments';
  static const String ENDPOINT_QUESTIONS = '/questions.php?action=get_questions';

  // ==================== Validation Rules ====================
  /// Minimum stars in evaluation form
  static const int MIN_RATING = 1;
  /// Maximum stars in evaluation form
  static const int MAX_RATING = 5;
  /// Minimum feedback text length
  static const int MIN_FEEDBACK_LENGTH = 10;
  /// Maximum feedback text length
  static const int MAX_FEEDBACK_LENGTH = 1000;

  // ==================== UI Configuration ====================
  /// Default timeout for API requests (in seconds)
  static const int API_TIMEOUT = 30;
  /// App name
  static const String APP_NAME = 'Teacher Evaluation';
  /// App version
  static const String APP_VERSION = '1.0.0';

  // ==================== Messages ====================
  static const String MSG_CONNECTION_ERROR = 'Connection error. Please check your internet and API URL.';
  static const String MSG_SERVER_ERROR = 'Server error. Please try again later.';
  static const String MSG_VALIDATION_ERROR = 'Please fill all required fields with valid data.';
  static const String MSG_EVALUATION_SUCCESS = 'Thank you! Your evaluation has been submitted successfully.';
  static const String MSG_LOADING = 'Loading...';

  // ==================== Change Log ====================
  /// 
  /// How to configure for different environments:
  /// 
  /// 1. DEVELOPMENT ON YOUR PC:
  ///    - Get your PC IP: Open CMD and run: ipconfig
  ///    - Look for IPv4 Address (usually 192.168.x.x or 10.0.0.x)
  ///    - Set: static const String API_BASE_URL = 'http://192.168.1.100/teacher-eval/api';
  ///    - Make sure XAMPP/backend is running on your PC
  ///
  /// 2. ANDROID EMULATOR:
  ///    - The emulator cannot access localhost
  ///    - Use special address: 10.0.2.2
  ///    - Set: static const String API_BASE_URL = 'http://10.0.2.2/teacher-eval/api';
  ///    - Make sure XAMPP/backend is running on your PC
  ///
  /// 3. PHYSICAL ANDROID PHONE (same WiFi as PC):
  ///    - Get your PC IP as described in #1
  ///    - Use that IP address
  ///    - Set: static const String API_BASE_URL = 'http://192.168.1.100/teacher-eval/api';
  ///    - Make sure XAMPP/backend is accessible from the phone's network
  ///
  /// 4. PRODUCTION:
  ///    - Deploy backend to a real server
  ///    - Use HTTPS (not HTTP)
  ///    - Set: static const String API_BASE_URL = 'https://teacher-eval.example.com/api';
  ///
}

/// 🎯 QUICK FIX
/// If your app shows "Connection error", update line ~15 with your backend URL!
