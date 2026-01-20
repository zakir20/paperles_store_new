import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/features/auth/auth_route.dart';
import 'package:paperless_store_upd/features/common/common_route.dart';
import 'package:paperless_store_upd/features/common/presentation/screens/splash_screen.dart';
import 'package:paperless_store_upd/features/dashboard/dashboard_route.dart';

class AppRouter {
  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static GoRouter get router => _router;

  static final _router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: SplashScreen.route,
    debugLogDiagnostics: kDebugMode,
    routes: [
      ...CommonRoute.commonRoutes,
      ...DashboardRoute.dashBoardRoutes,
      ...AuthRoute.authRoutes,
    ],
    errorBuilder: (context, state) {
      return ErrorWidget(state.error.toString());
    },
    redirect: (context, state) {
      return null;
    },
  );

  static void go(
    BuildContext context,
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      context.goNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Navigation error: $e');
      }
      context.go(SplashScreen.route);
    }
  }

  static void replace(
    BuildContext context,
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      context.replaceNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Replace error: $e');
      }
      context.go('/');
    }
  }

  static void push(BuildContext context, String path, {Object? extra}) {
    try {
      context.push(path, extra: extra);
    } catch (e) {
      if (kDebugMode) {
        print('Push error: $e');
      }
    }
  }

  static void pushNamed(
    BuildContext context,
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) {
    try {
      context.pushNamed(
        name,
        pathParameters: pathParameters,
        queryParameters: queryParameters,
        extra: extra,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Push named error: $e');
      }
    }
  }

  static void pop(BuildContext context, {Object? result}) {
    if (context.canPop()) {
      context.pop(result);
    } else {
      if (kDebugMode) {
        print('Cannot pop, navigating to home');
      }
      context.go(SplashScreen.route);
    }
  }

  static void goHome(BuildContext context) {
    context.go(SplashScreen.route);
  }

  static bool canPop(BuildContext context) {
    return context.canPop();
  }

  static String currentLocation(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (kDebugMode) {
      print('Current location: $location');
    }
    return location;
  }

  static void popOrGoHome(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      goHome(context);
    }
  }
}
