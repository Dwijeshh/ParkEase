import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'destination.dart';

class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _scanController;
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      _scanController.stop();
      setState(() => _scanned = true);
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      Navigator.of(context).push(slideRoute(const DestinationScreen()));
    });
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
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
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _scanned ? AppColors.success : Colors.white70,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      if (!_scanned)
                        AnimatedBuilder(
                          animation: _scanController,
                          builder: (context, child) {
                            return Align(
                              alignment: Alignment(0, -1 + 2 * _scanController.value),
                              child: Container(
                                width: 220,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  boxShadow: [
                                    BoxShadow(color: AppColors.accent.withValues(alpha: 0.8), blurRadius: 8),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      if (_scanned)
                        const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 72),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Text(
                _scanned ? 'QR code verified' : 'Position the QR code within the frame',
                style: TextStyle(color: Colors.grey.shade300, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
