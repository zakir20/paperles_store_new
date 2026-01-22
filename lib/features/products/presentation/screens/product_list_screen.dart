import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart'; 
import 'package:paperless_store_upd/core/theme/app_colors.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_state.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..loadProducts(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.cardWhite,
          title: Text("product_list".tr()), 
          elevation: 0.5,
          iconTheme: const IconThemeData(color: AppColors.black),
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              if (state.products.isEmpty) {
                return Center(child: Text("no_products".tr())); 
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(product.category),
                    trailing: Text("TK ${product.price}"),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("no_products".tr())); 
          },
        ),
      ),
    );
  }
}