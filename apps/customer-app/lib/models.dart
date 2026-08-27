import 'package:flutter/material.dart';

/// QR payload format from the backend: a Python-tuple-style string
/// `(id, mallName, city, capacity, ratePerHour)`, e.g.
/// `(1, 'Mall1', 'Udipi', 85, 30.00)`.
final _lotInfoPattern =
    RegExp(r"""^\(\s*(\d+)\s*,\s*'([^']*)'\s*,\s*'([^']*)'\s*,\s*(\d+)\s*,\s*([\d.]+)\s*\)$""");

class LotInfo {
  final int id;
  final String mallName;
  final String city;
  final int capacity;
  final double ratePerHour;

  const LotInfo({
    required this.id,
    required this.mallName,
    required this.city,
    required this.capacity,
    required this.ratePerHour,
  });

  factory LotInfo.parse(String raw) {
    final match = _lotInfoPattern.firstMatch(raw.trim());
    if (match == null) {
      throw FormatException('Unrecognized lot QR payload: $raw');
    }
    return LotInfo(
      id: int.parse(match.group(1)!),
      mallName: match.group(2)!,
      city: match.group(3)!,
      capacity: int.parse(match.group(4)!),
      ratePerHour: double.parse(match.group(5)!),
    );
  }
}

class ParkingAssignment {
  final String store;
  final String entrance;
  final String slot;
  final IconData icon;

  const ParkingAssignment({
    required this.store,
    required this.entrance,
    required this.slot,
    required this.icon,
  });
}

const destinationOptions = [
  ParkingAssignment(store: 'Retail', entrance: 'Entrance 1', slot: 'B01', icon: Icons.storefront_rounded),
  ParkingAssignment(store: 'Super Market', entrance: 'Entrance 2', slot: 'B03', icon: Icons.local_grocery_store_rounded),
  ParkingAssignment(store: 'Food Court', entrance: 'Entrance 3', slot: 'B05', icon: Icons.restaurant_rounded),
  ParkingAssignment(store: 'Cinema', entrance: 'Entrance 4', slot: 'B07', icon: Icons.local_movies_rounded),
  ParkingAssignment(store: 'Office Lobby', entrance: 'Entrance 5', slot: 'E02', icon: Icons.business_center_rounded),
];
