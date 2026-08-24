import 'package:flutter/material.dart';
import '../theme/app_colours.dart';

/// A single slot in the parking map/grid — the 🟢/🔴/🟠/⚪ squares
/// from the mockup, rendered as a real widget.
class SlotTile extends StatelessWidget {
  const SlotTile({
    super.key,
    required this.slotId,
    required this.status,
    this.onTap,
    this.compact = false,
  });

  final String slotId;
  final SlotStatus status;
  final VoidCallback? onTap;

  /// Compact mode shows just the color dot (for dense maps);
  /// non-compact shows the slot label too.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forStatus(status);
    final soft = AppColors.softForStatus(status);

    return Tooltip(
      message: '$slotId · ${status.label}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: compact ? 36 : 56,
          height: compact ? 36 : 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: soft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: compact
              ? Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slotId,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Small legend explaining the status colors — drop this above/below
/// any SlotGrid so admins always know what the colors mean.
class SlotStatusLegend extends StatelessWidget {
  const SlotStatusLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: SlotStatus.values.map((status) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.forStatus(status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              status.label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        );
      }).toList(),
    );
  }
}