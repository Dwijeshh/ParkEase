import 'api_service.dart';

class VehicleService {
  final ApiService _apiService = ApiService();

  Future<dynamic> getVehicles() async {
    return await _apiService.get('/vehicles');
  }

  Future<dynamic> getVehicle(String vehicleId) async {
    return await _apiService.get('/vehicles/$vehicleId');
  }

  Future<dynamic> createVehicle(
    String number,
    String ownerId,
    String type,
    String model,
  ) async {
    return await _apiService.post(
      '/vehicles',
      {
        'number': number,
        'ownerId': ownerId,
        'type': type,
        'model': model,
      },
    );
  }

  Future<dynamic> updateVehicle(
    String vehicleId,
    Map<String, dynamic> data,
  ) async {
    return await _apiService.put(
      '/vehicles/$vehicleId',
      data,
    );
  }

  Future<dynamic> deleteVehicle(String vehicleId) async {
    return await _apiService.delete(
      '/vehicles/$vehicleId',
    );
  }
}