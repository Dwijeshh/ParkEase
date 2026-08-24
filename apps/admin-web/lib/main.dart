import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'theme/app_theme.dart';
import 'theme/app_colours.dart';
import 'theme/parking_slot.dart';
import 'theme/stat_card.dart';
import 'theme/parking_map_grid.dart';
import 'theme/slot_detail_sheet.dart';

void main() {
  runApp(const ParkEaseApp());
}

class ParkEaseApp extends StatelessWidget {
  const ParkEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkEase Admin',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const DashboardScreen(),
    );
  }
}


/// Demo entry point — shows the theme + widgets wired into a
/// working Dashboard screen (matches doc section 1 + 3).
/// Run with: flutter run -t lib/main.dart
//void main() => runApp(const SmartParkingAdminApp());

class SmartParkingAdminApp extends StatelessWidget {
  const SmartParkingAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Parking · Admin',
      theme: AppTheme.light,
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Sample data — swap for your API/JWT-authenticated backend response.
  static final _slots = <ParkingSlot>[
    const ParkingSlot(id: 'A1', status: SlotStatus.available),
    const ParkingSlot(
      id: 'A2',
      status: SlotStatus.occupied,
      vehicleNumber: 'KA 20 AB 1234',
      ownerName: 'Aditya',
    ),
    const ParkingSlot(id: 'A3', status: SlotStatus.available),
    const ParkingSlot(id: 'A4', status: SlotStatus.available),
    const ParkingSlot(id: 'B1', status: SlotStatus.available),
    const ParkingSlot(id: 'B2', status: SlotStatus.available),
    const ParkingSlot(
      id: 'B3',
      status: SlotStatus.reserved,
      ownerName: 'Rahul',
    ),
    const ParkingSlot(id: 'B4', status: SlotStatus.maintenance),
    const ParkingSlot(id: 'C1', status: SlotStatus.available),
    const ParkingSlot(id: 'C2', status: SlotStatus.available),
    const ParkingSlot(id: 'C3', status: SlotStatus.available),
    const ParkingSlot(
      id: 'C4',
      status: SlotStatus.occupied,
      vehicleNumber: 'KA 20 CD 5678',
      ownerName: 'Rahul',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final total = _slots.length;
    final available =
        _slots.where((s) => s.status == SlotStatus.available).length;
    final occupied =
        _slots.where((s) => s.status == SlotStatus.occupied).length;
    final reserved =
        _slots.where((s) => s.status == SlotStatus.reserved).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Smart Parking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatCardRow(cards: [
              StatCard(
                label: 'Total',
                value: '$total',
                accentColor: AppColors.primary,
                icon: Icons.local_parking_outlined,
              ),
              StatCard(
                label: 'Available',
                value: '$available',
                accentColor: AppColors.available,
                icon: Icons.check_circle_outline,
              ),
              StatCard(
                label: 'Occupied',
                value: '$occupied',
                accentColor: AppColors.occupied,
                icon: Icons.directions_car_filled_outlined,
              ),
              StatCard(
                label: 'Reserved',
                value: '$reserved',
                accentColor: AppColors.reserved,
                icon: Icons.bookmark_outline,
              ),
            ]),
            const SizedBox(height: AppSpacing.lg),
            Text('Parking Map', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            ParkingMapGrid(
              slots: _slots,
              onSlotTap: (slot) => showSlotDetailSheet(context, slot),
            ),
          ],
        ),
      ),
    );
  }
}
