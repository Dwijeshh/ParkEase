import 'package:flutter/material.dart';

import '../services/report_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportService _reportService = ReportService();

  bool _isLoading = true;
  String? _error;
  Map<String, dynamic> _summary = {};

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  Future<void> _loadReport() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await _reportService.getSummary();
      Map<String, dynamic> data = {};
      if (response is Map<String, dynamic>) {
        data = response['data'] is Map
            ? Map<String, dynamic>.from(response['data'])
            : Map<String, dynamic>.from(response);
      }
      if (!mounted) return;
      setState(() {
        _summary = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalVeh = _summary['totalVehicles']?.toString() ?? '-';
    final occupancyRaw = _summary['occupancy'];
    final occupancy = occupancyRaw != null
        ? '${double.tryParse(occupancyRaw.toString())?.toStringAsFixed(1) ?? occupancyRaw}%'
        : '-';
    final revenueRaw = _summary['revenue'];
    final revenue = revenueRaw != null
        ? '₹${double.tryParse(revenueRaw.toString())?.toStringAsFixed(0) ?? revenueRaw}'
        : '-';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reports',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'View parking activity and facility performance.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_error != null)
            Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Color(0xFF9CA3AF), size: 40),
                  const SizedBox(height: 10),
                  Text('Could not load report data', style: const TextStyle(color: Color(0xFF6B7280))),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _loadReport, child: const Text('Retry')),
                ],
              ),
            )
          else ...[
            Row(
              children: [
                _reportCard(totalVeh, 'Vehicles registered', Icons.directions_car_outlined),
                const SizedBox(width: 15),
                _reportCard(occupancy, 'Current occupancy', Icons.pie_chart_outline),
                const SizedBox(width: 15),
                _reportCard(revenue, 'Total revenue', Icons.currency_rupee),
              ],
            ),

            const SizedBox(height: 25),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _slotBreakdown(),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _quickReports(),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _downloadSection(),
          ],
        ],
      ),
    );
  }

  Widget _reportCard(String value, String title, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 43,
              height: 43,
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF16A34A), size: 21),
            ),
            const SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20)),
                Text(title, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _slotBreakdown() {
    final total    = _toInt(_summary['totalSlots']);
    final occupied = _toInt(_summary['occupiedSlots']);
    final avail    = _toInt(_summary['availableSlots']);
    final reserved = _toInt(_summary['reservedSlots']);

    final items = [
      _BreakdownItem('Occupied',  occupied,  const Color(0xFFF97316), const Color(0xFFFFF7ED)),
      _BreakdownItem('Available', avail,     const Color(0xFF16A34A), const Color(0xFFF0FDF4)),
      _BreakdownItem('Reserved',  reserved,  const Color(0xFF7C3AED), const Color(0xFFF5F3FF)),
    ];

    return Container(
      height: 350,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Slot breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Total capacity: $total slots', style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12)),
          const SizedBox(height: 25),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                final fraction = total > 0 ? item.count / total : 0.0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(fraction * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280)),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: fraction.clamp(0.02, 1.0),
                              widthFactor: 0.7,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: item.color,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(item.label, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
                        Text(item.count.toString(), style: TextStyle(fontSize: 11, color: item.color, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickReports() {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick reports',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 18),

          _reportOption(
            'Daily activity',
            'Parking activity for today',
            Icons.today_outlined,
          ),

          _reportOption(
            'Vehicle report',
            'Registered vehicle details',
            Icons.directions_car_outlined,
          ),

          _reportOption(
            'Revenue report',
            'Daily and monthly revenue',
            Icons.currency_rupee,
          ),

          _reportOption(
            'Occupancy report',
            'Slot utilization statistics',
            Icons.bar_chart_outlined,
          ),
        ],
      ),
    );
  }

  Widget _reportOption(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF4B5563)),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
              ],
            ),
          ),

          const Icon(Icons.chevron_right, size: 18, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }

  Widget _downloadSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            color: Color(0xFF6B7280),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Generate a detailed report',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                ),
                SizedBox(height: 3),
                Text(
                  'Export parking data for a selected date range.',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 11),
                ),
              ],
            ),
          ),

          OutlinedButton(
            onPressed: () {},
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    return int.tryParse(v.toString()) ?? 0;
  }
}

class _BreakdownItem {
  final String label;
  final int count;
  final Color color;
  final Color background;
  const _BreakdownItem(this.label, this.count, this.color, this.background);
}