import 'package:task_manager/core/storage/local_storage.dart';
import 'package:task_manager/core/storage/storage_keys.dart';

abstract final class SessionManager {
  static Future<bool> hasValidSession() async {
    final token = LocalStorage.getString(StorageKeys.authToken);
    return token != null && token.trim().isNotEmpty;
  }

  static String? get authToken {
    return LocalStorage.getString(StorageKeys.authToken);
  }

  static String? get userName {
    return LocalStorage.getString(StorageKeys.userName);
  }

  static String? get userEmail {
    return LocalStorage.getString(StorageKeys.userEmail);
  }

  static Future<void> saveDemoSession({
    required String token,
    String? name,
    String? email,
  }) async {
    await LocalStorage.setString(StorageKeys.authToken, token);

    if (name != null && name.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userName, name.trim());
    }

    if (email != null && email.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userEmail, email.trim());
    }
  }

  static Future<void> clearSession() async {
    await LocalStorage.remove(StorageKeys.authToken);
    await LocalStorage.remove(StorageKeys.userName);
    await LocalStorage.remove(StorageKeys.userEmail);
  }
}
