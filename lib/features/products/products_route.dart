import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';
import 'presentation/bloc/product_cubit.dart';
import 'presentation/screens/product_list_screen.dart';

class ProductsRoute {
  static List<GoRoute> productsRoutes = [
    GoRoute(
      path: ProductListScreen.route,
      builder: (context, state) => BlocProvider(
        create: (context) => sl<ProductCubit>(), 
        child: const ProductListScreen(),
      ),
    ),
  ];
}