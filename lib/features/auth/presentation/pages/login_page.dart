import 'package:flutter/material.dart';
import 'package:sugarsense/core/constants/app_colors.dart'; // Import your AppColors
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

      Navigator.pushReplacementNamed(context, RouteNames.bottomNavigation);
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
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        child:
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch, // Use stretch for better layout
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center, // Center the content vertically
                      children: [
                        //Use expanded and Flexible to control the spacing.
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary(context),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.onPrimary(context),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.secondary(context),
                                width: 2.0,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.email),
                          ),
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.onPrimary(context),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: AppColors.secondary(context),
                                width: 2.0,
                              ),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator:
                              (value) => value!.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: Text(
                            'Remember me',
                            style: TextStyle(
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          value: _rememberMe,
                          onChanged:
                              (value) => setState(() => _rememberMe = value!),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.secondary(context),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimary(context),
                            foregroundColor: AppColors.surface(context),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 15,
                            ), // Increased padding
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: AppColors.textPrimary(context),
                              ),
                            ),
                            TextButton(
                              onPressed:
                                  () => Navigator.pushNamed(
                                    context,
                                    RouteNames.signup,
                                  ),
                              child: Text(
                                'Sign up',
                                style: TextStyle(
                                  color: AppColors.secondary(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
