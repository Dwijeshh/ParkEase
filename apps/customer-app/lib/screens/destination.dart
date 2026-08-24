import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'slot.dart';

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Destination')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Where are you headed?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF0D2A4A)),
              ),
              const SizedBox(height: 4),
              Text(
                "We'll direct you to the nearest entrance and parking slot",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: destinationOptions.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final option = destinationOptions[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).push(slideRoute(SlotScreen(assignment: option))),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(option.icon, color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(option.store, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                            ),
                            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
