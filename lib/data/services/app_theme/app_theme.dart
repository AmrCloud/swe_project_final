import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFF1976D2), 
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF1976D2),
    secondary: Color(0xFF00ACC1),
    surface: Color(0xFFFFFFFF),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFF212121),
    error: Color(0xFFE53935),
    onError: Color(0xFFFFFFFF),
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F5F5),
  cardColor: const Color(0xFFFFFFFF),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF212121)),
    bodyMedium: TextStyle(color: Color(0xFF616161)),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF90CAF9), 
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF90CAF9),
    secondary: Color(0xFF4DD0E1),
    surface: Color(0xFF1E1E1E),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onSurface: Color(0xFFFFFFFF),
    error: Color(0xFFEF9A9A),
    onError: Color(0xFF000000),
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  cardColor: const Color(0xFF1E1E1E),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
    bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
  ),
);
