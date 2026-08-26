import 'package:flutter/material.dart';

/// Standalone Yes/No confirmation dialog: "Park your vehicle here?"
/// No external theme/color file needed — everything is self-contained.
///
/// Usage:
/// ```dart
/// final confirmed = await showParkHereDialog(context, slotId: 'A03');
/// if (confirmed == true) {
///   // proceed with booking the slot
/// }
/// ```
Future<bool?> showParkHereDialog(
  BuildContext context, {
  String? slotId,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ParkHereDialog(slotId: slotId),
  );
}

class ParkHereDialog extends StatelessWidget {
  const ParkHereDialog({super.key, this.slotId});
  final String? slotId;

  static const _primary = Color(0xFF2F6FED);
  static const _primarySoft = Color(0xFFEAF1FE);
  static const _textSecondary = Color(0xFF6B7280);
  static const _border = Color(0xFFE3E5E9);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: _primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_parking_rounded,
                color: _primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Park your vehicle here?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            if (slotId != null) ...[
              const SizedBox(height: 6),
              Text(
                'Slot $slotId will be reserved for you.',
                style: const TextStyle(fontSize: 14, color: _textSecondary),
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _textSecondary,
                      side: const BorderSide(color: _border),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
