import 'package:flutter/material.dart';

import '../services/user_service.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final UserService _userService = UserService();
  List<Map<String, dynamic>> users = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await _userService.getUsers();
      final data = response is Map<String, dynamic> ? response['data'] : null;
      if (data is! List) throw Exception('Invalid users response');

      final loadedUsers = data
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (user) => {
              'id': user['id']?.toString() ?? '',
              'name': user['name']?.toString() ?? 'Unknown user',
              'email': user['email']?.toString() ?? '',
              'phone': '',
              'role': user['role']?.toString() ?? 'CUSTOMER',
            },
          )
          .toList();

      if (!mounted) return;
      setState(() {
        users = loadedUsers;
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Manage registered users and their access.',
            style: TextStyle(color: Color(0xFF6B7280), fontSize: 14),
          ),
          const SizedBox(height: 25),
          if (isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()))
          else if (errorMessage != null)
            Center(
              child: Column(
                children: [
                  Text(errorMessage!),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
                ],
              ),
            )
          else if (users.isEmpty)
            const Center(child: Padding(padding: EdgeInsets.all(40), child: Text('No users found.')))
          else
            _usersTable(),
        ],
      ),
    );
  }

  Widget _usersTable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Email')),
            DataColumn(label: Text('Role')),
          ],
          rows: users
              .map(
                (user) => DataRow(
                  cells: [
                    DataCell(Text(user['name'].toString())),
                    DataCell(Text(user['email'].toString())),
                    DataCell(Text(user['role'].toString())),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
