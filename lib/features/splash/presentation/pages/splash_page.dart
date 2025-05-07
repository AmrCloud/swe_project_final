import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugarsense/core/constants/app_colors.dart';
import 'package:sugarsense/core/constants/route_names.dart';
import 'package:sugarsense/core/services/auth_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      // Check if user is already logged in
      final isLoggedIn = await authService.isLoggedIn();

      if (isLoggedIn) {
        // User is logged in, go to home
        Navigator.of(context).pushReplacementNamed(RouteNames.bottomNavigation);
      } else {
        // User is not logged in, go to login
        Navigator.of(context).pushReplacementNamed(RouteNames.login);
      }
    } catch (e) {
      // If there's an error checking auth status, still go to login
      Navigator.of(context).pushReplacementNamed(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo or app name
            Text(
              'SugarSense',
              style: TextStyle(
                color: AppColors.surface(context),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // Optional loading indicator
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
