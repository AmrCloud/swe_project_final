import 'package:flutter/material.dart';
import 'package:sugarsense/features/home/presentation/widgets/calorie_tracker.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CalorieTracker(),
      ),
    );
  }
}