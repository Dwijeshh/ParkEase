import 'package:flutter/material.dart';
import '../models.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'slot.dart';

class DestinationScreen extends StatelessWidget {
  final LotInfo lotInfo;

  const DestinationScreen({super.key, required this.lotInfo});

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
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                "We'll direct you to the nearest entrance and parking slot",
                style: TextStyle(color: AppColors.textMuted),
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
                      onTap: () => Navigator.of(context).push(slideRoute(SlotScreen(assignment: option, lotInfo: lotInfo))),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(option.icon, color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                option.store,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textPrimary),
                              ),
                            ),
                            Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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
