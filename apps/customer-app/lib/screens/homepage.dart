import 'package:flutter/material.dart';

/// ParkEase — customer app home screen.
/// Dark, modern theme. Fully standalone — no external theme file needed.
/// Drop into your customer-app's lib/ folder and set as home in MaterialApp.
class ParkEaseHomeScreen extends StatelessWidget {
  const ParkEaseHomeScreen({super.key});

  // Palette — dark, deep navy/charcoal with a blue-violet accent.
  static const _bg = Color(0xFF0E1116);
  static const _surface = Color(0xFF171B22);
  static const _surfaceAlt = Color(0xFF1F242C);
  static const _border = Color(0xFF2A2F38);
  static const _textPrimary = Color(0xFFF3F4F6);
  static const _textSecondary = Color(0xFF9AA3AF);
  static const _accent = Color(0xFF5B8DEF); // blue
  static const _accent2 = Color(0xFF8B5CF6); // violet
  static const _success = Color(0xFF34D399);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 22),
              _buildHero(context),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 28),
              _buildSectionTitle('Quick actions'),
              const SizedBox(height: 12),
              _buildQuickActions(),
              const SizedBox(height: 28),
              _buildSectionTitle('Nearby parking'),
              const SizedBox(height: 12),
              _buildNearbyCard(
                name: 'MG Road Parking Plaza',
                distance: '0.4 km away',
                price: '₹30/hr',
                slotsLeft: 12,
              ),
              const SizedBox(height: 12),
              _buildNearbyCard(
                name: 'Brigade Towers Basement',
                distance: '0.9 km away',
                price: '₹20/hr',
                slotsLeft: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Header ----------
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [_accent, _accent2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.local_parking_rounded, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ParkEase',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
            ),
            Text(
              'Good afternoon, Aditya',
              style: TextStyle(color: _textSecondary, fontSize: 13),
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border),
          ),
          child: const Icon(Icons.notifications_none_rounded,
              color: _textPrimary, size: 20),
        ),
      ],
    );
  }

  // ---------- Hero / tagline ----------
  Widget _buildHero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B2130), Color(0xFF232A3D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Never circle the block again.',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'ParkEase finds, reserves, and pays for your spot — before you arrive.',
            style: TextStyle(color: _textSecondary, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _accent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_rounded, size: 18),
                SizedBox(width: 8),
                Text('Find a parking spot',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Search bar ----------
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: const Row(
        children: [
          Icon(Icons.location_on_outlined, color: _textSecondary, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Where do you want to park?',
              style: TextStyle(color: _textSecondary, fontSize: 14),
            ),
          ),
          Icon(Icons.tune_rounded, color: _textSecondary, size: 18),
        ],
      ),
    );
  }

  // ---------- Section title ----------
  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  // ---------- Quick actions ----------
  Widget _buildQuickActions() {
    final actions = [
      (_QuickAction(Icons.qr_code_scanner_rounded, 'Scan & Park', _accent)),
      (_QuickAction(Icons.event_available_rounded, 'My Bookings', _accent2)),
      (_QuickAction(Icons.payments_outlined, 'Payments', _success)),
    ];

    return Row(
      children: actions
          .map((a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _buildActionTile(a),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionTile(_QuickAction action) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          Icon(action.icon, color: action.color, size: 22),
          const SizedBox(height: 8),
          Text(
            action.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Nearby parking card ----------
  Widget _buildNearbyCard({
    required String name,
    required String distance,
    required String price,
    required int slotsLeft,
  }) {
    final isLow = slotsLeft <= 5;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _surfaceAlt,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.local_parking_rounded,
                color: _accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('$distance · $price',
                    style:
                        const TextStyle(color: _textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: (isLow ? Colors.orange : _success).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$slotsLeft left',
              style: TextStyle(
                color: isLow ? Colors.orange : _success,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  const _QuickAction(this.icon, this.label, this.color);
  final IconData icon;
  final String label;
  final Color color;
}

