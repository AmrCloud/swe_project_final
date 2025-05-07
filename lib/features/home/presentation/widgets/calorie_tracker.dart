import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugarsense/core/services/calorie_service.dart';

class CalorieTracker extends StatefulWidget {
  final Duration refreshInterval; // Optional: set auto-refresh interval

  const CalorieTracker({super.key, this.refreshInterval = const Duration(minutes: 5)});

  @override
  State<CalorieTracker> createState() => _CalorieTrackerState();
}

class _CalorieTrackerState extends State<CalorieTracker> {
  late Future<int> _caloriesFuture;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _setupAutoRefresh() {
    _refreshTimer = Timer.periodic(widget.refreshInterval, (_) {
      if (mounted) {
        _loadData(showLoading: false); // Silent refresh
      }
    });
  }

  void _loadData({bool showLoading = true}) {
    setState(() {
      _caloriesFuture = _fetchCalories(showLoading: showLoading);
    });
  }

  Future<int> _fetchCalories({bool showLoading = true}) async {
    try {
      final calorieService = Provider.of<CalorieService>(context, listen: false);
      return await calorieService.getDailyCalories();
    } catch (e) {
      if (showLoading) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Calories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<int>(
          future: _caloriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      '${snapshot.data ?? 0}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Last updated: ${TimeOfDay.now().format(context)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}