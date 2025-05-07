import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/core/services/auth_service.dart';

class CalorieService with ChangeNotifier {
  final AuthService _authService;
  int _currentCalories = 0;

  CalorieService(this._authService);

  int get currentCalories => _currentCalories;

  Future<int> getDailyCalories() async {
    final token = await _authService.getToken();

    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}/consumed/day-calories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentCalories = data['totalCalories'] as int;
      notifyListeners();
      return _currentCalories;
    } else {
      throw Exception('Failed to load daily calories: ${response.statusCode}');
    }
  }

  Future<void> addConsumedCalories(int calories) async {
    final token = await _authService.getToken();
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/consumed/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'calories': calories}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _currentCalories = data['newTotal'] as int;
      notifyListeners();
    } else {
      throw Exception('Failed to add calories: ${response.statusCode}');
    }
  }

  Future<void> resetDailyCalories() async {
    final token = await _authService.getToken();
    
    if (token == null) {
      throw Exception('No authentication token found');
    }

    final response = await http.delete(
      Uri.parse('${AppConstants.apiBaseUrl}/consumed/reset'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      _currentCalories = 0;
      notifyListeners();
    } else {
      throw Exception('Failed to reset calories: ${response.statusCode}');
    }
  }
}