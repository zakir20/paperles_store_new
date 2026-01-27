import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<ProductModel>> getProducts() async {
    final String response = await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> data = json.decode(response);
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}