class Teacher {
  final String id;
  final String firstname;
  final String lastname;
  final String middlename;
  final String department;

  Teacher({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.middlename,
    required this.department,
  });

  /// Full name of the teacher
  String get fullName => '$firstname $lastname';

  /// Full name with middle name
  String get fullNameWithMiddle {
    if (middlename.isEmpty) {
      return fullName;
    }
    return '$firstname $middlename $lastname';
  }

  /// Create Teacher from JSON response
  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      middlename: json['middlename'] as String? ?? '',
      department: json['department'] as String,
    );
  }

  /// Convert Teacher to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'middlename': middlename,
      'department': department,
    };
  }

  @override
  String toString() => 'Teacher(id: $id, name: $fullName, dept: $department)';
}
