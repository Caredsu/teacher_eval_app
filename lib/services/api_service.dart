import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.API_BASE_URL;

  /// Get all teachers from API
  static Future<List<dynamic>> getTeachers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/teachers.php'),
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
        Uri.parse('$baseUrl/questions.php?action=get_questions'),
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
        Uri.parse('$baseUrl/departments.php'),
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
}
