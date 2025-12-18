import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around SharedPreferences for simple key-value storage.
///
/// Uses a static instance so it can be accessed from anywhere
/// after calling [LocalStorage.init()] once at app startup.
abstract final class LocalStorage {
  static SharedPreferences? _prefs;

  /// Initialize the underlying SharedPreferences instance.
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Internal getter that throws if accessed before initialization.
  static SharedPreferences get _instance {
    final SharedPreferences? prefs = _prefs;
    if (prefs == null) {
      throw StateError(
        'LocalStorage not initialized. Call LocalStorage.init() first.',
      );
    }
    return prefs;
  }

  /// Read a string value for the given [key].
  static String? getString(String key) {
    return _instance.getString(key);
  }

  /// Save a string [value] under the given [key].
  static Future<void> setString(String key, String value) async {
    await _instance.setString(key, value);
  }

  /// Remove the value associated with the given [key].
  static Future<void> remove(String key) async {
    await _instance.remove(key);
  }
}
