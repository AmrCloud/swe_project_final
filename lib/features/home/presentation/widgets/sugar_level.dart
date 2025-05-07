import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sugarsense/core/constants/app_colors.dart'; // Import AppColors

class SugarLevelTracker extends StatefulWidget {
  final Duration refreshInterval;
  final Function()? onRefresh; // Optional callback for parent

  const SugarLevelTracker({
    super.key,
    this.refreshInterval = const Duration(minutes: 5),
    this.onRefresh,
  });

  @override
  State<SugarLevelTracker> createState() => _SugarLevelTrackerState();
}

class _SugarLevelTrackerState extends State<SugarLevelTracker> {
  // Use a simple variable instead of a Future
  int _currentSugarLevel = 90; // Initial sugar level
  Timer? _refreshTimer;
  int _targetSugarLevel = 90;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _updateSugarLevel(int newLevel) {
    setState(() {
      _targetSugarLevel = newLevel;
    });

    const duration = Duration(milliseconds: 500);
    final steps = (_targetSugarLevel - _currentSugarLevel).abs();
    if (steps > 0) {
      final stepDuration = duration ~/ steps;
      Timer.periodic(stepDuration, (timer) {
        if (_currentSugarLevel < _targetSugarLevel) {
          setState(() {
            _currentSugarLevel++;
          });
        } else if (_currentSugarLevel > _targetSugarLevel) {
          setState(() {
            _currentSugarLevel--;
          });
        } else {
          timer.cancel();
        }
      });
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(widget.refreshInterval, (_) {
      if (mounted) {
        // Simulate sugar level change (replace with your logic)
        final randomChange = (10 - Random().nextInt(21)); //between -10 and +10
        final newLevel = _currentSugarLevel + randomChange;
        _updateSugarLevel(
          newLevel.clamp(40, 200),
        ); // Keep within a reasonable range
        widget.onRefresh?.call();
      }
    });
  }

  void _loadSugarLevel() {
    _updateSugarLevel(90); //reset
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: AppColors.surface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    'Sugar Levels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _loadSugarLevel,
                  tooltip: 'Refresh',
                  iconSize: 20,
                  color: AppColors.secondary(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                '$_currentSugarLevel',
                key: ValueKey<int>(_currentSugarLevel),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: ${TimeOfDay.now().format(context)}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  final random = Random();
}
