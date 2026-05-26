import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/dashboard/pages/home_page.dart';
import '../secure_storage.dart/local_storage.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,

    initialLocation: '/home',

    redirect: (context, state) async {
      final token = await SecureStorageService.getToken();

      final isLoggedIn = token != null && token.isNotEmpty;

      final isAuthRoute =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],

    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(
          child: Text(
            'Page Not Found\n${state.uri}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );
}
