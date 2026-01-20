import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/features/auth/presentation/screens/login_screen.dart';

class AuthRoute {
  static List<GoRoute> authRoutes = [
    GoRoute(
      path: LoginScreen.route,
      name: LoginScreen.route,
      builder: (context, state) {
        return const LoginScreen();
      },
    ),
  ];
}
