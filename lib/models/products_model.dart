class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String categoryId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;
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
    required this.categoryId,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
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
      categoryId: json['category_id'] ?? '',
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      imageUrl: json['image_url'] ?? '',
      imagePath: json['image_url'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      quantity: json['quantity'] ?? 1,
      additionalInfo: json['additional_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': id,
      'name': name,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'image_url': imageUrl,
    };
  }

  // Create a copy of this product with a new quantity
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      name: name,
      price: price,
      description: description,
      categoryId: categoryId,
      isActive: isActive,
      createdAt: createdAt,
      imageUrl: imageUrl,
      imagePath: imagePath,
      isFeatured: isFeatured,
      quantity: quantity ?? this.quantity,
      additionalInfo: additionalInfo,
    );
  }
}

