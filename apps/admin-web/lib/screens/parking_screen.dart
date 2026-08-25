import 'package:flutter/material.dart';

import '../services/parking_service.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final ParkingService _parkingService = ParkingService();
  String selectedFilter = 'All';
  List<Map<String, dynamic>> slots = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _parkingService.getParkingSlots();
      final data = response is Map<String, dynamic>
          ? response['data']
          : null;

      if (data is! List) {
        throw Exception('Invalid parking slots response');
      }

      final loadedSlots = data
          .whereType<Map>()
          .map<Map<String, dynamic>>((slot) {
            final rawStatus = slot['status']?.toString() ?? 'AVAILABLE';
            return {
              'id': slot['code']?.toString() ?? slot['id'].toString(),
              'status': _displayStatus(rawStatus),
              'vehicle': '',
            };
          })
          .toList();

      if (!mounted) return;
      setState(() {
        slots = loadedSlots;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    }
  }

  String _displayStatus(String status) {
    switch (status.toUpperCase()) {
      case 'OCCUPIED':
        return 'Occupied';
      case 'RESERVED':
        return 'Reserved';
      case 'MAINTENANCE':
        return 'Maintenance';
      default:
        return 'Available';
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredSlots = selectedFilter == 'All'
        ? slots
        : slots.where((slot) => slot['status'] == selectedFilter).toList();

    final total = slots.length;
    final occupied = slots.where((slot) => slot['status'] == 'Occupied').length;
    final available = slots.where((slot) => slot['status'] == 'Available').length;
    final reserved = slots.where((slot) => slot['status'] == 'Reserved').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Parking overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Monitor and manage parking slots across the facility.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              _summaryCard('$total', 'Total slots', Icons.grid_view_rounded),
              const SizedBox(width: 15),
              _summaryCard('$occupied', 'Occupied', Icons.directions_car_outlined),
              const SizedBox(width: 15),
              _summaryCard('$available', 'Available', Icons.check_circle_outline),
              const SizedBox(width: 15),
              _summaryCard('$reserved', 'Reserved', Icons.bookmark_border),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Parking slots',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const Spacer(),
                    ...['All', 'Available', 'Occupied', 'Reserved'].map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (_) => setState(() => selectedFilter = filter),
                          selectedColor: const Color(0xFFDCFCE7),
                          labelStyle: TextStyle(
                            color: selectedFilter == filter
                                ? const Color(0xFF15803D)
                                : const Color(0xFF6B7280),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  )
                else if (errorMessage != null)
                  Column(
                    children: [
                      Text(errorMessage!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _loadSlots,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                else if (filteredSlots.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No parking slots found.'),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 170,
                      mainAxisExtent: 105,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredSlots.length,
                    itemBuilder: (context, index) => _slotCard(filteredSlots[index]),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String value, String title, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF16A34A), size: 23),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text(title, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotCard(Map<String, dynamic> slot) {
    Color background;
    Color iconColor;

    switch (slot['status']) {
      case 'Occupied':
        background = const Color(0xFFFFF7ED);
        iconColor = const Color(0xFFF97316);
        break;
      case 'Reserved':
        background = const Color(0xFFF5F3FF);
        iconColor = const Color(0xFF7C3AED);
        break;
      case 'Maintenance':
        background = const Color(0xFFF3F4F6);
        iconColor = const Color(0xFF6B7280);
        break;
      default:
        background = const Color(0xFFF0FDF4);
        iconColor = const Color(0xFF16A34A);
    }

    return InkWell(
      onTap: () => _showSlotDetails(slot),
      borderRadius: BorderRadius.circular(11),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: iconColor.withValues(alpha: 0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_parking_rounded, color: iconColor, size: 20),
                const Spacer(),
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                ),
              ],
            ),
            const Spacer(),
            Text(slot['id'].toString(), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 3),
            Text(slot['status'].toString(), style: TextStyle(color: iconColor, fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showSlotDetails(Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Slot ${slot['id']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${slot['status']}'),
            if (slot['vehicle'].toString().isNotEmpty)
              Text('Vehicle: ${slot['vehicle']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
