import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/features/common/presentation/screens/splash_screen.dart';

class CommonRoute {
  static List<GoRoute> commonRoutes = [
    GoRoute(
      path: SplashScreen.route,
      name: SplashScreen.route,
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
  ];
}
