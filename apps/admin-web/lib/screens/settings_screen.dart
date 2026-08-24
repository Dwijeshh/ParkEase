import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;
  bool autoAllocation = true;
  bool alertSystem = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Manage your ParkEase admin preferences.',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          _section(
            title: 'Parking settings',
            children: [
              _settingTile(
                title: 'Automatic slot allocation',
                subtitle:
                    'Automatically assign the nearest available slot.',
                value: autoAllocation,
                onChanged: (value) {
                  setState(() {
                    autoAllocation = value;
                  });
                },
              ),
              _settingTile(
                title: 'Soft alert system',
                subtitle:
                    'Notify security when a reserved slot is occupied incorrectly.',
                value: alertSystem,
                onChanged: (value) {
                  setState(() {
                    alertSystem = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          _section(
            title: 'Notifications',
            children: [
              _settingTile(
                title: 'Admin notifications',
                subtitle:
                    'Receive alerts about parking and system activity.',
                value: notifications,
                onChanged: (value) {
                  setState(() {
                    notifications = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 18),

          _section(
            title: 'Facility information',
            children: [
              _infoRow('Facility name', 'ParkEase Parking Facility'),
              _infoRow('Total capacity', '240 slots'),
              _infoRow('Available gates', '3'),
              _infoRow('System status', 'Operational'),
            ],
          ),

          const SizedBox(height: 18),

          _section(
            title: 'Administrator',
            children: [
              _infoRow('Name', 'Admin'),
              _infoRow('Role', 'System Administrator'),
              _infoRow('Email', 'admin@parkease.com'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _section({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _settingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}