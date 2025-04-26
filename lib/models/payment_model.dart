
class PaymentMethod {
  final String id;
  final String userId;
  final String type; // TODO - Add types
  final String name; // e.g., 'Visa ending in 1234'
  final bool isDefault;
  final Map<String, dynamic>? details; //
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    required this.name,
    this.isDefault = false,
    this.details,
    this.createdAt,
    this.updatedAt,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? json['payment_method_id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      isDefault: json['is_default'] == true || json['is_default'] == 'true',
      details: json['details'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'name': name,
      'is_default': isDefault,
      'details': details,
    };
  }
}