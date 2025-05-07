import 'package:flutter/material.dart';
import 'package:sugarsense/features/home/presentation/widgets/calorie_tracker.dart';
import 'package:sugarsense/features/home/presentation/widgets/sugar_level.dart';
import 'package:sugarsense/core/constants/app_colors.dart'; // Import your AppColors

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(
        context,
      ), // Use a background color from your theme
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            // Make the content scrollable
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // Stretch children to full width
              children: [
                // 1. Title Section
                Text(
                  'Welcome to SugarSense', //App title
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(
                      context,
                    ), // Use primary text color
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Your Daily Health Overview',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.textSecondary(
                      context,
                    ), // Use secondary text color
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // 2. Calorie and Sugar Level Cards
                Row(
                  children: [
                    Expanded(
                      child: CalorieTracker(
                        onRefresh: () {
                          // You can add logic here to refresh other parts of the UI if needed
                          // For example:
                          //  _sugarLevelTrackerKey.currentState?.loadSugarLevel();
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SugarLevelTracker(
                        onRefresh: () {
                          // You can add logic here to refresh other parts of the UI if needed
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // 3.  Additional Content (Optional)
                _buildInfoCard(
                  //method for info card
                  context,
                  title: 'Tips for Healthy Living',
                  content:
                      'Maintain a balanced diet, exercise regularly, and monitor your sugar levels to stay healthy.',
                ),
                const SizedBox(height: 20),
                _buildInfoCard(
                  context,
                  title: 'Resources',
                  content:
                      'For more information, visit the CDC website or consult your healthcare provider.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 4,
      color: AppColors.onSurface(context), // Use card color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
