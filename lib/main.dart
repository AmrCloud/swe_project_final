import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/services/local_storage.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final sharedPrefs = await SharedPreferences.getInstance();
  final localStorage = LocalStorage(sharedPrefs);
  final authRepository = AuthRepositoryImpl(localStorage: localStorage);

  runApp(App(authRepository: authRepository));
}