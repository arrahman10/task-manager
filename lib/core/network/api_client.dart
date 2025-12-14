import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_manager/core/network/api_config.dart';
import 'package:task_manager/core/network/api_exception.dart';
import 'package:task_manager/core/session/session_manager.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _buildUri(
    String path, {
    Map<String, String>? queryParameters,
  }) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final url = '${ApiConfig.baseUrl}$normalizedPath';
    return Uri.parse(url).replace(queryParameters: queryParameters);
  }

  Map<String, String> _buildHeaders({
    Map<String, String>? headers,
  }) {
    final token = SessionManager.authToken;

    final baseHeaders = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null && token.trim().isNotEmpty)
        'Authorization': 'Bearer $token',
    };

    if (headers == null || headers.isEmpty) return baseHeaders;
    return {...baseHeaders, ...headers};
  }

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    final uri = _buildUri(path, queryParameters: queryParameters);

    try {
      final response = await _client
          .get(uri, headers: _buildHeaders(headers: headers))
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('GET request failed: $e');
    }
  }

  Future<dynamic> post(
    String path, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
    Object? body,
  }) async {
    final uri = _buildUri(path, queryParameters: queryParameters);

    try {
      final response = await _client
          .post(
            uri,
            headers: _buildHeaders(headers: headers),
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('POST request failed: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final status = response.statusCode;
    final rawBody = response.body;

    dynamic decoded;
    if (rawBody.isNotEmpty) {
      try {
        decoded = jsonDecode(rawBody);
      } catch (_) {
        decoded = rawBody;
      }
    }

    if (status >= 200 && status < 300) {
      return decoded;
    }

    throw ApiException(
      'Request failed',
      statusCode: status,
      body: decoded,
    );
  }
}
