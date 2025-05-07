import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/core/services/auth_service.dart';

class CalorieService {
  final AuthService _authService;

  CalorieService(this._authService);

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
      return data['totalCalories'] as int;
    } else {
      throw Exception('Failed to load daily calories: ${response.statusCode}');
    }
  }
}
