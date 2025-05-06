import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: emailController,
              label: 'Email',
              hint: 'Enter your email',
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              hint: 'Enter your password',
              obscureText: true,
            ),
            const SizedBox(height: 24),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return CustomButton(
                  text: 'Login',
                  onPressed: () {
                    authBloc.add(LoginEvent(
                      email: emailController.text,
                      password: passwordController.text,
                    ));
                  },
                  isLoading: state is AuthLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}