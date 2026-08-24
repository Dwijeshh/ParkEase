import 'package:flutter/material.dart';
import '../theme/app_colours.dart';
import '../theme/app_theme.dart';

/// A single dashboard summary tile, e.g. TOTAL / AVAILABLE / OCCUPIED / RESERVED.
///
/// Usage:
/// ```dart
/// StatCard(label: 'AVAILABLE', value: '42', accentColor: AppColors.available)
/// ```
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.accentColor = AppColors.primary,
    this.icon,
  });

  final String label;
  final String value;
  final Color accentColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const Spacer(),
                if (icon != null)
                  Icon(icon, size: 18, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// A responsive row/wrap of [StatCard]s for the dashboard header.
/// Wraps to multiple lines automatically on narrow screens.
class StatCardRow extends StatelessWidget {
  const StatCardRow({super.key, required this.cards});

  final List<StatCard> cards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 4 across on wide screens, 2 across on narrow ones.
        final columns = constraints.maxWidth > 720 ? cards.length : 2;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: cards.map((card) {
            final width =
                (constraints.maxWidth - (columns - 1) * AppSpacing.md) /
                    columns;
            return SizedBox(width: width, child: card);
          }).toList(),
        );
      },
    );
  }
}
