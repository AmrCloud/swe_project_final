import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sugarsense/core/constants/app_colors.dart';
import 'package:sugarsense/core/constants/route_names.dart';
import 'package:sugarsense/core/services/auth_service.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the duration as needed
    );

    // Define the scale animation
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut, // Use Curves.easeInOut here
        )
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    // Start the animation
    _animationController.forward();

    _checkAuthStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      final isLoggedIn = await authService.isLoggedIn();

      if (isLoggedIn) {
        await Future.delayed(const Duration(seconds: 4));
        Navigator.of(context).pushReplacementNamed(RouteNames.bottomNavigation);
      } else {
        await Future.delayed(const Duration(seconds: 4));
        Navigator.of(context).pushReplacementNamed(RouteNames.login);
      }
    } catch (e) {
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
            // Use AnimatedBuilder to apply the animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Image.asset(
                      "assets/images/logo.png",
                      width: 150,
                      height: 150,
                    ),
                  ),
                );
              },
            ),
            Text(
              'SugarSense',
              style: TextStyle(
                color: AppColors.surface(context),
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SpinKitCircle(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
