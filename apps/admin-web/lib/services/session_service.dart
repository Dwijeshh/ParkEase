import 'api_service.dart';

class SessionService {
  final ApiService _apiService = ApiService();

  Future<dynamic> getSessions() async {
    return await _apiService.get('/sessions');
  }

  Future<dynamic> getActiveSessions() async {
    return await _apiService.get('/sessions/active');
  }

  Future<dynamic> getSession(String sessionId) async {
    return await _apiService.get('/sessions/$sessionId');
  }

  Future<dynamic> startSession(
    String vehicleId,
    String slotId,
  ) async {
    return await _apiService.post(
      '/sessions',
      {
        'vehicleId': vehicleId,
        'slotId': slotId,
      },
    );
  }

  Future<dynamic> endSession(String sessionId) async {
    return await _apiService.put(
      '/sessions/$sessionId/end',
      {},
    );
  }
}