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
      final query = searchQuery.toLowerCase().trim();

      return user['name']!.toLowerCase().contains(query) ||
          user['email']!.toLowerCase().contains(query) ||
          user['phone']!.toLowerCase().contains(query);
    }).toList();

    final totalUsers = users.length;
    final activeUsers =
        users.where((user) => user['status'] == 'Active').length;
    final inactiveUsers =
        users.where((user) => user['status'] == 'Inactive').length;

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
                icon: const Icon(
                  Icons.add,
                  size: 18,
                ),
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
                '$totalUsers',
                'Total users',
              ),
              const SizedBox(width: 15),
              _smallStat(
                '$activeUsers',
                'Active users',
              ),
              const SizedBox(width: 15),
              _smallStat(
                '$inactiveUsers',
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
                // ================= SEARCH =================
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
                              icon: const Icon(
                                Icons.clear,
                              ),
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

                // ================= TABLE HEADER =================
                _tableHeader(),

                // ================= USER ROWS =================
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

  // ============================================================
  // STAT CARD
  // ============================================================

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

  // ============================================================
  // TABLE HEADER
  // ============================================================

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

  // ============================================================
  // USER ROW
  // ============================================================

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
                    user['name']!.isNotEmpty
                        ? user['name']![0].toUpperCase()
                        : '?',
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

  // ============================================================
  // ADD USER DIALOG
  // ============================================================

  void _showAddUser(
    BuildContext context,
  ) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add user',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

          content: SizedBox(
            width: 400,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ================= NAME =================
                  TextFormField(
                    controller: nameController,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(
                        Icons.person_outline,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter the user name';
                      }

                      if (value.trim().length < 2) {
                        return 'Name is too short';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // ================= EMAIL =================
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter an email';
                      }

                      final emailRegex = RegExp(
                        r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                      );

                      if (!emailRegex.hasMatch(
                        value.trim(),
                      )) {
                        return 'Enter a valid email';
                      }

                      final alreadyExists = users.any(
                        (user) =>
                            user['email']!.toLowerCase() ==
                            value.trim().toLowerCase(),
                      );

                      if (alreadyExists) {
                        return 'This email is already registered';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // ================= PHONE =================
                  TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: Icon(
                        Icons.phone_outlined,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onFieldSubmitted: (_) {
                      _addUserFromDialog(
                        dialogContext,
                        formKey,
                        nameController,
                        emailController,
                        phoneController,
                      );
                    },
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }

                      final digits =
                          value.replaceAll(RegExp(r'\D'), '');

                      if (digits.length < 10) {
                        return 'Enter a valid phone number';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),

          // ================= BUTTONS =================
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                _addUserFromDialog(
                  dialogContext,
                  formKey,
                  nameController,
                  emailController,
                  phoneController,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add user'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // ADD USER LOGIC
  // ============================================================

  void _addUserFromDialog(
    BuildContext dialogContext,
    GlobalKey<FormState> formKey,
    TextEditingController nameController,
    TextEditingController emailController,
    TextEditingController phoneController,
  ) {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final newUser = {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'status': 'Active',
    };

    setState(() {
      users.add(newUser);
    });

    Navigator.pop(dialogContext);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${newUser['name']} added successfully',
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}