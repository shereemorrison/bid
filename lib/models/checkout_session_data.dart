import 'package:flutter_riverpod/flutter_riverpod.dart';

// Data model for storing checkout session information
class CheckoutSessionData {
  final String sessionId;
  final Map<String, dynamic> shippingAddress;
  final String? userId;
  final bool isGuestCheckout;
  final DateTime createdAt;

  CheckoutSessionData({
    required this.sessionId,
    required this.shippingAddress,
    this.userId,
    required this.isGuestCheckout,
    required this.createdAt,
  });

  // Create a copy with updated fields
  CheckoutSessionData copyWith({
    String? sessionId,
    Map<String, dynamic>? shippingAddress,
    String? userId,
    bool? isGuestCheckout,
    DateTime? createdAt,
  }) {
    return CheckoutSessionData(
      sessionId: sessionId ?? this.sessionId,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      userId: userId ?? this.userId,
      isGuestCheckout: isGuestCheckout ?? this.isGuestCheckout,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Provider for checkout session data
final checkoutSessionProvider = StateProvider<CheckoutSessionData?>((ref) => null);
