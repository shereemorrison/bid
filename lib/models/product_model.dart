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
  final bool isMostWanted;
  final int quantity;
  final Map<String, dynamic>? additionalInfo;
  final String? selectedSize;

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
    this.isMostWanted = false,
    this.quantity = 1, // Default quantity
    this.additionalInfo,
    this.selectedSize,
  });

  // Factory constructor to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['product_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      categoryId: json['category_id'] ?? '',
      isActive: json['is_active'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      imageUrl: json['image_url'] ?? '',
      imagePath: json['image_url'] ?? '',
      isFeatured: json['is_featured'] ?? false,
      quantity: json['quantity'] ?? 1,
      additionalInfo: json['additional_info'],
    );
  }

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? categoryId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    String? imagePath,
    bool? isFeatured,
    int? quantity,
    String? selectedSize,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      imagePath: imagePath ?? this.imagePath,
      isFeatured: isFeatured ?? this.isFeatured,
      quantity: quantity ?? this.quantity,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      selectedSize: selectedSize ?? this.selectedSize,
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
      'is_featured': isFeatured,
      'is_most_wanted': isMostWanted,
    };
  }
}