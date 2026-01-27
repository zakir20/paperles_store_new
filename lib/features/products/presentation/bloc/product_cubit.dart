import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/models/product_model.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository productRepository;

  ProductCubit({required this.productRepository}) : super(ProductInitial());

  List<ProductModel> _allProducts = [];      
  List<ProductModel> _filteredMaster = [];  
  List<ProductModel> _displayedProducts = []; 
  
  final int _pageSize = 15; 
  int currentPage = 1; 
  int totalPages = 1;
  String currentCategory = "All"; 
  String currentQuery = "";

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      _allProducts = await productRepository.getProducts();
      _filteredMaster = List.from(_allProducts);
      _displayedProducts = []; 
      currentPage = 1;
      _applyLogic(); 
    } catch (e) {
      emit(const ProductError("Failed to load products"));
    }
  }

  void loadMoreProducts() {
    if (state is! ProductLoaded || currentPage >= totalPages) return;
    currentPage++;
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
    _displayedProducts = []; 
    _applyLogic();
  }

  void _applyLogic() {
    totalPages = (_filteredMaster.length / _pageSize).ceil();
    if (totalPages == 0) totalPages = 1;

    int startIndex = (currentPage - 1) * _pageSize;
    final newItems = _filteredMaster.skip(startIndex).take(_pageSize).toList();

    _displayedProducts.addAll(newItems);

    emit(ProductLoaded(
      products: List.from(_displayedProducts), 
      hasReachedMax: currentPage >= totalPages,
    ));
  }
}