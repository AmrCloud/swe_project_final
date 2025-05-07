import 'package:flutter/material.dart';
import 'package:sugarsense/features/logs/presentation/widgets/food_tracker_widget.dart';

class Logs extends StatelessWidget {
  const Logs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FoodTrackerWidget()));
  }
}
