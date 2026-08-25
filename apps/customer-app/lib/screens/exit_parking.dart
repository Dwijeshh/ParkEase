import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'exit_map.dart';
import 'exit_qr.dart';

class ExitParkingScreen extends StatelessWidget {
  final ParkingAssignment assignment;
  final double amount;
  final DateTime entryTime;
  final DateTime exitTime;

  const ExitParkingScreen({
    super.key,
    required this.assignment,
    required this.amount,
    required this.entryTime,
    required this.exitTime,
  });

  // User needs directions to the exit
  void _guideToExit(BuildContext context) {
    Navigator.of(context).push(
      slideRoute(
        ExitMapScreen(
          assignment: assignment,
          amount: amount,
          entryTime: entryTime,
          exitTime: exitTime,
        ),
      ),
    );
  }

  // User already knows the exit
  void _goDirectlyToQr(BuildContext context) {
    Navigator.of(context).push(
      slideRoute(
        ExitQrScreen(
          assignment: assignment,
          amount: amount,
          entryTime: entryTime,
          exitTime: exitTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exit Parking'),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),

              const Text(
                'Ready to leave?',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D2A4A),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'How would you like to reach the parking exit?',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 32),

              // --------------------------------------------------
              // OPTION 1: GUIDE ME TO EXIT
              // --------------------------------------------------

              InkWell(
                onTap: () => _guideToExit(context),

                borderRadius: BorderRadius.circular(20),

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(20),

                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.04,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 56,
                        height: 56,

                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),

                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child: const Icon(
                          Icons.map_outlined,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Text
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              'Guide Me to Exit',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0D2A4A),
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Show me the route from my parking slot to the exit.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.grey.shade400,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // --------------------------------------------------
              // OPTION 2: I KNOW THE EXIT
              // --------------------------------------------------

              InkWell(
                onTap: () => _goDirectlyToQr(context),

                borderRadius: BorderRadius.circular(20),

                child: Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: AppColors.primary,

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: 0.2,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      // Icon
                      Container(
                        width: 56,
                        height: 56,

                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.15,
                          ),

                          borderRadius:
                              BorderRadius.circular(16),
                        ),

                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Text
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Text(
                              'I Know the Exit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              'Go directly to the exit and scan the QR code.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white70,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // --------------------------------------------------
              // PAYMENT INFO
              // --------------------------------------------------

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Row(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.grey.shade600,
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Current parking fee',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            '₹${amount.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D2A4A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}