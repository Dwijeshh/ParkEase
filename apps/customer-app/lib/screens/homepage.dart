import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'exit_parking.dart';

/// ParkEase — customer app home screen. Shown once a slot has been
/// confirmed; the user's whole active session lives here until they exit.
class ParkEaseHomeScreen extends StatelessWidget {
  final ParkingAssignment assignment;
  final LotInfo lotInfo;
  final DateTime entryTime;

  const ParkEaseHomeScreen({
    super.key,
    required this.assignment,
    required this.lotInfo,
    required this.entryTime,
  });

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  void _exitParking(BuildContext context) {
    final exitTime = DateTime.now();
    // Demo acceleration: 1 real second elapsed == 1 simulated minute billed.
    final simulatedMinutes = exitTime.difference(entryTime).inSeconds;
    final fee = (simulatedMinutes / 60) * lotInfo.ratePerHour;

    Navigator.of(context).push(slideRoute(ExitParkingScreen(
      assignment: assignment,
      amount: fee,
      entryTime: entryTime,
      exitTime: exitTime,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.accent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_parking_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ParkEase',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.2,
                        ),
                      ),
                      Text(
                        'Welcome back',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.circle, color: Colors.greenAccent, size: 10),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'You\'re parked',
                          style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Slot ${assignment.slot}',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lotInfo.mallName}, ${lotInfo.city} · ${assignment.entrance}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Icon(Icons.schedule_rounded, color: Colors.white70, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Since ${_fmt(entryTime)} · ₹${lotInfo.ratePerHour.toStringAsFixed(2)}/hr',
                          style: const TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _exitParking(context),
                  icon: const Icon(Icons.exit_to_app_rounded),
                  label: const Text('Exit Parking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
