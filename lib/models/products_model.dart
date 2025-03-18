class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String category;
  final String imageUrl;
  final String imagePath;
  final bool isFeatured;
  final int quantity;
  final Map<String, dynamic>? additionalInfo;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.imagePath = '', // Default value
    this.isFeatured = false,
    this.quantity = 1, // Default quantity
    this.additionalInfo,
  });

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(
      id: json['product_id'].toString(),
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      imageUrl: json['image_url'] ?? '',
      imagePath: json['image_url'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      quantity: json['quantity'] ?? 1,
      additionalInfo: json['additional_info'],
    );
  }

  // Create a copy of this product with a new quantity
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      description: description,
      category: category,
      imageUrl: imageUrl,
      imagePath: imagePath,
      isFeatured: isFeatured,
      quantity: quantity ?? this.quantity,
      additionalInfo: additionalInfo,
    );
  }
}

