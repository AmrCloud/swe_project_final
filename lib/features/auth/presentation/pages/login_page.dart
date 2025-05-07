import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/core/constants/route_names.dart';
import 'package:sugarsense/core/services/auth_service.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

Future<void> _login() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() => _isLoading = true);

  try {
    await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    Navigator.pushReplacementNamed(context, RouteNames.home);
  } catch (e) {
    final errorMessage = _parseError(e);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 5), // Longer to read details
      ),
    );
    print('🛑 Full error details for debugging:');
    print(e.toString());
  } finally {
    setState(() => _isLoading = false);
  }
}

String _parseError(dynamic error) {
  if (error is SocketException) {
    return 'Network error: Server unreachable. Check:'
        '\n1. Is your backend running?'
        '\n2. Is the URL correct? (${AppConstants.apiBaseUrl})'
        '\n3. Are you connected to the internet?';
  } else if (error is http.ClientException) {
    return 'Connection failed: ${error.message}';
  } else if (error is FormatException) {
    return 'Invalid server response: ${error.message}';
  } else {
    return error.toString();
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                    value!.isEmpty ? 'Password is required' : null,
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}