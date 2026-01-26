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
  
  int currentPage = 1; 
  int totalPages = 1;
  String currentCategory = "All"; 
  String currentQuery = "";

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final List<dynamic> data = json.decode(response);
      _allProducts = data.map((e) => ProductModel.fromJson(e)).toList();
      
      _filteredMaster = List.from(_allProducts);
      _applyLogic(); 
    } catch (e) {
      emit(const ProductError("Failed to load products"));
    }
  }

  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    currentPage = page;
    _applyLogic();
  }

  void applySearchAndFilter({String? query, String? category}) {
    if (query != null) currentQuery = query.toLowerCase();
    if (category != null) currentCategory = category;

    _filteredMaster = _allProducts.where((p) {
      final matchesName = p.name.toLowerCase().contains(currentQuery);
      final matchesCat = currentCategory == "All" || p.category == currentCategory;
      return matchesName && matchesCat;
    }).toList();

    currentPage = 1; 
    _applyLogic();
  }

  void _applyLogic() {
    totalPages = (_filteredMaster.length / _pageSize).ceil();
    if (totalPages == 0) totalPages = 1;

    int startIndex = (currentPage - 1) * _pageSize;
    final pageItems = _filteredMaster.skip(startIndex).take(_pageSize).toList();

    emit(ProductLoaded(
      products: pageItems, 
      hasReachedMax: currentPage == totalPages,
    ));
  }
}