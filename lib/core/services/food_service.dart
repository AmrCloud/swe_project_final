import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sugarsense/core/services/auth_service.dart';

class FoodService {
  final AuthService _authService;

  FoodService(this._authService);

  Future<List<dynamic>> getAllFoods() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('http://192.168.1.4:5000/api/food?sort=calories_per_gram&order=asc'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load foods');
    }
  }
}