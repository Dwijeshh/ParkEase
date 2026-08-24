import 'package:flutter/material.dart';
import 'parking_slot.dart';
import '../theme/app_theme.dart';
import 'slot_tile.dart';

/// Renders a full parking map/grid from a list of [ParkingSlot]s,
/// matching the "ENTRANCE ... EXIT" mockup layout.
///
/// Usage:
/// ```dart
/// ParkingMapGrid(
///   slots: mySlots,
///   onSlotTap: (slot) => showSlotDetail(context, slot),
/// )
/// ```
class ParkingMapGrid extends StatelessWidget {
  const ParkingMapGrid({
    super.key,
    required this.slots,
    this.onSlotTap,
    this.crossAxisCount = 6,
    this.showEntranceExitLabels = true,
    this.compactTiles = false,
  });

  final List<ParkingSlot> slots;
  final ValueChanged<ParkingSlot>? onSlotTap;
  final int crossAxisCount;
  final bool showEntranceExitLabels;
  final bool compactTiles;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showEntranceExitLabels) ...[
              const _SectionLabel('ENTRANCE ↓'),
              const SizedBox(height: AppSpacing.sm),
            ],
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: slots.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
              ),
              itemBuilder: (context, index) {
                final slot = slots[index];
                return SlotTile(
                  slotId: slot.id,
                  status: slot.status,
                  compact: compactTiles,
                  onTap: onSlotTap == null ? null : () => onSlotTap!(slot),
                );
              },
            ),
            if (showEntranceExitLabels) ...[
              const SizedBox(height: AppSpacing.sm),
              const _SectionLabel('EXIT →', alignEnd: true),
            ],
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.sm),
            const SlotStatusLegend(),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text, {this.alignEnd = false});
  final String text;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}
