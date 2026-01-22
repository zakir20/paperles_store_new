class ProductModel {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
    );
  }
}