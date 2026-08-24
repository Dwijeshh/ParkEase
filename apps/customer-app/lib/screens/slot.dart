import 'dart:async';
import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import '../widgets/facility_map.dart';
import 'payment.dart';

const _ratePerHour = 20.0;

class SlotScreen extends StatefulWidget {
  final ParkingAssignment assignment;

  const SlotScreen({super.key, required this.assignment});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  late final DateTime _entryTime = DateTime.now();
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Billing starts the instant the slot is assigned, not on arrival.
    // Demo acceleration: 1 real second = 1 simulated minute, so the fee
    // visibly climbs during a short live demo instead of over a real hour.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsed += const Duration(minutes: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  double get _fee => (_elapsed.inMinutes / 60) * _ratePerHour;

  @override
  Widget build(BuildContext context) {
    final assignment = widget.assignment;
    final h = _elapsed.inHours.toString().padLeft(2, '0');
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Slot Assigned',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Color(0xFF0D2A4A)),
              ),
              const SizedBox(height: 4),
              Text('Nearest to ${assignment.store}', style: TextStyle(color: Colors.grey.shade600)),
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
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Route to your slot',
                style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              FacilityMap(assignment: assignment),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, color: AppColors.success, size: 8),
                    const SizedBox(width: 8),
                    Text('Slot ${assignment.slot} · In Progress', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text('Time Elapsed', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 6),
              Text(
                '$h:$m',
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800, color: Color(0xFF0D2A4A)),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Rate', style: TextStyle(color: Colors.grey.shade600)),
                        const Text('₹20 / hour'),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider(height: 1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Fee', style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          '₹${_fee.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    Navigator.of(context).push(slideRoute(PaymentScreen(
                      assignment: assignment,
                      amount: _fee,
                      entryTime: _entryTime,
                      exitTime: DateTime.now(),
                    )));
                  },
                  child: const Text('End Session & Pay'),
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
