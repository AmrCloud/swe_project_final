import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final SharedPreferences prefs;

  LocalStorage(this.prefs);

  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getString(String key) {
    return prefs.getString(key);
  }

  Future<void> remove(String key) async {
    await prefs.remove(key);
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}