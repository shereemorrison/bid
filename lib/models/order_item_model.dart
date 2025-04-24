class OrderItem {
  final String itemId;
  final String productId;
  final String name;
  final String? variantId;
  final String? variantName;
  final double price;
  final int quantity;
  final String? imageUrl;
  final bool? isReturnable;
  final String? returnStatus;
  bool get isReturned => returnStatus == 'RETURNED';
  bool get isReturnPending => returnStatus == 'PENDING';

  OrderItem({
    required this.itemId,
    required this.productId,
    required this.name,
    this.variantId,
    this.variantName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.isReturnable,
    this.returnStatus,
  });


  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Get product data if available
    final product = json['products'];

    double parsePrice() {
      if (json['unit_price'] != null) {
        return (json['unit_price'] is int)
            ? (json['unit_price'] as int).toDouble()
            : (json['unit_price'] as num).toDouble();
      } else if (json['price'] != null) {
        return (json['price'] is int)
            ? (json['price'] as int).toDouble()
            : (json['price'] as num).toDouble();
      } else if (product != null && product['price'] != null) {
        return (product['price'] is int)
            ? (product['price'] as int).toDouble()
            : (product['price'] as num).toDouble();
      }
      return 0.0;
    }

    return OrderItem(
      itemId: json['order_item_id'] ?? json['id'] ?? 'Unknown',
      productId: json['product_id'] ?? 'Unknown',
      name: json['product_name'] ??
          (product != null ? product['name'] : 'Unknown Product'),
      variantId: json['variant_id'],
      variantName: json['variant_name'] ?? json['size'],
      price: parsePrice(),
      quantity: json['quantity'] ?? 1,
      imageUrl: json['image_url'] ??
          (product != null ? product['image_url'] : null),
      isReturnable: json['is_returnable'] ?? true,
      returnStatus: json['return_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'product_id': productId,
      'name': name,
      'variant_id': variantId,
      'variant_name': variantName,
      'price': price,
      'quantity': quantity,
      'image_url': imageUrl,
      'is_returnable': isReturnable,
      'return_status': returnStatus,
    };
  }
}