import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  Future<dynamic> getUsers() async {
    return await _apiService.get('/users');
  }

  Future<dynamic> getUser(String userId) async {
    return await _apiService.get('/users/$userId');
  }

  Future<dynamic> createUser(
    String name,
    String email,
    String phone,
  ) async {
    return await _apiService.post(
      '/users',
      {
        'name': name,
        'email': email,
        'phone': phone,
      },
    );
  }

  Future<dynamic> updateUser(
    String userId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      '/users/$userId',
      data,
    );
  }

  Future<dynamic> deleteUser(String userId) async {
    return await _apiService.delete(
      '/users/$userId',
    );
  }
}