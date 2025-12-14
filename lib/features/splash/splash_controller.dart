import 'package:task_manager/data/local/local_storage.dart';

class SplashController {
  final LocalStorage _storage;

  SplashController(this._storage);

  Future<bool> hasSession() async {
    final token = await _storage.getAuthToken();
    return token != null && token.trim().isNotEmpty;
  }
}
