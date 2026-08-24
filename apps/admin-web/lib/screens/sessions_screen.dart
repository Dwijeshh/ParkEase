import 'package:flutter/material.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  final List<Map<String, String>> sessions = const [
    {
      'vehicle': 'KA 20 AB 1234',
      'user': 'Rahul Shetty',
      'slot': 'A-101',
      'entry': '06:12 PM',
      'duration': '58 min',
      'status': 'Active',
    },
    {
      'vehicle': 'KA 19 CD 4821',
      'user': 'Ananya Rao',
      'slot': 'A-104',
      'entry': '05:48 PM',
      'duration': '1h 22m',
      'status': 'Active',
    },
    {
      'vehicle': 'KA 05 EF 9210',
      'user': 'Karthik Pai',
      'slot': 'A-106',
      'entry': '04:25 PM',
      'duration': '2h 45m',
      'status': 'Completed',
    },
    {
      'vehicle': 'KA 20 GH 7712',
      'user': 'Meera Nair',
      'slot': 'A-109',
      'entry': '05:20 PM',
      'duration': '1h 50m',
      'status': 'Active',
    },
    {
      'vehicle': 'KA 18 XY 4421',
      'user': 'Aditya Kumar',
      'slot': 'B-102',
      'entry': '03:42 PM',
      'duration': '3h 28m',
      'status': 'Completed',
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
            'Parking sessions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Track active and completed parking sessions.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: [
              _statCard(
                '54',
                'Active sessions',
                Icons.play_circle_outline,
              ),
              const SizedBox(width: 15),
              _statCard(
                '126',
                'Completed today',
                Icons.check_circle_outline,
              ),
              const SizedBox(width: 15),
              _statCard(
                '180',
                'Total today',
                Icons.today_outlined,
              ),
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
                  child: Row(
                    children: [
                      const Text(
                        'Today\'s sessions',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download_outlined,
                          size: 17,
                        ),
                        label: const Text('Export'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                _header(),
                ...sessions.map(_sessionRow),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String value,
    String title,
    IconData icon,
  ) {
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
                    fontSize: 21,
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
          Expanded(flex: 2, child: Text('USER')),
          Expanded(child: Text('SLOT')),
          Expanded(child: Text('ENTRY')),
          Expanded(child: Text('DURATION')),
          SizedBox(width: 75, child: Text('STATUS')),
        ],
      ),
    );
  }

  Widget _sessionRow(Map<String, String> session) {
    final active = session['status'] == 'Active';

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
            child: Text(
              session['vehicle']!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              session['user']!,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              session['slot']!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              session['entry']!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              session['duration']!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          SizedBox(
            width: 75,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 7,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFF0FDF4)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                session['status']!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: active
                      ? const Color(0xFF15803D)
                      : const Color(0xFF6B7280),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}