import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_cubit.dart';
import 'package:paperless_store_upd/core/bloc/global_auth_state.dart';
import 'package:paperless_store_upd/core/constants/route_names.dart'; 
import 'package:paperless_store_upd/core/utils/go_router_refresh_stream.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';

// all screens
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    
    // Refresh logic: Re-runs the redirect whenever Auth status changes
    refreshListenable: GoRouterRefreshStream(sl<GlobalAuthCubit>().stream),
    
    // Centralized Routing Logic 
    redirect: (context, state) {
      final authState = sl<GlobalAuthCubit>().state;
      
      // Get the current location
      final String location = state.matchedLocation;

      // Helper booleans
      final bool isLoggingIn = location == RouteNames.login;
      final bool isRegistering = location == RouteNames.register;
      final bool isSplashing = location == RouteNames.splash;

      //  User is NOT logged in
      if (authState is Unauthenticated) {
        // If they are on Login or Register, let them stay.
        if (isLoggingIn || isRegistering) return null;
        
        // If they are anywhere else (like Splash or Dashboard), force them to Login.
        return RouteNames.login;
      }

      //  User IS logged in
      if (authState is Authenticated) {
        // If they are logged in but trying to go to Login/Register/Splash,
        // stop them and send them to the Dashboard.
        if (isLoggingIn || isRegistering || isSplashing) {
          return RouteNames.dashboard;
        }
      }

      // Default: No redirect needed
      return null;
    },

    // Define the Map of Screens
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
    ],

    // Fallback for 404 errors
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Page not found')),
    ),
  );
}