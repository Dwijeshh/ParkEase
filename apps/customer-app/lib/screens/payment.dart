import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'receipt.dart';

enum PaymentMethod { cash, upi, card }

class PaymentScreen extends StatefulWidget {
  final ParkingAssignment assignment;
  final double amount;
  final DateTime entryTime;
  final DateTime exitTime;

  const PaymentScreen({
    super.key,
    required this.assignment,
    required this.amount,
    required this.entryTime,
    required this.exitTime,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod? _method;
  bool _loading = false;

  Future<void> _confirm() async {
    if (_method == null) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context).push(slideRoute(ReceiptScreen(
      assignment: widget.assignment,
      amount: widget.amount,
      method: _method!,
      entryTime: widget.entryTime,
      exitTime: widget.exitTime,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Amount', style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 6),
              Text(
                '₹${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800, color: Color(0xFF0D2A4A)),
              ),
              const SizedBox(height: 32),
              Text('Choose payment method', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700)),
              const SizedBox(height: 12),
              _MethodTile(
                icon: Icons.payments_outlined,
                label: 'Cash',
                selected: _method == PaymentMethod.cash,
                onTap: () => setState(() => _method = PaymentMethod.cash),
              ),
              const SizedBox(height: 12),
              _MethodTile(
                icon: Icons.qr_code_2_rounded,
                label: 'UPI',
                selected: _method == PaymentMethod.upi,
                onTap: () => setState(() => _method = PaymentMethod.upi),
              ),
              const SizedBox(height: 12),
              _MethodTile(
                icon: Icons.credit_card_rounded,
                label: 'Card',
                selected: _method == PaymentMethod.card,
                onTap: () => setState(() => _method = PaymentMethod.card),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_method == null || _loading) ? null : _confirm,
                  child: _loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                        )
                      : const Text('Confirm Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.primary : Colors.grey.shade200, width: selected ? 1.6 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : Colors.grey.shade600),
            const SizedBox(width: 14),
            Text(label, style: TextStyle(fontWeight: FontWeight.w600, color: selected ? AppColors.primary : Colors.black87)),
            const Spacer(),
            Icon(
              selected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: selected ? AppColors.primary : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
