import '../theme/app_colours.dart';

/// Plain data model for a parking slot.
/// Replace/extend with fields from your backend response.
class ParkingSlot {
  const ParkingSlot({
    required this.id,
    required this.status,
    this.vehicleNumber,
    this.ownerName,
    this.since,
    this.distanceFromEntranceMeters,
  });

  final String id; // e.g. "A03"
  final SlotStatus status;
  final String? vehicleNumber; // e.g. "KA 20 AB 1234"
  final String? ownerName;
  final DateTime? since;
  final double? distanceFromEntranceMeters;

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      id: json['id'] as String,
      status: SlotStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String).toLowerCase(),
        orElse: () => SlotStatus.available,
      ),
      vehicleNumber: json['vehicleNumber'] as String?,
      ownerName: json['ownerName'] as String?,
      since: json['since'] != null ? DateTime.tryParse(json['since']) : null,
      distanceFromEntranceMeters:
          (json['distanceFromEntranceMeters'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status.name,
        'vehicleNumber': vehicleNumber,
        'ownerName': ownerName,
        'since': since?.toIso8601String(),
        'distanceFromEntranceMeters': distanceFromEntranceMeters,
      };
}
