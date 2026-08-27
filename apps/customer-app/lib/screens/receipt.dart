import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import 'payment.dart';
import 'login.dart';

class ReceiptScreen extends StatelessWidget {
  final ParkingAssignment assignment;
  final double amount;
  final PaymentMethod method;
  final DateTime entryTime;
  final DateTime exitTime;

  const ReceiptScreen({
    super.key,
    required this.assignment,
    required this.amount,
    required this.method,
    required this.entryTime,
    required this.exitTime,
  });

  String _fmt(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  String get _methodLabel => switch (method) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.upi => 'UPI',
        PaymentMethod.card => 'Card',
      };

  @override
  Widget build(BuildContext context) {
    final duration = exitTime.difference(entryTime);
    final durationLabel = '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 44),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text('Thank you for parking with ParkEase', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _Row(label: 'Slot', value: '${assignment.slot} · ${assignment.entrance}'),
                    _Row(label: 'Entry Time', value: _fmt(entryTime)),
                    _Row(label: 'Exit Time', value: _fmt(exitTime)),
                    _Row(label: 'Duration', value: durationLabel),
                    _Row(label: 'Payment Method', value: _methodLabel),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1)),
                    _Row(label: 'Amount Paid', value: '₹${amount.toStringAsFixed(2)}', bold: true),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  ),
                  child: const Text('Exit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _Row({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textMuted)),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: bold ? AppColors.primary : AppColors.textPrimary,
              fontSize: bold ? 17 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
