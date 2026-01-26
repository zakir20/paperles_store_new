import 'package:equatable/equatable.dart';
import '../../data/models/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}
class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final bool hasReachedMax; 

  const ProductLoaded({required this.products, required this.hasReachedMax});

  @override
  List<Object?> get props => [products, hasReachedMax];
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);
}