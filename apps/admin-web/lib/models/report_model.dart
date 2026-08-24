class ReportModel {
  final int totalVehicles;
  final int totalSlots;
  final int occupiedSlots;
  final int availableSlots;
  final int reservedSlots;
  final double occupancy;
  final double revenue;

  ReportModel({
    required this.totalVehicles,
    required this.totalSlots,
    required this.occupiedSlots,
    required this.availableSlots,
    required this.reservedSlots,
    required this.occupancy,
    required this.revenue,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      totalVehicles: _toInt(json['totalVehicles']),
      totalSlots: _toInt(json['totalSlots']),
      occupiedSlots: _toInt(json['occupiedSlots']),
      availableSlots: _toInt(json['availableSlots']),
      reservedSlots: _toInt(json['reservedSlots']),
      occupancy: _toDouble(json['occupancy']),
      revenue: _toDouble(json['revenue']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalVehicles': totalVehicles,
      'totalSlots': totalSlots,
      'occupiedSlots': occupiedSlots,
      'availableSlots': availableSlots,
      'reservedSlots': reservedSlots,
      'occupancy': occupancy,
      'revenue': revenue,
    };
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}