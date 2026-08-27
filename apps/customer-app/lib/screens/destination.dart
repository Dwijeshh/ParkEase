import 'package:flutter/material.dart';
import '../models.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../utils/page_transition.dart';
import 'slot.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({super.key});

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  int? _loadingIndex;
  String? _error;

  Future<void> _selectDestination(int index, MallDestination dest) async {
    setState(() {
      _loadingIndex = index;
      _error        = null;
    });

    try {
      // Get user's vehicle type from stored session/vehicle info
      final vehicleType = 'Car'; // default; could be read from storage

      final slotData = await CustomerApiService.getNearestSlot(
        dest.mallEntranceId,
        vehicleType,
      );

      if (!mounted) return;

      if (slotData == null) {
        setState(() {
          _loadingIndex = null;
          _error        = 'No available slots near ${dest.store}. Try another entrance.';
        });
        return;
      }

      final rawNodeId = slotData['parkingNodeId'] ?? slotData['parking_node_id'];
      final parkingNodeId = rawNodeId != null ? int.tryParse(rawNodeId.toString()) ?? 0 : 0;

      final assignment = ParkingAssignment(
        store:          dest.store,
        entrance:       dest.entrance,
        slot:           slotData['slotNumber']?.toString() ?? slotData['slot_number']?.toString() ?? '-',
        icon:           dest.icon,
        mallEntranceId: dest.mallEntranceId,
        slotId:         slotData['slotId']?.toString() ?? slotData['slot_id']?.toString() ?? '',
        parkingNodeId:  parkingNodeId,
      );

      Navigator.of(context).push(slideRoute(SlotScreen(assignment: assignment)));
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Failed to find a slot. Please try again.');
    } finally {
      if (mounted) setState(() => _loadingIndex = null);
    }
  }

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
                "We'll find the nearest available parking slot",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: AppColors.danger, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Expanded(
                child: ListView.separated(
                  itemCount: mallDestinations.length,
                  separatorBuilder: (context, i) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final dest = mallDestinations[i];
                    final isLoading = _loadingIndex == i;
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _loadingIndex != null ? null : () => _selectDestination(i, dest),
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
                              child: Icon(dest.icon, color: AppColors.primary),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(dest.store, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  Text(dest.entrance, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                                ],
                              ),
                            ),
                            if (isLoading)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            else
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
