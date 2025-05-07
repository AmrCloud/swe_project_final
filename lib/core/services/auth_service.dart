import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugarsense/core/constants/app_constants.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<String> loginWithToken(String token) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'token': token}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      throw Exception('Token login failed: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String> register({
    required String name,
    required String email,
    required String password,
    required String gender,
    required int age,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConstants.apiBaseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'gender': gender,
        'age': age,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['message'];
    } else {
      throw Exception('Registration failed: ${response.statusCode}');
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
