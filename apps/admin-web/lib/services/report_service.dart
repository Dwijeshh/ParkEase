import 'api_service.dart';

class ReportService {
  final ApiService _apiService = ApiService();

  /// Single-call summary: totalVehicles, totalSlots, occupiedSlots,
  /// availableSlots, reservedSlots, occupancy, revenue
  Future<dynamic> getSummary() async {
    return await _apiService.get('/reports');
  }

  Future<dynamic> getDailyReport() async {
    return await _apiService.get('/reports/daily');
  }

  Future<dynamic> getOccupancyReport() async {
    return await _apiService.get('/reports/occupancy');
  }

  Future<dynamic> getRevenueReport() async {
    return await _apiService.get('/reports/revenue');
  }

  Future<dynamic> getVehicleReport() async {
    return await _apiService.get('/reports/vehicles');
  }

  Future<dynamic> getReport(
    String startDate,
    String endDate,
  ) async {
    return await _apiService.get(
      '/reports?startDate=$startDate&endDate=$endDate',
    );
  }
}