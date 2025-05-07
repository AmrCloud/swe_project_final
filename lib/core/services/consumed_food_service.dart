import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sugarsense/core/services/auth_service.dart';

class ConsumedFoodService {
  final AuthService _authService;

  ConsumedFoodService(this._authService);

  Future<List<dynamic>> getConsumedFoods() async {
    final token = await _authService.getToken();
    final response = await http.get(
      Uri.parse('http://192.168.1.4:5000/api/consumed'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load consumed foods');
    }
  }

  Future<void> addConsumedFood(int foodId, double grams) async {
    final token = await _authService.getToken();
    final response = await http.post(
      Uri.parse('http://192.168.1.4:5000/api/consumed'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'food_id': foodId,
        'consumed_grams': grams,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add food');
    }
  }

  // In consumed_food_service.dart
Future<void> updateConsumedFood(int consumedId, double grams) async {
  final token = await _authService.getToken();
  final response = await http.put(
    Uri.parse('http://192.168.1.4:5000/api/consumed/$consumedId'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'consumed_grams': grams,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update food: ${response.statusCode}');
  }
}

  Future<void> deleteConsumedFood(int consumedId) async {
    final token = await _authService.getToken();
    final response = await http.delete(
      Uri.parse('http://192.168.1.4:5000/api/consumed/$consumedId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete food');
    }
  }
}