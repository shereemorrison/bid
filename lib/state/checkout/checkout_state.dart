import 'package:flutter/foundation.dart';
import '../../models/address_model.dart';
import '../../models/payment_method_model.dart';
import '../cart/cart_state.dart';

enum CheckoutStep {
  cart,
  shipping,
  payment,
  confirmation
}

@immutable
class CheckoutState {
  final CheckoutStep currentStep;
  final List<CartItem> items;
  final Address? shippingAddress;
  final PaymentMethod? paymentMethod;
  final String? orderId;
  final bool isLoading;
  final String? error;
  final bool isGuestCheckout;

  const CheckoutState({
    this.currentStep = CheckoutStep.cart,
    this.items = const [],
    this.shippingAddress,
    this.paymentMethod,
    this.orderId,
    this.isLoading = false,
    this.error,
    this.isGuestCheckout = false,
  });

  double get subtotal => items.fold(
      0, (sum, item) => sum + (item.price * item.quantity));

  double get tax => subtotal * 0.08; // 8% tax rate

  double get shipping => 10.0; // Flat shipping rate

  double get total => subtotal + tax + shipping;

  CheckoutState copyWith({
    CheckoutStep? currentStep,
    List<CartItem>? items,
    Address? shippingAddress,
    PaymentMethod? paymentMethod,
    String? orderId,
    bool? isLoading,
    String? error,
    bool? isGuestCheckout,
    bool clearError = false,
  }) {
    return CheckoutState(
      currentStep: currentStep ?? this.currentStep,
      items: items ?? this.items,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      orderId: orderId ?? this.orderId,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isGuestCheckout: isGuestCheckout ?? this.isGuestCheckout,
    );
  }

  factory CheckoutState.initial() {
    return const CheckoutState(
      currentStep: CheckoutStep.cart,
      items: [],
      isLoading: false,
      error: null,
      isGuestCheckout: false,
    );
  }
}
