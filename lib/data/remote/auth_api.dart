import 'package:task_manager/data/local/local_storage.dart';
import 'package:task_manager/data/remote/api_client.dart';

export 'package:task_manager/data/remote/api_client.dart' show ApiException;

class AuthApi {
  final ApiClient _client;
  final LocalStorage _storage;

  AuthApi({
    ApiClient? client,
    LocalStorage? storage,
  })  : _client = client ?? ApiClient(),
        _storage = storage ?? LocalStorage();

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> response = await _client.post(
      '/login',
      body: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    final String? token = response['token'] as String?;
    if (token != null && token.trim().isNotEmpty) {
      await _storage.setAuthToken(token);
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    String? mobile,
  }) async {
    final String trimmedName = fullName.trim();
    final List<String> parts = trimmedName.split(' ');
    final String firstName = parts.isNotEmpty ? parts.first : '';
    final String lastName =
        parts.length > 1 ? parts.sublist(1).join(' ').trim() : '';

    await _client.post(
      '/registration',
      body: <String, dynamic>{
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'mobile': mobile ?? '',
        'password': password,
        'photo': '',
      },
    );
  }

  Future<void> sendPasswordResetCode({
    required String email,
  }) async {
    await _client.get('/RecoverVerifyEmail/$email');
  }

  Future<void> verifyPasswordResetCode({
    required String email,
    required String code,
  }) async {
    await _client.get('/RecoverVerifyOTP/$email/$code');
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _client.post(
      '/RecoverResetPass',
      body: <String, dynamic>{
        'email': email,
        'OTP': code,
        'password': newPassword,
      },
    );
  }
}

final AuthApi authApi = AuthApi();
