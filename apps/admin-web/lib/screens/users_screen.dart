import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String searchQuery = '';

  final List<Map<String, String>> users = [
    {
      'name': 'Rahul Shetty',
      'email': 'rahul@example.com',
      'phone': '+91 98765 43210',
      'status': 'Active',
    },
    {
      'name': 'Ananya Rao',
      'email': 'ananya@example.com',
      'phone': '+91 98452 11980',
      'status': 'Active',
    },
    {
      'name': 'Karthik Pai',
      'email': 'karthik@example.com',
      'phone': '+91 99001 82341',
      'status': 'Inactive',
    },
    {
      'name': 'Meera Nair',
      'email': 'meera@example.com',
      'phone': '+91 98123 44210',
      'status': 'Active',
    },
    {
      'name': 'Aditya Kumar',
      'email': 'aditya@example.com',
      'phone': '+91 97654 21890',
      'status': 'Active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users.where((user) {
      final query = searchQuery.toLowerCase();

      return user['name']!.toLowerCase().contains(query) ||
          user['email']!.toLowerCase().contains(query) ||
          user['phone']!.toLowerCase().contains(query);
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Row(
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Users',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Manage registered ParkEase users.',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              ElevatedButton.icon(
                onPressed: () => _showAddUser(context),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add user'),
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

          // ================= STAT CARDS =================
          Row(
            children: [
              _smallStat(
                '1,284',
                'Total users',
              ),
              const SizedBox(width: 15),
              _smallStat(
                '1,176',
                'Active users',
              ),
              const SizedBox(width: 15),
              _smallStat(
                '108',
                'Inactive users',
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ================= USERS TABLE =================
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
                // Search
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search users...',
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
                      contentPadding:
                          const EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1),

                // Table header
                _tableHeader(),

                // User rows
                if (filteredUsers.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 40,
                          color: Color(0xFF9CA3AF),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No users found',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...filteredUsers.map(
                    (user) => _userRow(user),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= STAT CARD =================

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

  // ================= TABLE HEADER =================

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
              'USER',
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
              'EMAIL',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              'PHONE',
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

  // ================= USER ROW =================

  Widget _userRow(
    Map<String, String> user,
  ) {
    final active = user['status'] == 'Active';

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
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFEFF6FF),
                  child: Text(
                    user['name']![0],
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  user['name']!,
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
              user['email']!,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              user['phone']!,
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
                user['status']!,
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

  // ================= ADD USER =================

  void _showAddUser(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add user'),

          content: const SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Full name',
                  ),
                ),

                SizedBox(height: 14),

                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),

                SizedBox(height: 14),

                TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone number',
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
              child: const Text('Add user'),
            ),
          ],
        );
      },
    );
  }
}