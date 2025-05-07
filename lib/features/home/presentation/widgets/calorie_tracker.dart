import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugarsense/core/services/calorie_service.dart';
import 'package:sugarsense/core/constants/app_colors.dart'; // Import AppColors

class CalorieTracker extends StatefulWidget {
  final Duration refreshInterval;
  final Function()? onRefresh; // Optional callback for parent

  const CalorieTracker({
    super.key,
    this.refreshInterval = const Duration(minutes: 5),
    this.onRefresh,
  });

  @override
  State<CalorieTracker> createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  late Future<int> _caloriesFuture;
  Timer? _refreshTimer;
  int _currentCalories = 0;
  int _targetCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupAutoRefresh();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for changes in CalorieService
    final calorieService = Provider.of<CalorieService>(context, listen: true);
    if (_targetCalories != calorieService.currentCalories) {
      _updateCalories(calorieService.currentCalories);
    }
  }

  void _updateCalories(int newCalories) {
    setState(() {
      _targetCalories = newCalories;
    });

    // Animate the counter
    const duration = Duration(milliseconds: 500);
    final steps = (_targetCalories - _currentCalories).abs();

    if (steps > 0) {
      final stepDuration = duration ~/ steps;

      Timer.periodic(stepDuration, (timer) {
        if (_currentCalories < _targetCalories) {
          setState(() => _currentCalories++);
        } else if (_currentCalories > _targetCalories) {
          setState(() => _currentCalories--);
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _setupAutoRefresh() {
    _refreshTimer = Timer.periodic(widget.refreshInterval, (_) {
      if (mounted) _loadData(showLoading: false);
    });
  }

  void _loadData({bool showLoading = true}) {
    setState(() {
      _caloriesFuture = _fetchCalories(showLoading: showLoading);
    });
  }

  Future<int> _fetchCalories({bool showLoading = true}) async {
    try {
      final calorieService = Provider.of<CalorieService>(
        context,
        listen: false,
      );
      final calories = await calorieService.getDailyCalories();
      _updateCalories(calories);
      widget.onRefresh?.call();
      return calories;
    } catch (e) {
      if (showLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${e.toString()}',
              style: TextStyle(
                color: AppColors.onError(context),
              ), // Use error color from AppColors
            ),
            backgroundColor: Colors.red.shade100,
          ),
        );
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.surface(context), // Use surface color from AppColors
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for card
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Daily Calories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(
                        context,
                      ), // Use text color from AppColors
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: AppColors.secondary(
                      context,
                    ), // Use secondary color from AppColors
                  ),
                  onPressed: _loadData,
                  tooltip: 'Refresh',
                  iconSize: 20,
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<int>(
              future: _caloriesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    'Error loading data',
                    style: TextStyle(
                      color: AppColors.onError(
                        context,
                      ), // Use error color from AppColors
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    // Add a fade-in animation
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Text(
                    '$_currentCalories',
                    key: ValueKey<int>(_currentCalories),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary(
                        context,
                      ), // Use secondary text color from AppColors
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${TimeOfDay.now().format(context)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey, // Keep standard grey for this
              ),
            ),
          ],
        ),
      ),
    );
  }
}
