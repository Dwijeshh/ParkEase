import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'destination.dart';

/// Demo QR payload for this entry gate: (id, mallName, city, capacity, ratePerHour).
const _demoLotQr = "(1, 'Mall1', 'Udupi', 100, 20)";

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _scanned = false;

  Future<void> _scanQr() async {
    if (_scanned) return;

    final lotInfo = LotInfo.parse(_demoLotQr);

    setState(() => _scanned = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    Navigator.of(context).push(slideRoute(DestinationScreen(lotInfo: lotInfo)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Text(
              'Scan Entry QR Code',
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'Main Entry Gate',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _scanQr,
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _scanned ? AppColors.success : Colors.white70,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: _scanned
                          ? const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72)
                          : const Icon(Icons.qr_code_2_rounded, color: Colors.white70, size: 100),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Text(
                _scanned ? 'QR code verified' : 'Tap the scanner area to simulate scanning',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
