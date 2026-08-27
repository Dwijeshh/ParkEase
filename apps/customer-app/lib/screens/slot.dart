import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import '../widgets/facility_map.dart';
import '../widgets/popup.dart';
import 'homepage.dart';

class SlotScreen extends StatefulWidget {
  final ParkingAssignment assignment;
  final LotInfo lotInfo;

  const SlotScreen({super.key, required this.assignment, required this.lotInfo});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  late ParkingAssignment _assignment = widget.assignment;

  @override
  void initState() {
    super.initState();
    _startConfirmation();
  }

  ParkingAssignment _nextAssignment(ParkingAssignment current) {
    final index = destinationOptions.indexWhere((o) => o.slot == current.slot);
    return destinationOptions[(index + 1) % destinationOptions.length];
  }

  Future<void> _startConfirmation() async {
    // Simulates the backend CV camera detecting a car at the assigned slot.
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final confirmed = await showParkHereDialog(context, slotId: _assignment.slot);
    if (!mounted) return;

    if (confirmed == true) {
      final entryTime = DateTime.now();
      Navigator.of(context).pushReplacement(slideRoute(ParkEaseHomeScreen(
        assignment: _assignment,
        lotInfo: widget.lotInfo,
        entryTime: entryTime,
      )));
    } else {
      setState(() => _assignment = _nextAssignment(_assignment));
      _startConfirmation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignment = _assignment;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Slot Assigned',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Nearest to ${assignment.store}',
                style: const TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.local_parking_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Slot ${assignment.slot}',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _InfoChip(icon: Icons.meeting_room_outlined, label: assignment.entrance),
                    const SizedBox(height: 10),
                    const _InfoChip(icon: Icons.apartment_outlined, label: 'Floor 1'),
                    const SizedBox(height: 10),
                    _InfoChip(icon: Icons.location_on_outlined, label: '${widget.lotInfo.mallName}, ${widget.lotInfo.city}'),
                    const SizedBox(height: 10),
                    _InfoChip(icon: Icons.event_seat_outlined, label: '${widget.lotInfo.capacity} slot capacity'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Route to your slot',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade300),
              ),
              const SizedBox(height: 12),
              FacilityMap(assignment: assignment),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Verifying your vehicle at this slot…',
                      style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Rate', style: TextStyle(color: AppColors.textMuted)),
                    Text(
                      '₹${widget.lotInfo.ratePerHour.toStringAsFixed(2)} / hour',
                      style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
