import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sugarsense/business_logic/blocs/login_bloc.dart';
import 'package:sugarsense/data/services/app_theme/app_colors.dart'; // Make sure this path is correct.// Import your login_bloc.dart
import 'package:http/http.dart' as http; // Import http
import 'dart:convert';

// Define the events and states.  These are often in separate files,
// but I've included them here for completeness in this single file.
// login_event.dart


// login_state.dart


//And the bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.4:5000/api/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': event.email,
          'password': event.password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        emit(LoginSuccess(token: token));
      } else {
        emit(LoginFailure(
            error:
                'Login failed with status code: ${response.statusCode} - ${response.body}')); // Include response body
      }
    } catch (e) {
      emit(LoginFailure(error: 'Failed to connect to the server: $e')); // Improved error
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(), // Provide the LoginBloc
      child: Scaffold(
        backgroundColor: AppColors.surface(context),
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context),
                          Center(child: _buildLogo()),
                          const Spacer(),
                          _buildBottomContainer(context),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              // Handle back button press.  Navigator.pop is the most common.
              Navigator.pop(context);
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary(context),
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/svgs/back_arrow.svg", // Make sure this path is correct.
                  colorFilter: ColorFilter.mode(
                    AppColors.onPrimary(context),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
              Text(
                "Back",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomContainer(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: AppColors.primary(context),
      ),
      child: const LoginForm(), // Use the const constructor.
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      // Wrap the Column with BlocConsumer
      listener: (context, state) {
        if (state is LoginSuccess) {
          // Navigate to the next screen or show a success message.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Successful! Token: ${state.token}'),
              duration: const Duration(seconds: 3),
            ),
          );
          // Example navigation:
          // Navigator.pushReplacementNamed(context, '/home');
        } else if (state is LoginFailure) {
          // Show an error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login Failed: ${state.error}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        // Build the UI based on the current state
        return Column(
          children: [
            _buildTextField(
              controller: _emailController,
              hintText: "Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              hintText: "Password",
              icon: Icons.lock,
              obscureText: _obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility
                      : Icons.visibility_off, // Use the boolean
                  color: AppColors.textPrimary(context),
                ),
                onPressed: () {
                  setState(() =>
                      _obscurePassword = !_obscurePassword); // Use setState
                },
              ),
            ),
            const SizedBox(height: 24),
            if (state is LoginLoading)
              const CircularProgressIndicator() // Show indicator when loading
            else
              ElevatedButton(
                onPressed: () {
                  // Dispatch the LoginRequested event
                  BlocProvider.of<LoginBloc>(context).add(
                    LoginRequested(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface(context),
                  foregroundColor: AppColors.primary(context),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Login"),
              ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.emailAddress,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        filled: true,
        fillColor: AppColors.surface(context),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.onSecondary(context)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.secondary(context)),
        ),
      ),
    );
  }
}

Widget _buildLogo() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Image.asset(
      'assets/images/logo.jpg', // 👈 Replace with your actual path
      height: 200, // Adjust as needed
    ),
  );
}
