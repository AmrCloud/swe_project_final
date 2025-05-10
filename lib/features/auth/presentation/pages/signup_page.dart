import 'package:flutter/material.dart';
import 'package:sugarsense/core/constants/app_colors.dart';
import 'package:sugarsense/core/services/auth_service.dart';
import 'package:sugarsense/core/constants/route_names.dart'; // Import your AppColors

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();
  bool _isLoading = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        gender: _gender,
        age: int.parse(_ageController.text.trim()),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful! Please login.')),
      );
      Navigator.pushReplacementNamed(context, RouteNames.login);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.onPrimary(context),
                      ), // Unfocused border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2.0,
                      ), // Focused border color and width
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.onPrimary(context),
                      ), // Unfocused border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2.0,
                      ), // Focused border color and width
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? 'Required'
                              : !value.contains('@')
                              ? 'Invalid email'
                              : null,
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.onPrimary(context),
                      ), // Unfocused border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2.0,
                      ), // Focused border color and width
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? 'Required'
                              : value.length < 6
                              ? 'Minimum 6 characters'
                              : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items:
                      ['Male', 'Female']
                          .map(
                            (gender) => DropdownMenuItem(
                              value: gender,
                              child: Text(gender),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => _gender = value!),
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.onPrimary(context),
                      ), // Unfocused border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2.0,
                      ), // Focused border color and width
                    ),
                    prefixIcon: Icon(Icons.wc),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.onPrimary(context),
                      ), // Unfocused border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: AppColors.secondary(context),
                        width: 2.0,
                      ), // Focused border color and width
                    ),
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? 'Required'
                              : int.tryParse(value) == null
                              ? 'Enter a valid number'
                              : int.parse(value) < 13
                              ? 'Must be 13 or older'
                              : null,
                ),
                SizedBox(height: 20),
                Center(
                  child:
                      _isLoading
                          ? CircularProgressIndicator()
                          : Center(
                            child: SizedBox(
                              // Use SizedBox to control the button's size
                              width:
                                  double
                                      .infinity, // Make the button as wide as its container
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.textPrimary(
                                    context,
                                  ), // Background color
                                  foregroundColor: AppColors.surface(
                                    context,
                                  ), // Text color (using surface for contrast)
                                  shape: RoundedRectangleBorder(
                                    // Define the button's shape
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ), // Make it square (no rounded corners)
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ), // Add vertical padding
                                ),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ), // Increase font size for better visibility
                                ),
                              ),
                            ),
                          ),
                ),
                Center(
                  child: Center(
                    child: TextButton(
                      onPressed:
                          () => Navigator.pushReplacementNamed(
                            context,
                            RouteNames.login,
                          ),
                      child: Text('Already have an account? Login'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
