import 'api_service.dart';

class ParkingService {
  final ApiService _apiService = ApiService();

  Future<dynamic> getParkingSlots() async {
    return await _apiService.get('/parking/slots');
  }

  Future<dynamic> getAvailableSlots() async {
    return await _apiService.get('/parking/available');
  }

  Future<dynamic> assignSlot(
    String vehicleId,
    String slotId,
  ) async {
    return await _apiService.post(
      '/parking/assign',
      {
        'vehicleId': vehicleId,
        'slotId': slotId,
      },
    );
  }

  Future<dynamic> updateSlotStatus(
    String slotId,
    String status,
  ) async {
    return await _apiService.put(
      '/parking/slots/$slotId',
      {
        'status': status,
      },
    );
  }

  Future<dynamic> releaseSlot(String slotId) async {
    return await _apiService.delete(
      '/parking/slots/$slotId',
    );
  }
}