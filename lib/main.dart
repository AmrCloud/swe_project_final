import 'package:flutter/material.dart';
import 'package:sugarsense/data/services/app_theme/app_theme.dart';
import 'package:sugarsense/presentation/auth/login_view.dart';
import 'package:sugarsense/presentation/auth/register_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: RegisterPage(),
    );
  }
}
