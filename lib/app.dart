import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sugarsense/core/constants/app_constants.dart';
import 'package:sugarsense/features/auth/domain/repositories/auth_repository.dart';
import 'core/constants/route_names.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  final AuthRepository authRepository;
  
  // Create a single navigator key at the class level
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  App({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: authRepository),
        ),
      ],
      child: MaterialApp(
        // Assign the navigator key here
        navigatorKey: navigatorKey,
        title: AppConstants.appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: AppConstants.fontFamily,
        ),
        initialRoute: RouteNames.splash,
        routes: {
          RouteNames.login: (context) => LoginPage(),
          // Add other routes as needed:
          // RouteNames.splash: (context) => const SplashPage(),
          // RouteNames.signup: (context) => SignupPage(),
          // RouteNames.home: (context) => const HomePage(),
        },
      ),
    );
  }
}