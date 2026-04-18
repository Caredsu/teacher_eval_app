import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.API_BASE_URL;

  /// Get evaluation status only (check if evaluations are open)
  static Future<Map<String, dynamic>> getTeacherStatus() async {
    try {
      // Try new endpoint first (if backend returns status with teachers)
      try {
        final response = await http.get(
          Uri.parse('$baseUrl/teachers'),
          headers: {'Content-Type': 'application/json'},
        ).timeout(
          const Duration(seconds: 5),
          onTimeout: () => throw Exception('Request timeout'),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['success']) {
            final responseData = data['data'];
            if (responseData is Map && responseData.containsKey('evaluation_status')) {
              return {
                'evaluation_status': responseData['evaluation_status'] ?? 'on',
                'is_evaluations_open': responseData['is_evaluations_open'] ?? true,
              };
            }
          }
        }
      } catch (e) {
        // Fall through to status endpoint
      }

      // Fall back to dedicated status endpoint
      final response = await http.get(
        Uri.parse('$baseUrl/evaluations/status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return {
            'evaluation_status': data['data']['status'] ?? 'on',
            'is_evaluations_open': data['data']['is_open'] ?? false,
          };
        }
      }
      
      // Default to open if unable to check
      return {
        'evaluation_status': 'on',
        'is_evaluations_open': true,
      };
    } catch (e) {
      // Default to open if error
      return {
        'evaluation_status': 'on',
        'is_evaluations_open': true,
      };
    }
  }

  /// Get all teachers from API
  static Future<List<dynamic>> getTeachers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Handle new format: { teachers: [...], evaluation_status: '...', is_evaluations_open: bool }
          // Or legacy format: [...]
          final responseData = data['data'];
          if (responseData is Map && responseData.containsKey('teachers')) {
            return responseData['teachers'] as List<dynamic>;
          } else if (responseData is List) {
            return responseData;
          } else {
            throw Exception('Unexpected teachers response format');
          }
        } else {
          throw Exception(data['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load teachers (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error loading teachers: $e');
    }
  }

  /// Get all teachers WITH evaluation status metadata
  static Future<Map<String, dynamic>> getTeachersWithStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Handle new format with status
          final responseData = data['data'];
          if (responseData is Map && responseData.containsKey('teachers')) {
            return {
              'teachers': responseData['teachers'] as List<dynamic>,
              'evaluation_status': responseData['evaluation_status'] ?? 'on',
              'is_evaluations_open': responseData['is_evaluations_open'] ?? true,
            };
          } else if (responseData is List) {
            // Legacy format - assume evaluations open
            return {
              'teachers': responseData,
              'evaluation_status': 'on',
              'is_evaluations_open': true,
            };
          } else {
            throw Exception('Unexpected teachers response format');
          }
        } else {
          throw Exception(data['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load teachers (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error loading teachers: $e');
    }
  }

  /// Get all questions from API
  static Future<List<dynamic>> getQuestions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/questions'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'] as List<dynamic>;
        } else {
          throw Exception(data['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load questions (${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Error loading questions: $e');
    }
  }

  /// Get all departments from API
  static Future<List<dynamic>> getDepartments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/departments'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data'] as List<dynamic>;
        } else {
          throw Exception(data['message'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load departments');
      }
    } catch (e) {
      throw Exception('Error loading departments: $e');
    }
  }

  /// Submit teacher evaluation with dynamic answers
  static Future<Map<String, dynamic>> submitEvaluation({
    required String teacherId,
    required Map<String, int> answers, // Map of question_id -> rating
    required String feedback,
  }) async {
    try {
      final body = jsonEncode({
        'teacher_id': teacherId,
        'answers': answers,
        'feedback': feedback,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/evaluations.php'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success']) {
        return data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(data['message'] ?? 'Failed to submit evaluation');
      }
    } catch (e) {
      throw Exception('Error submitting evaluation: $e');
    }
  }

  /// Check if evaluations are currently open
  static Future<bool> checkEvaluationStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/evaluations.php/status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          return data['data']['is_open'] ?? false;
        }
      }
      // If unable to check, assume open (don't block user)
      return true;
    } catch (e) {
      // Default to open if unable to check
      return true;
    }
  }

  /// Check connection to API
  static Future<bool> checkConnection() async {
    try {
      // Try to get teachers list - if it works, API is up
      final response = await http.get(
        Uri.parse('$baseUrl/teachers.php'),
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Request timeout'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Submit system experience feedback
  static Future<Map<String, dynamic>> submitSystemFeedback({
    required int rating,
    String? userId,
    String? comments,
  }) async {
    try {
      final body = jsonEncode({
        'rating': rating,
        'user_id': userId,
        'comments': comments ?? '',
      });

      final response = await http.post(
        Uri.parse('$baseUrl/system-feedback.php'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'message': data['message'] ?? 'Feedback saved'};
      } else {
        throw Exception(data['error'] ?? 'Failed to submit feedback');
      }
    } catch (e) {
      throw Exception('Error submitting feedback: $e');
    }
  }
}
