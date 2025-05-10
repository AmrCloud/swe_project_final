import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/core/constants/route_names.dart';
import 'package:sugarsense/core/presentation/main_wrapper.dart';
import 'package:sugarsense/core/services/app_theme.dart';
import 'package:sugarsense/core/services/calorie_service.dart';
import 'package:sugarsense/features/auth/domain/repositories/auth_repository.dart';
import 'package:sugarsense/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sugarsense/features/auth/presentation/pages/login_page.dart';
import 'package:sugarsense/features/auth/presentation/pages/signup_page.dart';
import 'package:sugarsense/features/home/presentation/pages/home_page.dart';
import 'package:sugarsense/features/logs/presentation/pages/logs.dart';
import 'package:sugarsense/features/splash/presentation/pages/splash_page.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;
  final CalorieService calorieService;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  App({
    super.key,
    required this.authRepository,
    required this.calorieService,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: calorieService,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authRepository),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(
                authRepository: authRepository,
              ),
            ),
          ],
          child: MaterialApp(
            navigatorKey: navigatorKey,
            title: AppConstants.appName,
            theme:lightTheme,
            darkTheme: darkTheme,
            initialRoute: RouteNames.splash,
            routes: {
              RouteNames.splash: (context) => const SplashPage(),
              RouteNames.login: (context) => LoginPage(),
              RouteNames.signup: (context) => RegisterPage(),
              RouteNames.home: (context) => const HomePage(),
              RouteNames.logs: (context) => const Logs(),
              RouteNames.bottomNavigation: (context) => MainWrapper(),
            },
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }
}