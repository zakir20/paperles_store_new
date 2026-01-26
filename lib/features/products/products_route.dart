import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:paperless_store_upd/injection/injection_container.dart';
import 'package:paperless_store_upd/core/constants/route_names.dart';
import 'presentation/bloc/product_cubit.dart';
import 'presentation/screens/product_list_screen.dart';

class ProductsRoute {
  static const String productList = '/product-list'; 

  static List<RouteBase> get productsRoutes => [
        GoRoute(
          path: productList,
          builder: (context, state) => BlocProvider<ProductCubit>( 
            create: (context) => sl<ProductCubit>(),
            child: const ProductListScreen(), 
          ),
        ),
      ];
}