import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sugarsense/core/errors/exceptions.dart';

class ApiClient {
  final String baseUrl;
  final http.Client client;

  ApiClient({required this.baseUrl, required this.client});

  Future<dynamic> get(String endpoint) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$endpoint'));
      return _handleResponse(response);
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return json.decode(response.body);
      case 400:
        throw ServerException('Bad Request');
      case 401:
        throw ServerException('Unauthorized');
      case 403:
        throw ServerException('Forbidden');
      case 404:
        throw ServerException('Not Found');
      case 500:
        throw ServerException('Internal Server Error');
      default:
        throw ServerException('Unknown Error');
    }
  }
}