import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'theme.dart';
import 'widgets/phone_frame.dart';

void main() {
  runApp(const ParkEaseApp());
}

class ParkEaseApp extends StatelessWidget {
  const ParkEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkEase',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) => PhoneFrame(child: child),
      home: const LoginScreen(),
    );
  }
}
