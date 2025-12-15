import 'package:task_manager/data/local/local_storage.dart';
import 'package:task_manager/data/remote/api_client.dart';
import 'package:task_manager/session/session_manager.dart';

export 'package:task_manager/data/remote/api_client.dart' show ApiException;

class AuthApi {
  final ApiClient _client;
  final LocalStorage _storage;

  AuthApi({
    ApiClient? client,
    LocalStorage? storage,
  })  : _client = client ?? ApiClient(),
        _storage = storage ?? LocalStorage();

  String _buildFullName({
    required String firstName,
    required String lastName,
    required String emailFallback,
  }) {
    final String fn = firstName.trim();
    final String ln = lastName.trim();
    final String combined =
        [fn, ln].where((e) => e.isNotEmpty).join(' ').trim();
    if (combined.isNotEmpty) return combined;
    final String local = emailFallback.split('@').first.trim();
    return local.isNotEmpty ? local : 'User';
  }

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
    if (token == null || token.trim().isEmpty) {
      throw ApiException('Login failed. Token is missing.');
    }

    final Map<String, dynamic>? data = response['data'] is Map<String, dynamic>
        ? response['data'] as Map<String, dynamic>
        : null;

    final String emailFromApi =
        (data?['email'] as String?)?.trim().isNotEmpty == true
            ? (data!['email'] as String).trim()
            : email.trim();

    final String firstName = (data?['firstName'] as String?) ?? '';
    final String lastName = (data?['lastName'] as String?) ?? '';
    final String mobile = (data?['mobile'] as String?) ?? '';

    final String fullName = _buildFullName(
      firstName: firstName,
      lastName: lastName,
      emailFallback: emailFromApi,
    );

    final String trimmedToken = token.trim();
    await _storage.setAuthToken(trimmedToken);

    await SessionManager.saveDemoSession(
      token: trimmedToken,
      name: fullName,
      email: emailFromApi,
      mobile: mobile,
      firstName: firstName,
      lastName: lastName,
    );
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

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String mobile,
    String? password,
  }) async {
    final Map<String, dynamic> body = <String, dynamic>{
      'firstName': firstName.trim(),
      'lastName': lastName.trim(),
      'mobile': mobile.trim(),
      'photo': '',
    };

    final String trimmedPassword = (password ?? '').trim();
    if (trimmedPassword.isNotEmpty) {
      body['password'] = trimmedPassword;
    }

    await _client.post(
      '/profileUpdate',
      body: body,
      useAuthToken: true,
    );
  }
}

final AuthApi authApi = AuthApi();
