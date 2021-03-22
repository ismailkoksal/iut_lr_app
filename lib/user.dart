import 'package:shared_preferences/shared_preferences.dart';

class User {
  static final _studentIdKey = 'student_id';
  static final _studentNameKey = 'student_name';

  static Future<String> get studentId async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_studentIdKey);
  }

  static Future<void> setStudentId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_studentIdKey, id);
  }

  static Future<String> get studentName async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_studentNameKey);
  }

  static Future<void> setStudentName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_studentNameKey, name);
  }
}
