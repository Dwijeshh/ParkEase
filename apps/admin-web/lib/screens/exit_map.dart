import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'exit_qr.dart';

class ExitMapScreen extends StatelessWidget {
  final ParkingAssignment assignment;
  final double amount;
  final DateTime entryTime;
  final DateTime exitTime;

  const ExitMapScreen({
    super.key,
    required this.assignment,
    required this.amount,
    required this.entryTime,
    required this.exitTime,
  });

  void _continueToQr(BuildContext context) {
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
        title: const Text('Navigate to Exit'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // TOP INFORMATION
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      color: AppColors.primary,
                      size: 30,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Route to Parking Exit',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'From Slot ${assignment.slot}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MAP
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEF3),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // PARKING FLOOR LABEL
                      const Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          'PARKING FLOOR 1',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                      ),

                      // PARKING AREA
                      Positioned(
                        top: 75,
                        left: 25,
                        right: 25,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Parking Area',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ROUTE
                      Positioned(
                        left: 70,
                        top: 165,
                        bottom: 115,
                        child: Container(
                          width: 6,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      // USER LOCATION
                      Positioned(
                        left: 38,
                        bottom: 80,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.15,
                                    ),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.directions_car_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Slot ${assignment.slot}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ARROW
                      Positioned(
                        left: 52,
                        top: 190,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.arrow_upward_rounded,
                              color: AppColors.primary,
                              size: 30,
                            ),
                            const SizedBox(height: 25),
                            const Icon(
                              Icons.arrow_upward_rounded,
                              color: AppColors.primary,
                              size: 30,
                            ),
                            const SizedBox(height: 25),
                            const Icon(
                              Icons.arrow_upward_rounded,
                              color: AppColors.primary,
                              size: 30,
                            ),
                          ],
                        ),
                      ),

                      // EXIT
                      Positioned(
                        top: 185,
                        right: 25,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.exit_to_app_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'EXIT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Parking Exit',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // DESTINATION PIN
                      Positioned(
                        right: 70,
                        top: 275,
                        child: Icon(
                          Icons.location_on_rounded,
                          color: AppColors.success,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ROUTE INFORMATION
              Row(
                children: [
                  const Icon(
                    Icons.route_rounded,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Follow the marked route to the exit',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // REACHED EXIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _continueToQr(context),
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                  ),
                  label: const Text(
                    "I've Reached the Exit - Scan QR",
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}