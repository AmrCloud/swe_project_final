import 'package:flutter/material.dart';
import 'package:sugarsense/core/constants/route_names.dart'; // Import your route names

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Simulate some loading or delay
    Future.delayed(const Duration(seconds: 2), () {
      // Navigate to the login page
      Navigator.of(context).pushReplacementNamed(RouteNames.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue, // You can customize the splash screen
      body: Center(
        child: Text(
          'SugarSense',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}