import 'package:flutter/material.dart';

class ParkingAssignment {
  final String store;
  final String entrance;
  final String slot;
  final IconData icon;
  /// The mall entrance node ID used for routing (maps to map_nodes with type MALL_ENTRY)
  final int mallEntranceId;
  /// The parking slot DB id used to start a session
  final String slotId;

  const ParkingAssignment({
    required this.store,
    required this.entrance,
    required this.slot,
    required this.icon,
    this.mallEntranceId = 1,
    this.slotId = '',
  });
}

/// Static destination options (mall sections). Used as selection labels;
/// the actual slot is resolved dynamically from the /map/nearest-slot API.
const mallDestinations = [
  MallDestination(store: 'Retail',       entrance: 'Entrance 1', mallEntranceId: 1, icon: Icons.storefront_rounded),
  MallDestination(store: 'Super Market', entrance: 'Entrance 2', mallEntranceId: 2, icon: Icons.local_grocery_store_rounded),
  MallDestination(store: 'Food Court',   entrance: 'Entrance 3', mallEntranceId: 3, icon: Icons.restaurant_rounded),
  MallDestination(store: 'Cinema',       entrance: 'Entrance 4', mallEntranceId: 4, icon: Icons.local_movies_rounded),
  MallDestination(store: 'Office Lobby', entrance: 'Entrance 5', mallEntranceId: 5, icon: Icons.business_center_rounded),
];

class MallDestination {
  final String store;
  final String entrance;
  final int mallEntranceId;
  final IconData icon;
  const MallDestination({
    required this.store,
    required this.entrance,
    required this.mallEntranceId,
    required this.icon,
  });
}
