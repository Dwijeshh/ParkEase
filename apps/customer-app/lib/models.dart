import 'package:flutter/material.dart';

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
