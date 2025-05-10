import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugarsense/core/services/consumed_food_service.dart';
import 'package:sugarsense/core/services/food_service.dart';
import 'package:sugarsense/features/auth/domain/repositories/auth_repository.dart';
import 'app.dart';
import 'core/services/auth_service.dart';
import 'core/services/calorie_service.dart';
import 'core/services/local_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(sharedPrefs);
  final authService = AuthService();
  final authRepository = AuthRepositoryImpl(localStorage: localStorage);
  final foodService = FoodService(authService);
  final consumedFoodService = ConsumedFoodService(authService);
  final calorieService = CalorieService(authService);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>.value(value: authRepository),
        Provider<AuthService>.value(value: authService),
        Provider<FoodService>.value(value: foodService),
        Provider<ConsumedFoodService>.value(value: consumedFoodService),
      ],
      child: App(
        authRepository: authRepository,
        calorieService: calorieService, 
      ),
    ),
  );
}
