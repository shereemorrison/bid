import 'package:bid/models/address_model.dart';
import 'package:bid/models/payment_method_model.dart';
import 'package:bid/state/cart/cart_state.dart';
import 'package:flutter/foundation.dart';
import '../base/base_state.dart';

enum CheckoutStep {
  cart,
  shipping,
  payment,
  confirmation,
  success,
}

@immutable
class CheckoutState extends BaseState {
  final CheckoutStep currentStep;
  final List<CartItem> items;
  final Address? shippingAddress;
  final PaymentMethod? paymentMethod;
  final String? orderId;
  final bool isGuestCheckout;
  final String? guestEmail;
  final String? guestOrderId;
  final bool isOrderSavedLocally;

  const CheckoutState({
    this.currentStep = CheckoutStep.cart,
    this.items = const [],
    this.shippingAddress,
    this.paymentMethod,
    this.orderId,
    bool isLoading = false,
    String? error,
    this.isGuestCheckout = false,
    this.guestEmail,
    this.guestOrderId,
    this.isOrderSavedLocally = false,
  }) : super(isLoading: isLoading, error: error);

  double get subtotal => items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get tax => subtotal * 0.08; // 8% tax rate
  double get shipping => 10.0; // Flat shipping rate
  double get total => subtotal + tax + shipping;

  @override
  CheckoutState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return CheckoutState(
      currentStep: currentStep,
      items: items,
      shippingAddress: shippingAddress,
      paymentMethod: paymentMethod,
      orderId: orderId,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isGuestCheckout: isGuestCheckout,
      guestEmail: guestEmail,
      guestOrderId: guestOrderId,
      isOrderSavedLocally: isOrderSavedLocally,
    );
  }

  CheckoutState copyWith({
    CheckoutStep? currentStep,
    List<CartItem>? items,
    Address? shippingAddress,
    PaymentMethod? paymentMethod,
    String? orderId,
    bool? isLoading,
    String? error,
    bool? isGuestCheckout,
    String? guestEmail,
    String? guestOrderId,
    bool? isOrderSavedLocally,
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
      guestEmail: guestEmail ?? this.guestEmail,
      guestOrderId: guestOrderId ?? this.guestOrderId,
      isOrderSavedLocally: isOrderSavedLocally ?? this.isOrderSavedLocally,
    );
  }

  factory CheckoutState.initial() {
    return const CheckoutState(
      currentStep: CheckoutStep.cart,
      items: [],
      isLoading: false,
      error: null,
      isGuestCheckout: false,
      isOrderSavedLocally: false,
    );
  }
}
