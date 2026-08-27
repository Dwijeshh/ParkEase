import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CustomerApiService {
  static const String baseUrl = 'http://localhost:3000/api/v1';
  static const _storage = FlutterSecureStorage();

  // ── Auth ────────────────────────────────────────────────────

  /// Login with email + password. Stores token & user info.
  /// Throws [ApiException] on failure.
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        body['error']?['message']?.toString() ??
            body['message']?.toString() ??
            'Login failed',
      );
    }
    final token = body['token']?.toString() ?? body['data']?['token']?.toString();
    if (token == null) throw ApiException('No token in response');
    await _storage.write(key: 'customer_token', value: token);
    final user = body['user'] ?? body['data']?['user'] ?? {};
    await _storage.write(key: 'customer_user_id', value: user['id']?.toString() ?? '');
    await _storage.write(key: 'customer_name', value: user['name']?.toString() ?? '');
    await _storage.write(key: 'customer_email', value: email);
    return Map<String, dynamic>.from(user);
  }

  /// Register a new user.
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String licensePlate,
    required String vehicleType,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'licensePlate': licensePlate,
        'vehicleType': vehicleType,
      }),
    );
    final body = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(body['message']?.toString() ?? 'Registration failed');
    }
    return Map<String, dynamic>.from(body['data'] ?? body);
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'customer_token');
    await _storage.delete(key: 'customer_user_id');
    await _storage.delete(key: 'customer_name');
    await _storage.delete(key: 'customer_email');
  }

  static Future<String?> getToken() => _storage.read(key: 'customer_token');
  static Future<String?> getUserId() => _storage.read(key: 'customer_user_id');
  static Future<String?> getUserName() => _storage.read(key: 'customer_name');

  // ── Map / Routing ────────────────────────────────────────────

  /// Fetches all map nodes.
  static Future<List<Map<String, dynamic>>> getMapNodes() async {
    final headers = await _authHeaders();
    final response = await http.get(Uri.parse('$baseUrl/map/nodes'), headers: headers);
    final body = _decode(response);
    final data = body['data'];
    if (data is List) return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
    return [];
  }

  /// Finds the nearest available slot for a given entrance node and vehicle type.
  static Future<Map<String, dynamic>?> getNearestSlot(int entranceId, String vehicleType) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl/map/nearest-slot?entranceId=$entranceId&type=$vehicleType');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final body = _decode(response);
      return body['data'] is Map ? Map<String, dynamic>.from(body['data']) : null;
    }
    return null;
  }

  /// Gets the driving route from the main entry to a parking slot.
  static Future<Map<String, dynamic>?> getEntryRoute(int parkingNodeId) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl/map/routes/entry/$parkingNodeId');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final body = _decode(response);
      return body['data'] is Map ? Map<String, dynamic>.from(body['data']) : null;
    }
    return null;
  }

  /// Gets the driving route from a parking slot to the exit.
  static Future<Map<String, dynamic>?> getExitRoute(int parkingNodeId) async {
    final headers = await _authHeaders();
    final uri = Uri.parse('$baseUrl/map/routes/exit/$parkingNodeId');
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final body = _decode(response);
      return body['data'] is Map ? Map<String, dynamic>.from(body['data']) : null;
    }
    return null;
  }

  // ── Sessions ─────────────────────────────────────────────────

  /// Starts a parking session. Returns the session data.
  static Future<Map<String, dynamic>> startSession({
    required String vehicleId,
    required String slotId,
  }) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/sessions'),
      headers: headers,
      body: jsonEncode({'vehicleId': vehicleId, 'slotId': slotId}),
    );
    final body = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(body['message']?.toString() ?? 'Failed to start session');
    }
    return Map<String, dynamic>.from(body['data'] ?? body);
  }

  /// Ends a parking session. Returns checkout info including amount.
  static Future<Map<String, dynamic>> endSession(String sessionId) async {
    final headers = await _authHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/sessions/$sessionId/end'),
      headers: headers,
      body: jsonEncode({}),
    );
    final body = _decode(response);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(body['message']?.toString() ?? 'Failed to end session');
    }
    return Map<String, dynamic>.from(body['data'] ?? body);
  }

  /// Gets the active session for the current user.
  static Future<Map<String, dynamic>?> getActiveSession() async {
    final userId = await getUserId();
    if (userId == null || userId.isEmpty) return null;
    final headers = await _authHeaders();
    final response = await http.get(Uri.parse('$baseUrl/sessions/active'), headers: headers);
    if (response.statusCode == 200) {
      final body = _decode(response);
      final data = body['data'];
      if (data is List && data.isNotEmpty) {
        // Return session belonging to this user
        final userSession = data.whereType<Map>().firstWhere(
          (s) => s['userId']?.toString() == userId,
          orElse: () => {},
        );
        if (userSession.isNotEmpty) return Map<String, dynamic>.from(userSession);
      }
    }
    return null;
  }

  // ── Vehicles ─────────────────────────────────────────────────

  /// Gets vehicles for the current user.
  static Future<List<Map<String, dynamic>>> getUserVehicles() async {
    final userId = await getUserId();
    if (userId == null) return [];
    final headers = await _authHeaders();
    final response = await http.get(Uri.parse('$baseUrl/users/$userId'), headers: headers);
    if (response.statusCode == 200) {
      final body = _decode(response);
      final data = body['data'];
      if (data is Map && data['vehicle'] is Map) {
        return [Map<String, dynamic>.from(data['vehicle'])];
      }
    }
    return [];
  }

  // ── Internals ─────────────────────────────────────────────────

  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _decode(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }
}

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}
