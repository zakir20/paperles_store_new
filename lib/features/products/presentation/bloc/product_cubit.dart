import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  List<ProductModel> _allProducts = [];      
  List<ProductModel> _filteredMaster = [];  
  final int _pageSize = 15;                  
  
  String currentCategory = "All";
  String _currentQuery = "";

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);
      
      _allProducts = data.map((e) => ProductModel.fromJson(e)).toList();
      _filteredMaster = List.from(_allProducts);

      final firstPage = _filteredMaster.take(_pageSize).toList();
      
      print("DEBUG: Loading first page. Items: ${firstPage.length}");

      emit(ProductLoaded(
        products: firstPage, 
        hasReachedMax: firstPage.length >= _filteredMaster.length
      ));
    } catch (e) {
      emit(const ProductError("Failed to load products"));
    }
  }

  void fetchNextPage() {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (currentState.hasReachedMax) return;

      int currentVisibleCount = currentState.products.length;
      
      final nextBatch = _filteredMaster.skip(currentVisibleCount).take(_pageSize).toList();

      if (nextBatch.isEmpty) {
        emit(ProductLoaded(products: currentState.products, hasReachedMax: true));
      } else {
        print("DEBUG: Loading next batch. Total visible now: ${currentVisibleCount + nextBatch.length}");
        emit(ProductLoaded(
          products: currentState.products + nextBatch, 
          hasReachedMax: (currentVisibleCount + nextBatch.length) >= _filteredMaster.length,
        ));
      }
    }
  }

  void applySearchAndFilter({String? query, String? category}) {
    if (query != null) _currentQuery = query.toLowerCase();
    if (category != null) currentCategory = category;

    _filteredMaster = _allProducts.where((p) {
      final matchesName = p.name.toLowerCase().contains(_currentQuery);
      final matchesCat = currentCategory == "All" || p.category == currentCategory;
      return matchesName && matchesCat;
    }).toList();

    final firstPage = _filteredMaster.take(_pageSize).toList();
    emit(ProductLoaded(products: firstPage, hasReachedMax: firstPage.length >= _filteredMaster.length));
  }
}