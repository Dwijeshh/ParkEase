import 'package:flutter/material.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> slots = [
    {'id': 'A-101', 'status': 'Occupied', 'vehicle': 'KA 20 AB 1234'},
    {'id': 'A-102', 'status': 'Available', 'vehicle': ''},
    {'id': 'A-103', 'status': 'Available', 'vehicle': ''},
    {'id': 'A-104', 'status': 'Occupied', 'vehicle': 'KA 19 CD 4821'},
    {'id': 'A-105', 'status': 'Reserved', 'vehicle': ''},
    {'id': 'A-106', 'status': 'Occupied', 'vehicle': 'KA 05 EF 9210'},
    {'id': 'A-107', 'status': 'Available', 'vehicle': ''},
    {'id': 'A-108', 'status': 'Available', 'vehicle': ''},
    {'id': 'A-109', 'status': 'Occupied', 'vehicle': 'KA 20 GH 7712'},
    {'id': 'A-110', 'status': 'Available', 'vehicle': ''},
    {'id': 'B-101', 'status': 'Available', 'vehicle': ''},
    {'id': 'B-102', 'status': 'Occupied', 'vehicle': 'KA 18 XY 4421'},
    {'id': 'B-103', 'status': 'Reserved', 'vehicle': ''},
    {'id': 'B-104', 'status': 'Available', 'vehicle': ''},
    {'id': 'B-105', 'status': 'Occupied', 'vehicle': 'KA 04 LM 8120'},
    {'id': 'B-106', 'status': 'Available', 'vehicle': ''},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredSlots = selectedFilter == 'All'
        ? slots
        : slots
            .where((slot) => slot['status'] == selectedFilter)
            .toList();

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
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              _summaryCard(
                '240',
                'Total slots',
                Icons.grid_view_rounded,
              ),
              const SizedBox(width: 15),
              _summaryCard(
                '168',
                'Occupied',
                Icons.directions_car_outlined,
              ),
              const SizedBox(width: 15),
              _summaryCard(
                '72',
                'Available',
                Icons.check_circle_outline,
              ),
              const SizedBox(width: 15),
              _summaryCard(
                '8',
                'Reserved',
                Icons.bookmark_border,
              ),
            ],
          ),

          const SizedBox(height: 25),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Parking slots',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),

                    const Spacer(),

                    ...['All', 'Available', 'Occupied', 'Reserved'].map(
                      (filter) => Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: selectedFilter == filter,
                          onSelected: (_) {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
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

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 170,
                    mainAxisExtent: 105,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredSlots.length,
                  itemBuilder: (context, index) {
                    final slot = filteredSlots[index];

                    return _slotCard(slot);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(
    String value,
    String title,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF16A34A),
              size: 23,
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
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
          border: Border.all(
            color: iconColor.withValues(alpha: 0.15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_parking_rounded,
                  color: iconColor,
                  size: 20,
                ),

                const Spacer(),

                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: iconColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const Spacer(),

            Text(
              slot['id'],
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              slot['status'],
              style: TextStyle(
                color: iconColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlotDetails(Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
        );
      },
    );
  }
}