class Product {
  final String name;
  final double price;
  final String description;
  final imagePath;
  int quantity;

  Product({
    required this.name,
    required this.price,
    required this.description,
    required this.imagePath,
    this.quantity = 1,
  });
}
