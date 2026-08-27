import 'package:flutter/material.dart';
import '../theme.dart';

class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const BrandHeader({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_parking_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              'ParkEase',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.accent),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Text(
          title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
          ),
        ],
      ],
    );
  }
}
