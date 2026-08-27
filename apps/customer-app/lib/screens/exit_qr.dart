import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'payment.dart';

class ExitQrScreen extends StatefulWidget {
  final ParkingAssignment assignment;
  final double amount;
  final DateTime entryTime;
  final DateTime exitTime;

  const ExitQrScreen({
    super.key,
    required this.assignment,
    required this.amount,
    required this.entryTime,
    required this.exitTime,
  });

  @override
  State<ExitQrScreen> createState() => _ExitQrScreenState();
}

class _ExitQrScreenState extends State<ExitQrScreen> {
  bool _scanned = false;

  Future<void> _scanQr() async {
    if (_scanned) return;

    setState(() {
      _scanned = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    Navigator.of(context).push(
      slideRoute(
        PaymentScreen(
          assignment: widget.assignment,
          amount: widget.amount,
          entryTime: widget.entryTime,
          exitTime: widget.exitTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: Colors.white,
        title: const Text('Scan Exit QR'),
      ),

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),

            const Text(
              'Scan Exit QR Code',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Scan the QR code at the parking exit to continue to payment.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _scanQr,
                  child: Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _scanned
                            ? AppColors.success
                            : Colors.white70,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _scanned
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.success,
                              size: 80,
                            )
                          : const Icon(
                              Icons.qr_code_2_rounded,
                              color: Colors.white70,
                              size: 110,
                            ),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                _scanned
                    ? 'QR code verified'
                    : 'Tap the scanner area to simulate scanning',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
