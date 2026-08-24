class VehicleModel {
  final String id;
  final String number;
  final String ownerId;
  final String owner;
  final String type;
  final String model;
  final String status;

  VehicleModel({
    required this.id,
    required this.number,
    required this.ownerId,
    required this.owner,
    required this.type,
    required this.model,
    required this.status,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id']?.toString() ?? '',
      number: json['number']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      owner: json['owner']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Outside',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'number': number,
      'ownerId': ownerId,
      'owner': owner,
      'type': type,
      'model': model,
      'status': status,
    };
  }
}