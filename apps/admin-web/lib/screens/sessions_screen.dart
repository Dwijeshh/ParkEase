import 'package:flutter/material.dart';

class SessionsScreen extends StatefulWidget {
const SessionsScreen({super.key});

@override
State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
String searchQuery = '';

final List<Map<String, String>> sessions = [
{
'vehicle': 'KA 20 AB 1234',
'user': 'Rahul Shetty',
'slot': 'A-101',
'entry': '6:12 PM',
'exit': '-',
'status': 'Active',
},
{
'vehicle': 'KA 19 CD 4821',
'user': 'Ananya Rao',
'slot': 'A-104',
'entry': '5:48 PM',
'exit': '-',
'status': 'Active',
},
{
'vehicle': 'KA 05 EF 9210',
'user': 'Karthik Pai',
'slot': 'A-106',
'entry': '4:25 PM',
'exit': '6:05 PM',
'status': 'Completed',
},
{
'vehicle': 'KA 20 GH 7712',
'user': 'Meera Nair',
'slot': 'A-109',
'entry': '5:20 PM',
'exit': '-',
'status': 'Active',
},
{
'vehicle': 'KA 18 XY 4421',
'user': 'Aditya Kumar',
'slot': 'B-102',
'entry': '3:42 PM',
'exit': '5:30 PM',
'status': 'Completed',
},
];

@override
Widget build(BuildContext context) {
final filteredSessions = sessions.where((session) {
final query = searchQuery.toLowerCase();

  return session['vehicle']!.toLowerCase().contains(query) ||
      session['user']!.toLowerCase().contains(query) ||
      session['slot']!.toLowerCase().contains(query) ||
      session['status']!.toLowerCase().contains(query);
}).toList();

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
                'Sessions',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Monitor active and completed parking sessions.',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {
              _showStartSession(context);
            },
            icon: const Icon(Icons.play_arrow, size: 18),
            label: const Text('Start session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                horizontal: 17,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 25),
      Row(
        children: [
          _smallStat('5', 'Total sessions'),
          const SizedBox(width: 15),
          _smallStat('3', 'Active sessions'),
          const SizedBox(width: 15),
          _smallStat('2', 'Completed'),
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
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search sessions...',
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const Divider(height: 1),
            _tableHeader(),
            if (filteredSessions.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_outlined,
                      size: 40,
                      color: Color(0xFF9CA3AF),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No sessions found',
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              )
            else
              ...filteredSessions.map(
                (session) => _sessionRow(session),
              ),
          ],
        ),
      ),
    ],
  ),
);

}

Widget _smallStat(
String value,
String title,
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
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
value,
style: const TextStyle(
fontSize: 21,
fontWeight: FontWeight.w700,
color: Color(0xFF111827),
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

Widget _tableHeader() {
return Container(
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 13,
),
color: const Color(0xFFF9FAFB),
child: const Row(
children: [
Expanded(
flex: 2,
child: Text(
'VEHICLE',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w600,
color: Color(0xFF6B7280),
),
),
),
Expanded(
flex: 2,
child: Text(
'USER',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w600,
color: Color(0xFF6B7280),
),
),
),
Expanded(
child: Text(
'SLOT',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w600,
color: Color(0xFF6B7280),
),
),
),
Expanded(
child: Text(
'ENTRY',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w600,
color: Color(0xFF6B7280),
),
),
),
Expanded(
child: Text(
'EXIT',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w600,
color: Color(0xFF6B7280),
),
),
),
SizedBox(
width: 80,
child: Text(
'STATUS',
style: TextStyle(
fontSize: 10,
fontWeight: FontWeight.w600,
color: Color(0xFF6B7280),
),
),
),
],
),
);
}

Widget _sessionRow(
Map<String, String> session,
) {
final active = session['status'] == 'Active';

return Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 15,
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
              size: 19,
              color: Color(0xFF6B7280),
            ),
            const SizedBox(width: 8),
            Text(
              session['vehicle']!,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: Text(
          session['user']!,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 12,
          ),
        ),
      ),
      Expanded(
        child: Text(
          session['slot']!,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
          ),
        ),
      ),
      Expanded(
        child: Text(
          session['entry']!,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
          ),
        ),
      ),
      Expanded(
        child: Text(
          session['exit']!,
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 12,
          ),
        ),
      ),
      SizedBox(
        width: 80,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
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
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ],
  ),
);

}

void _showStartSession(
BuildContext context,
) {
showDialog(
context: context,
builder: (context) {
return AlertDialog(
title: const Text('Start parking session'),
content: const SizedBox(
width: 400,
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
TextField(
decoration: InputDecoration(
labelText: 'Vehicle number',
),
),
SizedBox(height: 14),
TextField(
decoration: InputDecoration(
labelText: 'User name',
),
),
SizedBox(height: 14),
TextField(
decoration: InputDecoration(
labelText: 'Parking slot',
),
),
],
),
),
actions: [
TextButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text('Cancel'),
),
ElevatedButton(
onPressed: () {
Navigator.pop(context);
},
child: const Text('Start session'),
),
],
);
},
);
}
}