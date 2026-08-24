import 'package:flutter/material.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

  final List<Map<String, String>> vehicles = const [
    {
      'number': 'KA 20 AB 1234',
      'owner': 'Rahul Shetty',
      'type': 'Car',
      'model': 'Hyundai i20',
      'status': 'Parked',
    },
    {
      'number': 'KA 19 CD 4821',
      'owner': 'Ananya Rao',
      'type': 'Car',
      'model': 'Honda City',
      'status': 'Parked',
    },
    {
      'number': 'KA 05 EF 9210',
      'owner': 'Karthik Pai',
      'type': 'SUV',
      'model': 'Kia Seltos',
      'status': 'Outside',
    },
    {
      'number': 'KA 20 GH 7712',
      'owner': 'Meera Nair',
      'type': 'Car',
      'model': 'Tata Nexon',
      'status': 'Parked',
    },
    {
      'number': 'KA 18 XY 4421',
      'owner': 'Aditya Kumar',
      'type': 'Bike',
      'model': 'Royal Enfield',
      'status': 'Outside',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vehicles',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'View vehicles registered with the parking facility.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              _stat('842', 'Registered vehicles'),
              const SizedBox(width: 15),
              _stat('168', 'Currently parked'),
              const SizedBox(width: 15),
              _stat('674', 'Outside facility'),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE5E7EB),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by vehicle number or owner...',
                      prefixIcon:
                          const Icon(Icons.search, size: 20),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                _header(),
                ...vehicles.map(_vehicleRow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 13,
      ),
      color: const Color(0xFFF9FAFB),
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('VEHICLE')),
          Expanded(flex: 2, child: Text('OWNER')),
          Expanded(child: Text('TYPE')),
          Expanded(flex: 2, child: Text('MODEL')),
          SizedBox(width: 75, child: Text('STATUS')),
        ],
      ),
    );
  }

  Widget _vehicleRow(Map<String, String> vehicle) {
    final parked = vehicle['status'] == 'Parked';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFF0F0F0),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car_outlined,
                  size: 20,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 10),
                Text(
                  vehicle['number']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              vehicle['owner']!,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              vehicle['type']!,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              vehicle['model']!,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            width: 75,
            child: Text(
              vehicle['status']!,
              style: TextStyle(
                color: parked
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF6B7280),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}