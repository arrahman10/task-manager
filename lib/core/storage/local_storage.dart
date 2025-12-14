import 'package:shared_preferences/shared_preferences.dart';

abstract final class LocalStorage {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError(
          'LocalStorage not initialized. Call LocalStorage.init() first.');
    }
    return prefs;
  }

  static String? getString(String key) {
    return _instance.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  static Future<void> remove(String key) async {
    await _instance.remove(key);
  }
}
