import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/report_service.dart';
import '../services/session_service.dart';
import 'parking_screen.dart';
import 'users_screen.dart';
import 'vehicles_screen.dart';
import 'sessions_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectedIndex = 0;

  // ── Live data ──────────────────────────────────────────────
  bool _loading = true;
  Map<String, dynamic> _summary = {};
  List<Map<String, dynamic>> _recentSessions = [];
  String _adminEmail = '';
  String _adminName = 'Admin';

  final List<String> menuItems = [
    'Dashboard',
    'Parking',
    'Users',
    'Vehicles',
    'Sessions',
    'Reports',
    'Settings',
  ];

  final List<IconData> menuIcons = [
    Icons.dashboard_outlined,
    Icons.local_parking_outlined,
    Icons.people_outline,
    Icons.directions_car_outlined,
    Icons.access_time_outlined,
    Icons.bar_chart_outlined,
    Icons.settings_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    try {
      const storage = FlutterSecureStorage();
      final results = await Future.wait([
        ReportService().getSummary(),
        SessionService().getSessions(),
        storage.read(key: 'admin_email'),
      ]);

      final summaryRaw = results[0];
      final sessionsRaw = results[1];
      final email = (results[2] as String?) ?? '';

      // Parse summary — backend returns flat object (not nested under 'data')
      Map<String, dynamic> summary = {};
      if (summaryRaw is Map<String, dynamic>) {
        summary = summaryRaw['data'] is Map
            ? Map<String, dynamic>.from(summaryRaw['data'])
            : Map<String, dynamic>.from(summaryRaw);
      }

      // Parse sessions
      List<Map<String, dynamic>> sessions = [];
      if (sessionsRaw is Map<String, dynamic>) {
        final data = sessionsRaw['data'];
        if (data is List) {
          sessions = data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
        }
      }

      // Derive admin display name from email (part before @)
      final local = email.split('@').first;
      final displayName = local.isNotEmpty
          ? local[0].toUpperCase() + local.substring(1)
          : 'Admin';

      if (!mounted) return;
      setState(() {
        _summary = summary;
        _recentSessions = sessions.take(5).toList();
        _adminEmail = email;
        _adminName = displayName;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _loading ? const Center(child: CircularProgressIndicator()) : _buildDashboardHome(),
      const ParkingScreen(),
      const UsersScreen(),
      const VehiclesScreen(),
      const SessionsScreen(),
      const ReportsScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // ==================== SIDEBAR ====================
          Container(
            width: 235,
            color: const Color(0xFF111827),
            child: Column(
              children: [
                // Logo
                Container(
                  height: 80,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.local_parking_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'ParkEase',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(
                  color: Color(0xFF374151),
                  height: 1,
                ),

                const SizedBox(height: 18),

                // ==================== MENU ====================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(9),
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1F2937)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  menuIcons[index],
                                  color: isSelected
                                      ? const Color(0xFF4ADE80)
                                      : const Color(0xFF9CA3AF),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  menuItems[index],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF9CA3AF),
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ==================== ADMIN PROFILE ====================
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 19,
                        backgroundColor: Color(0xFF374151),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _adminName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _adminEmail.isNotEmpty ? _adminEmail : 'Administrator',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================== MAIN CONTENT ====================
          Expanded(
            child: Column(
              children: [
                // ==================== TOP BAR ====================
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(
                        color: Color(0xFFE5E7EB),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        menuItems[selectedIndex],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),

                      const Spacer(),

                      // ==================== NOTIFICATIONS ====================
                      IconButton(
                        tooltip: 'Notifications',
                        onPressed: () {
                          _showNotifications(context);
                        },
                        icon: const Icon(
                          Icons.notifications_none_outlined,
                          color: Color(0xFF6B7280),
                        ),
                      ),

                      const SizedBox(width: 5),

                      // ==================== PROFILE ====================
                      PopupMenuButton<String>(
                        tooltip: 'Admin profile',
                        onSelected: (value) {
                          if (value == 'profile') {
                            _showProfile(context);
                          }
                        },
                        itemBuilder: (context) {
                          return const [
                            PopupMenuItem(
                              value: 'profile',
                              child: Row(
                                children: [
                                  Icon(Icons.person_outline),
                                  SizedBox(width: 10),
                                  Text('View profile'),
                                ],
                              ),
                            ),
                          ];
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            size: 19,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================== CURRENT SCREEN ====================
                Expanded(
                  child: screens[selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DASHBOARD HOME
  // ============================================================

  Widget _buildDashboardHome() {
    final totalSlots   = _summary['totalSlots']?.toString()   ?? '-';
    final occupied     = _summary['occupiedSlots']?.toString() ?? '-';
    final available    = _summary['availableSlots']?.toString() ?? '-';
    final reserved     = _summary['reservedSlots']?.toString()  ?? '-';
    final totalVeh     = _summary['totalVehicles']?.toString()  ?? '-';
    final occupancyRaw = _summary['occupancy'];
    final occupancy    = occupancyRaw != null
        ? '${double.tryParse(occupancyRaw.toString())?.toStringAsFixed(1) ?? occupancyRaw}%'
        : '-';
    final revenueRaw   = _summary['revenue'];
    final revenue      = revenueRaw != null
        ? '₹${double.tryParse(revenueRaw.toString())?.toStringAsFixed(0) ?? revenueRaw}'
        : '-';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard overview',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Monitor your parking facility at a glance.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          // ==================== STAT CARDS ====================
          Row(
            children: [
              _statCard(totalSlots, 'Total slots', Icons.grid_view_rounded),
              const SizedBox(width: 15),
              _statCard(occupied, 'Occupied', Icons.directions_car_outlined),
              const SizedBox(width: 15),
              _statCard(available, 'Available', Icons.check_circle_outline),
              const SizedBox(width: 15),
              _statCard(reserved, 'Reserved', Icons.bookmark_border),
            ],
          ),

          const SizedBox(height: 25),

          // ==================== PARKING ACTIVITY ====================
          Container(
            width: double.infinity,
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
                  'Parking activity',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Recent activity in your parking facility.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 20),

                _activityHeader(),

                if (_recentSessions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Text('No recent sessions', style: TextStyle(color: Color(0xFF9CA3AF))),
                    ),
                  )
                else
                  ..._recentSessions.map((s) {
                    return _activityRow(
                      s['vehicle']?.toString() ?? s['license_plate']?.toString() ?? '-',
                      s['slot']?.toString() ?? s['slot_code']?.toString() ?? '-',
                      s['entry']?.toString() ?? _formatIso(s['check_in_time']?.toString()),
                      s['status']?.toString() == 'Active' || s['status']?.toString() == 'ACTIVE'
                          ? 'Active'
                          : 'Completed',
                    );
                  }),
              ],
            ),
          ),

          const SizedBox(height: 25),

          // ==================== QUICK OVERVIEW ====================
          Row(
            children: [
              Expanded(
                child: _overviewCard(
                  'Total vehicles',
                  totalVeh,
                  'Registered vehicles',
                  Icons.directions_car_outlined,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _overviewCard(
                  'Occupancy',
                  occupancy,
                  'Current facility occupancy',
                  Icons.pie_chart_outline,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _overviewCard(
                  'Revenue',
                  revenue,
                  'Total parking revenue',
                  Icons.currency_rupee,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatIso(String? iso) {
    if (iso == null) return '-';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '-';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  // ============================================================
  // STAT CARD
  // ============================================================

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
              child: Icon(
                icon,
                color: const Color(0xFF16A34A),
                size: 21,
              ),
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

  // ============================================================
  // ACTIVITY HEADER
  // ============================================================

  Widget _activityHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
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
              'TIME',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          SizedBox(
            width: 75,
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

  // ============================================================
  // ACTIVITY ROW
  // ============================================================

  Widget _activityRow(
    String vehicle,
    String slot,
    String time,
    String status,
  ) {
    final active = status == 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 13,
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
                  vehicle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Text(
              slot,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              time,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
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
                status,
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

  // ============================================================
  // OVERVIEW CARD
  // ============================================================

  Widget _overviewCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
  ) {
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
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF4B5563),
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: Color(0xFF16A34A),
              ),
              SizedBox(width: 10),
              Text('Notifications'),
            ],
          ),
          content: const SizedBox(
            width: 380,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.warning_amber_outlined,
                    color: Color(0xFFF59E0B),
                  ),
                  title: Text('High occupancy'),
                  subtitle: Text(
                    'Parking slots are filling up. Monitor availability.',
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.local_parking_outlined,
                    color: Color(0xFF16A34A),
                  ),
                  title: Text('New parking session'),
                  subtitle: Text(
                    'A vehicle has entered the facility.',
                  ),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: Color(0xFF2563EB),
                  ),
                  title: Text('System status'),
                  subtitle: Text(
                    'Parking system is operating normally.',
                  ),
                ),
              ],
            ),
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

  // ============================================================
  // PROFILE
  // ============================================================

  void _showProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Admin Profile'),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFE5E7EB),
                  child: Icon(
                    Icons.person_outline,
                    size: 32,
                    color: Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  _adminName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Administrator',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(_adminEmail.isNotEmpty ? _adminEmail : '-'),
                  dense: true,
                ),
                const ListTile(
                  leading: Icon(Icons.security_outlined),
                  title: Text('Administrator access'),
                  dense: true,
                ),
              ],
            ),
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