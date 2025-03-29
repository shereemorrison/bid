class OrderItem {
  final String productId;
  final String productName;
  final String? imageUrl;
  final String color;
  final String size;
  final int quantity;
  final double unitPrice;

  OrderItem({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.color,
    required this.size,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    String productName = 'Unknown Product';
    String? imageUrl;
    if (json['product'] != null && json['product'] is Map) {
      productName = json['product']['name'] ?? 'Unknown Product';
      imageUrl = json['product']['image_url'];
    }

    String colorName = 'Default';
    if (json['color'] != null && json['color'] is Map) {
      colorName = json['color']['name'] ?? 'Default';
    }

    String sizeName = 'One Size';
    if (json['size'] != null && json['size'] is Map) {
      sizeName = json['size']['name'] ?? 'One Size';
    }

    return OrderItem(
      productId: json['product_id'] ?? '',
      productName: productName,
      imageUrl: imageUrl,
      color: colorName,
      size: sizeName,
      quantity: json['quantity'] ?? 1,
      unitPrice: json['unit_price']?.toDouble() ?? 0.0,
    );
  }
}