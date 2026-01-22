import 'package:go_router/go_router.dart';
import 'presentation/screens/product_list_screen.dart';

class ProductsRoute {
  static const String productList = '/product-list';

  static List<RouteBase> get productsRoutes => [
        GoRoute(
          path: productList,
          builder: (context, state) => const ProductListScreen(),
        ),
      ];
}