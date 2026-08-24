import 'package:flutter/material.dart';
import 'parking_slot.dart';
import '../theme/app_colours.dart';
import '../theme/app_theme.dart';

/// Call this to show slot details, matching the mockup:
/// "Slot A03 — Status / Vehicle / User / Since".
///
/// Usage:
/// ```dart
/// onSlotTap: (slot) => showSlotDetailSheet(context, slot),
/// ```
Future<void> showSlotDetailSheet(BuildContext context, ParkingSlot slot) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (context) => SlotDetailSheet(slot: slot),
  );
}

class SlotDetailSheet extends StatelessWidget {
  const SlotDetailSheet({super.key, required this.slot});
  final ParkingSlot slot;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.forStatus(slot.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Text('Slot ${slot.id}',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(width: AppSpacing.sm),
              Chip(
                label: Text(slot.status.label),
                labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
                backgroundColor: AppColors.softForStatus(slot.status),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(label: 'Vehicle', value: slot.vehicleNumber ?? '—'),
          _DetailRow(label: 'User', value: slot.ownerName ?? '—'),
          _DetailRow(
            label: 'Since',
            value: slot.since != null
                ? '${slot.since!.hour.toString().padLeft(2, '0')}:${slot.since!.minute.toString().padLeft(2, '0')}'
                : '—',
          ),
          if (slot.distanceFromEntranceMeters != null)
            _DetailRow(
              label: 'Distance from entrance',
              value: '${slot.distanceFromEntranceMeters!.toStringAsFixed(0)}m',
            ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
