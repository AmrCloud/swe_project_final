import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:5000';
  
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/api/auth/login');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'email': email, 'password': password});

    print('🌐 API Request:');
    print('URL: $url');
    print('Headers: $headers');
    print('Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      print('🔵 API Response:');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      print('🔴 Detailed Error:');
      print(e.runtimeType); // Print error type (e.g., SocketException)
      print(e.toString());  // Full error details
      rethrow;
    }
  }

  Exception _handleError(http.Response response) {
    switch (response.statusCode) {
      case 404:
        return Exception('Endpoint not found. Verify:'
            '\n- Server is running'
            '\n- URL is correct (${response.request?.url})'
            '\n- Route exists (/api/auth/login)');
      case 401:
        return Exception('Invalid credentials');
      case 500:
        return Exception('Server error: ${response.body}');
      default:
        return Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  }
}