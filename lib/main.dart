import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/Dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nafai AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/login',
      routes: {
        '/login':     (ctx) => const LoginScreen(),
        '/dashboard': (ctx) => const DashboardScreen(),
      },
    );
  }
}