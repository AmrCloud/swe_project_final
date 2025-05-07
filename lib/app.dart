import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/core/constants/route_names.dart';
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
    Key? key,
    required this.authRepository,
    required this.calorieService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: calorieService),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: authRepository,
            ), // Removed AppStarted event
          ),
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: AppConstants.appName,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: AppConstants.fontFamily,
          ),
          initialRoute: RouteNames.splash,
          routes: {
            RouteNames.splash: (context) => const SplashPage(),
            RouteNames.login: (context) => LoginPage(),
            RouteNames.signup: (context) => RegisterPage(),
            RouteNames.home: (context) => const HomePage(),
            RouteNames.logs: (context) => const Logs(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}