import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesRepository {
  final _secureStorage = FlutterSecureStorage();

  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('first_run') ?? true) {
      await _secureStorage.deleteAll();
      prefs.setBool('first_run', false);
    }
  }
}
