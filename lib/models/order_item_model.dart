class OrderItem {
  final String itemId;
  final String productId;
  final String productName;
  final String? variantId;
  final String? variantName;
  final double price;
  final int quantity;
  final String? imageUrl;
  final bool? isReturnable;
  final String? returnStatus;

  OrderItem({
    required this.itemId,
    required this.productId,
    required this.productName,
    this.variantId,
    this.variantName,
    required this.price,
    required this.quantity,
    this.imageUrl,
    this.isReturnable,
    this.returnStatus,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Debug the incoming JSON
    print('OrderItem.fromJson: $json');

    // Get product data if available
    final product = json['products'];

    return OrderItem(
      itemId: json['order_item_id'] ?? json['id'] ?? 'Unknown',
      productId: json['product_id'] ?? 'Unknown',
      productName: json['product_name'] ?? (product != null ? product['name'] : 'Unknown Product'),
      variantId: json['variant_id'],
      variantName: json['variant_name'] ?? json['size'],
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: json['image_url'] ?? (product != null ? product['image_url'] : null),
      isReturnable: json['is_returnable'] ?? true,
      returnStatus: json['return_status'],
    );
  }
}