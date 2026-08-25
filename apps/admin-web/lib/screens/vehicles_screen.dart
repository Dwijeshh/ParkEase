import 'package:flutter/material.dart';

import '../services/vehicle_service.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final VehicleService _vehicleService = VehicleService();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> vehicles = [];
  bool isLoading = true;
  String? errorMessage;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => searchQuery = _searchController.text.trim().toLowerCase());
    });
    _loadVehicles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _vehicleService.getVehicles();
      final rawData = response is Map<String, dynamic> ? response['data'] : response;
      if (rawData is! List) {
        throw Exception('Invalid vehicles response');
      }

      final loadedVehicles = rawData.whereType<Map>().map<Map<String, String>>((item) {
        final status = _normaliseStatus(item['status'] ?? item['state']);
        return {
          'number': _value(item, ['number', 'registrationNumber', 'licensePlate', 'plateNumber']),
          'owner': _value(item, ['ownerName', 'owner', 'userName', 'userId', 'ownerId']),
          'type': _value(item, ['type', 'vehicleType']),
          'model': _value(item, ['model', 'vehicleModel']),
          'status': status,
        };
      }).toList();

      if (!mounted) return;
      setState(() {
        vehicles = loadedVehicles;
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

  String _value(Map item, List<String> keys) {
    for (final key in keys) {
      final value = item[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return '—';
  }

  String _normaliseStatus(dynamic rawStatus) {
    final value = rawStatus?.toString().toLowerCase() ?? '';
    if (value.contains('park')) return 'Parked';
    return 'Outside';
  }

  @override
  Widget build(BuildContext context) {
    final filteredVehicles = vehicles.where((vehicle) {
      final text = '${vehicle['number']} ${vehicle['owner']}'.toLowerCase();
      return searchQuery.isEmpty || text.contains(searchQuery);
    }).toList();
    final parked = vehicles.where((vehicle) => vehicle['status'] == 'Parked').length;
    final outside = vehicles.length - parked;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vehicles', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          const Text('View vehicles registered with the parking facility.', style: TextStyle(color: Color(0xFF6B7280), fontSize: 14)),
          const SizedBox(height: 25),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth >= 900
                  ? (constraints.maxWidth - 30) / 3
                  : constraints.maxWidth >= 600
                      ? (constraints.maxWidth - 15) / 2
                      : constraints.maxWidth;
              return Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  SizedBox(width: width, child: _stat('${vehicles.length}', 'Registered vehicles')),
                  SizedBox(width: width, child: _stat('$parked', 'Currently parked')),
                  SizedBox(width: width, child: _stat('$outside', 'Outside facility')),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by vehicle number or owner...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: searchQuery.isEmpty ? null : IconButton(onPressed: _searchController.clear, icon: const Icon(Icons.clear)),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const Divider(height: 1),
                if (isLoading)
                  const Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())
                else if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(children: [Text(errorMessage!), const SizedBox(height: 12), ElevatedButton(onPressed: _loadVehicles, child: const Text('Retry'))]),
                  )
                else if (filteredVehicles.isEmpty)
                  const Padding(padding: EdgeInsets.all(32), child: Text('No vehicles found.'))
                else
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: 700,
                      child: Column(children: [_header(), ...filteredVehicles.map(_vehicleRow)]),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String title) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
        const SizedBox(height: 3),
        Text(title, style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 11)),
      ]),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
      color: const Color(0xFFF9FAFB),
      child: const Row(children: [
        Expanded(flex: 2, child: Text('VEHICLE')),
        Expanded(flex: 2, child: Text('OWNER')),
        Expanded(child: Text('TYPE')),
        Expanded(flex: 2, child: Text('MODEL')),
        SizedBox(width: 75, child: Text('STATUS')),
      ]),
    );
  }

  Widget _vehicleRow(Map<String, String> vehicle) {
    final parked = vehicle['status'] == 'Parked';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0)))),
      child: Row(children: [
        Expanded(flex: 2, child: Row(children: [
          const Icon(Icons.directions_car_outlined, size: 20, color: Color(0xFF6B7280)),
          const SizedBox(width: 10),
          Text(vehicle['number']!, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ])),
        Expanded(flex: 2, child: Text(vehicle['owner']!, style: const TextStyle(fontSize: 12))),
        Expanded(child: Text(vehicle['type']!, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12))),
        Expanded(flex: 2, child: Text(vehicle['model']!, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12))),
        SizedBox(width: 75, child: Text(vehicle['status']!, style: TextStyle(color: parked ? const Color(0xFF16A34A) : const Color(0xFF6B7280), fontSize: 11, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
