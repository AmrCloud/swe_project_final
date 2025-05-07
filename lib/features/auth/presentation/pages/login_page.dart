import 'package:flutter/material.dart';
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/core/constants/route_names.dart';
import 'package:sugarsense/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _tryTokenLogin();
  }

  Future<void> _tryTokenLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      setState(() => _isLoading = true);
      try {
        final newToken = await _authService.loginWithToken(token);
        await _saveToken(newToken);
        Navigator.pushReplacementNamed(context, RouteNames.bottomNavigation);
      } catch (e) {
        // Token expired or invalid - proceed to normal login
        await prefs.remove('auth_token');
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final token = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (_rememberMe) {
        await _saveToken(token);
      }

      Navigator.pushReplacementNamed(context, RouteNames.home);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator:
                            (value) => value!.isEmpty ? 'Required' : null,
                      ),
                      CheckboxListTile(
                        title: Text('Remember me'),
                        value: _rememberMe,
                        onChanged:
                            (value) => setState(() => _rememberMe = value!),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),

                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: _login,
                            child: Text('Login'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                onPressed:
                                    () => Navigator.pushNamed(
                                      context,
                                      RouteNames.signup,
                                    ),
                                child: Text('Sign up'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
