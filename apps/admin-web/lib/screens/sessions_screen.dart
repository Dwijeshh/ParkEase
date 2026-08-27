import 'package:flutter/material.dart';

import '../services/session_service.dart';

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  final SessionService _sessionService = SessionService();

  String searchQuery = '';
  List<Map<String, String>> _sessions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _sessionService.getSessions();
      final raw = response is Map<String, dynamic> ? response['data'] : null;
      if (raw is! List) throw Exception('Invalid sessions response');

      final loaded = raw.whereType<Map>().map<Map<String, String>>((s) {
        return {
          'vehicle': s['vehicle']?.toString() ?? s['license_plate']?.toString() ?? '-',
          'user': s['user']?.toString() ?? s['name']?.toString() ?? '-',
          'slot': s['slot']?.toString() ?? s['slot_code']?.toString() ?? '-',
          'entry': s['entry']?.toString() ?? _formatIso(s['check_in_time']?.toString()),
          'exit': s['exit']?.toString() ?? _formatIso(s['check_out_time']?.toString()),
          'status': (s['status']?.toString() == 'Active' || s['status']?.toString() == 'ACTIVE')
              ? 'Active'
              : 'Completed',
        };
      }).toList();

      if (!mounted) return;
      setState(() {
        _sessions = loaded;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  String _formatIso(String? iso) {
    if (iso == null || iso.isEmpty) return '-';
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '-';
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
    final filteredSessions = _sessions.where((session) {
      final query = searchQuery.toLowerCase();
      return session['vehicle']!.toLowerCase().contains(query) ||
          session['user']!.toLowerCase().contains(query) ||
          session['slot']!.toLowerCase().contains(query) ||
          session['status']!.toLowerCase().contains(query);
    }).toList();

    final totalCount     = _sessions.length.toString();
    final activeCount    = _sessions.where((s) => s['status'] == 'Active').length.toString();
    final completedCount = _sessions.where((s) => s['status'] == 'Completed').length.toString();

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
                onPressed: _loadSessions,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Refresh'),
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
              _smallStat(totalCount, 'Total sessions'),
              const SizedBox(width: 15),
              _smallStat(activeCount, 'Active sessions'),
              const SizedBox(width: 15),
              _smallStat(completedCount, 'Completed'),
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
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Text(
                          'Error loading sessions',
                          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _loadSessions,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                else if (filteredSessions.isEmpty)
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

  Widget _smallStat(String value, String title) {
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
            child: Text('VEHICLE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          ),
          Expanded(
            flex: 2,
            child: Text('USER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Text('SLOT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Text('ENTRY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          ),
          Expanded(
            child: Text('EXIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          ),
          SizedBox(
            width: 80,
            child: Text('STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6B7280))),
          ),
        ],
      ),
    );
  }

  Widget _sessionRow(Map<String, String> session) {
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
}