import 'package:shared_preferences/shared_preferences.dart';

class EvaluationTracker {
  static const String _prefixKey = 'evaluated_teacher_';

  /// Mark a teacher as evaluated
  static Future<void> markAsEvaluated(String teacherId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefixKey$teacherId', true);
  }

  /// Check if a teacher has been evaluated
  static Future<bool> isEvaluated(String teacherId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('$_prefixKey$teacherId') ?? false;
  }

  /// Get all evaluated teacher IDs
  static Future<List<String>> getEvaluatedTeacherIds() async {
    final prefs = await SharedPreferences.getInstance();
    final evaluatedIds = <String>[];
    
    for (String key in prefs.getKeys()) {
      if (key.startsWith(_prefixKey) && prefs.getBool(key) == true) {
        evaluatedIds.add(key.replaceFirst(_prefixKey, ''));
      }
    }
    
    return evaluatedIds;
  }

  /// Clear evaluation history
  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final evaluatedIds = await getEvaluatedTeacherIds();
    
    for (String id in evaluatedIds) {
      await prefs.remove('$_prefixKey$id');
    }
  }
}
