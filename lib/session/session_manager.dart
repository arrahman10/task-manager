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

  static String? get userMobile {
    return LocalStorage.getString(StorageKeys.userMobile);
  }

  static String? get userFirstName {
    return LocalStorage.getString(StorageKeys.userFirstName);
  }

  static String? get userLastName {
    return LocalStorage.getString(StorageKeys.userLastName);
  }

  static Future<void> saveDemoSession({
    required String token,
    String? name,
    String? email,
    String? mobile,
    String? firstName,
    String? lastName,
  }) async {
    await LocalStorage.setString(StorageKeys.authToken, token);

    if (name != null && name.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userName, name.trim());
    }

    if (email != null && email.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userEmail, email.trim());
    }

    if (mobile != null && mobile.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userMobile, mobile.trim());
    }

    if (firstName != null && firstName.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userFirstName, firstName.trim());
    }

    if (lastName != null && lastName.trim().isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userLastName, lastName.trim());
    }
  }

  static Future<void> clearSession() async {
    await LocalStorage.remove(StorageKeys.authToken);
    await LocalStorage.remove(StorageKeys.userName);
    await LocalStorage.remove(StorageKeys.userEmail);
    await LocalStorage.remove(StorageKeys.userMobile);
    await LocalStorage.remove(StorageKeys.userFirstName);
    await LocalStorage.remove(StorageKeys.userLastName);
  }
}
