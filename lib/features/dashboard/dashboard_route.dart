import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/features/dashboard/presentation/screens/dashboard_screen.dart';

class DashboardRoute {
  static List<GoRoute> dashBoardRoutes = [
    GoRoute(
      path: DashboardScreen.route,
      name: DashboardScreen.route,
      builder: (context, state) {
        return const DashboardScreen();
      },
    ),
  ];
}
