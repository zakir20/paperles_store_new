import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);
      final products = data.map((e) => ProductModel.fromJson(e)).toList();
      
      emit(ProductLoaded(products));
    } catch (e) {
      emit(const ProductError("Could not load products"));
    }
  }
}