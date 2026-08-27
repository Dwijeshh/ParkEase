import 'package:flutter/material.dart';
import '../services/parking_service.dart';

class ParkingScreen extends StatefulWidget {
  const ParkingScreen({super.key});

  @override
  State<ParkingScreen> createState() => _ParkingScreenState();
}

class _ParkingScreenState extends State<ParkingScreen> {
  final ParkingService _parkingService = ParkingService();
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
      case 'ENGAGED':
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
    final total = slots.length;
    final occupied = slots.where((slot) => slot['status'] == 'Occupied').length;
    final available = slots.where((slot) => slot['status'] == 'Available').length;
    final reserved = slots.where((slot) => slot['status'] == 'Reserved').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Parking overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Real-time facility map and slot availability.',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _loadSlots,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // ── Stat Cards ───────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth >= 900
                  ? (constraints.maxWidth - 45) / 4
                  : constraints.maxWidth >= 600
                      ? (constraints.maxWidth - 15) / 2
                      : constraints.maxWidth;

              return Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  SizedBox(width: cardWidth, child: _summaryCard('$total', 'Total slots', Icons.grid_view_rounded)),
                  SizedBox(width: cardWidth, child: _summaryCard('$occupied', 'Occupied', Icons.directions_car_outlined)),
                  SizedBox(width: cardWidth, child: _summaryCard('$available', 'Available', Icons.check_circle_outline)),
                  SizedBox(width: cardWidth, child: _summaryCard('$reserved', 'Reserved', Icons.bookmark_border)),
                ],
              );
            },
          ),
          const SizedBox(height: 25),

          // ── Floor Plan State Image Container ─────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Live Parking State',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                    ),
                    const Spacer(),
                    // Legend
                    _legendItem(const Color(0xFF16A34A), 'Available'),
                    const SizedBox(width: 14),
                    _legendItem(const Color(0xFFEF4444), 'Occupied'),
                    const SizedBox(width: 14),
                    _legendItem(const Color(0xFFEAB308), 'Reserved'),
                  ],
                ),
                const SizedBox(height: 16),

                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (errorMessage != null)
                  Center(
                    child: Column(
                      children: [
                        Text(errorMessage!, style: const TextStyle(color: Color(0xFF6B7280))),
                        const SizedBox(height: 12),
                        ElevatedButton(onPressed: _loadSlots, child: const Text('Retry')),
                      ],
                    ),
                  )
                else
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: const Color(0xFFF9FAFB),
                      constraints: const BoxConstraints(maxHeight: 650),
                      child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 3.5,
                        child: Center(
                          child: Image.asset(
                            'parking_state.jpeg',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 380,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.broken_image_outlined, size: 48, color: Color(0xFF9CA3AF)),
                                  const SizedBox(height: 10),
                                  Text('parking_state.jpeg could not be loaded', style: TextStyle(color: Colors.grey.shade600)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                const Text(
                  'Tip: Scroll or pinch to zoom in/out on the facility state diagram.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280), fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _summaryCard(String value, String title, IconData icon) {
    return Container(
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
    );
  }
}
