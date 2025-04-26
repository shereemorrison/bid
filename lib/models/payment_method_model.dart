class PaymentMethod {
  final String id;
  final String userId;
  final String type;
  final String? cardNumber;
  final String? cardHolderName;
  final String? expiryDate;
  final bool isDefault;
  final Map<String, dynamic>? additionalData;

  PaymentMethod({
    required this.id,
    required this.userId,
    required this.type,
    this.cardNumber,
    this.cardHolderName,
    this.expiryDate,
    this.isDefault = false,
    this.additionalData,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? 'card',
      cardNumber: json['card_number'],
      cardHolderName: json['card_holder_name'],
      expiryDate: json['expiry_date'],
      isDefault: json['is_default'] == true,
      additionalData: json['additional_data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'card_number': cardNumber,
      'card_holder_name': cardHolderName,
      'expiry_date': expiryDate,
      'is_default': isDefault,
      'additional_data': additionalData,
    };
  }

  String get maskedCardNumber {
    if (cardNumber == null || cardNumber!.isEmpty) {
      return '';
    }

    if (cardNumber!.length <= 4) {
      return cardNumber!;
    }

    return '••••${cardNumber!.substring(cardNumber!.length - 4)}';
  }

  String get formattedExpiryDate {
    if (expiryDate == null || expiryDate!.isEmpty) {
      return '';
    }

    return expiryDate!;
  }

  String get displayName {
    switch (type.toLowerCase()) {
      case 'card':
        return '${cardHolderName ?? 'Card'} (${maskedCardNumber})';
      case 'paypal':
        return 'PayPal';
      case 'apple_pay':
        return 'Apple Pay';
      case 'google_pay':
        return 'Google Pay';
      case 'cash_on_delivery':
        return 'Cash on Delivery';
      default:
        return type;
    }
  }
}
