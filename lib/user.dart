import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  static final _storage = FlutterSecureStorage();
  static final _studentIdKey = 'student_id';
  static final _studentNameKey = 'student_name';

  static Future<String> get studentId => _storage.read(key: _studentIdKey);

  static void setStudentId(String id) =>
      _storage.write(key: _studentIdKey, value: id);

  static Future<String> get studentName => _storage.read(key: _studentNameKey);

  static void setStudentName(String name) =>
      _storage.write(key: _studentNameKey, value: name);
}
