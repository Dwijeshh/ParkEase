import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService {
  AuthService({
    http.Client? client,
    FlutterSecureStorage? storage,
  })  : _client = client ?? http.Client(),
        _storage = storage ?? const FlutterSecureStorage();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String tokenKey = 'admin_access_token';
  static const String roleKey = 'admin_role';
  static const String emailKey = 'admin_email';

  final http.Client _client;
  final FlutterSecureStorage _storage;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/api/v1/auth/login'),
      headers: const {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email.trim(),
        'password': password,
      }),
    );

    Map<String, dynamic> body = {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        body = decoded;
      }
    } catch (_) {
      body = {};
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AuthException(
        body['error']?['message']?.toString() ??
            body['message']?.toString() ??
            'Login failed',
      );
    }

    final token = body['token']?.toString() ??
        body['data']?['token']?.toString();

    final role = body['user']?['role']?.toString() ??
        body['data']?['user']?['role']?.toString();

    if (token == null || token.isEmpty) {
      throw AuthException('Login response did not contain a token');
    }

    if (role != 'ADMIN') {
      throw AuthException('Administrator access required');
    }

    await _storage.write(key: tokenKey, value: token);
    await _storage.write(key: roleKey, value: role);
    await _storage.write(key: emailKey, value: email.trim());
  }

  Future<String?> token() {
    return _storage.read(key: tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final value = await token();
    return value != null && value.isNotEmpty;
  }

  Future<void> logout() async {
    await _storage.delete(key: tokenKey);
    await _storage.delete(key: roleKey);
    await _storage.delete(key: emailKey);
  }

  void dispose() {
    _client.close();
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
