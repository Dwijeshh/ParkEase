class SessionModel {
  final String id;
  final String vehicleId;
  final String vehicle;
  final String userId;
  final String user;
  final String slotId;
  final String slot;
  final String entry;
  final String duration;
  final String status;

  SessionModel({
    required this.id,
    required this.vehicleId,
    required this.vehicle,
    required this.userId,
    required this.user,
    required this.slotId,
    required this.slot,
    required this.entry,
    required this.duration,
    required this.status,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id']?.toString() ?? '',
      vehicleId: json['vehicleId']?.toString() ?? '',
      vehicle: json['vehicle']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      user: json['user']?.toString() ?? '',
      slotId: json['slotId']?.toString() ?? '',
      slot: json['slot']?.toString() ?? '',
      entry: json['entry']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicle': vehicle,
      'userId': userId,
      'user': user,
      'slotId': slotId,
      'slot': slot,
      'entry': entry,
      'duration': duration,
      'status': status,
    };
  }
}