class ParkingSlotModel {
  final String id;
  final String status;
  final String vehicleId;
  final String vehicle;

  ParkingSlotModel({
    required this.id,
    required this.status,
    required this.vehicleId,
    required this.vehicle,
  });

  factory ParkingSlotModel.fromJson(Map<String, dynamic> json) {
    return ParkingSlotModel(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Available',
      vehicleId: json['vehicleId']?.toString() ?? '',
      vehicle: json['vehicle']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'vehicleId': vehicleId,
      'vehicle': vehicle,
    };
  }
}