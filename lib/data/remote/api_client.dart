import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/data/local/local_storage.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}

class ApiClient {
  static const String baseUrl = 'https://task.teamrabbil.com/api/v1';

  final http.Client _client;
  final LocalStorage _storage;

  ApiClient({
    http.Client? client,
    LocalStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? LocalStorage();

  Future<Map<String, dynamic>> get(
    String path, {
    bool useAuthToken = false,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$path');
    final Map<String, String> headers =
        await _buildHeaders(useAuthToken: useAuthToken);

    final http.Response response = await _client.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool useAuthToken = false,
  }) async {
    final Uri uri = Uri.parse('$baseUrl$path');
    final Map<String, String> headers =
        await _buildHeaders(useAuthToken: useAuthToken);

    final http.Response response = await _client.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  Future<Map<String, String>> _buildHeaders({
    bool useAuthToken = false,
  }) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (useAuthToken) {
      final String? token = await _storage.getAuthToken();
      if (token != null && token.trim().isNotEmpty) {
        headers['token'] = token;
      }
    }

    return headers;
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final int statusCode = response.statusCode;

    Map<String, dynamic> decoded;
    try {
      final dynamic jsonBody = jsonDecode(response.body);
      if (jsonBody is Map<String, dynamic>) {
        decoded = jsonBody;
      } else {
        throw ApiException('Unexpected response format.');
      }
    } on FormatException {
      throw ApiException(
        'Failed to parse server response.',
        statusCode: statusCode,
      );
    }

    final String? status = decoded['status'] as String?;
    if (statusCode == 200 && status == 'success') {
      return decoded;
    }

    final dynamic data = decoded['data'];
    String message = 'Request failed. Please try again.';

    if (data is String && data.trim().isNotEmpty) {
      message = data;
    } else if (data is Map<String, dynamic> && data.isNotEmpty) {
      final List<String> errors = data.values
          .whereType<String>()
          .map((String e) => e.trim())
          .where((String e) => e.isNotEmpty)
          .toList();
      if (errors.isNotEmpty) {
        message = errors.join(' ');
      }
    }

    throw ApiException(message, statusCode: statusCode);
  }
}
