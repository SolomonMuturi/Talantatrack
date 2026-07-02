class Product {
  final String id;
  final String name;
  final double price;
  final double cost;
  final int sales;
  final int stock;
  final int lowStockThreshold;
  final String? image;
  final String? description;
  final String category;
  final List<String> sizes;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.cost,
    required this.sales,
    required this.stock,
    required this.lowStockThreshold,
    this.image,
    this.description,
    required this.category,
    required this.sizes,
  });
}
