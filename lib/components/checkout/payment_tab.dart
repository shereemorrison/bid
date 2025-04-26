import 'package:bid/models/address_model.dart' as app_models;
import 'package:bid/providers.dart';
import 'package:bid/respositories/payment_repository.dart';
import 'package:bid/utils/format_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod; // Alias to avoid conflict
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import '../../utils/order_calculator.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Provider; // Hide Provider from Supabase


final paymentServiceProvider = riverpod.Provider<PaymentRepository>((ref) {
  return ref.watch(paymentRepositoryProvider);
});

final effectiveAddressProvider = riverpod.Provider<app_models.Address?>((ref) {
  return ref.watch(selectedAddressProvider);
});

final checkoutCompleteProvider = riverpod.StateProvider<bool>((ref) {
  return false;
});

class PaymentTab extends riverpod.ConsumerStatefulWidget {
  final double amount;
  final VoidCallback onBack;

  const PaymentTab({
    Key? key,
    required this.amount,
    required this.onBack,
  }) : super(key: key);

  @override
  riverpod.ConsumerState<PaymentTab> createState() => _PaymentTabState();
}

class _PaymentTabState extends riverpod.ConsumerState<PaymentTab> {
  bool _isLoading = false;
  String? _errorMessage;
  CardFieldInputDetails? _cardFieldInputDetails;
  final TextEditingController _nameController = TextEditingController(text: 'Test User');
  bool _isNavigating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _setLoading(bool isLoading) {
    if (mounted) {
      setState(() {
        _isLoading = isLoading;
      });
    }
  }

  void _setErrorMessage(String? errorMessage) {
    if (mounted) {
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }

  Future<void> _handlePayment() async {
    // Prevent multiple payment attempts
    if (_isLoading || _isNavigating) return;

    final isLoggedIn = ref.read(isLoggedInProvider);

    // Validate inputs
    if (_nameController.text.isEmpty) {
      _setErrorMessage('Please enter the name on the card');
      return;
    }

    if (_cardFieldInputDetails == null || !_cardFieldInputDetails!.complete) {
      _setErrorMessage('Please enter valid card details');
      return;
    }

    _setLoading(true);
    _setErrorMessage(null);

    try {
      final paymentService = ref.read(paymentServiceProvider);
      final cartState = ref.read(cartProvider);
      final selectedAddress = ref.read(effectiveAddressProvider);

      // Validate cart and address
      if (cartState.items.isEmpty) {
        throw Exception('Your cart is empty');
      }

      if (selectedAddress == null) {
        throw Exception('Please select a shipping address');
      }

      // Verify the address has a valid ID
      if (selectedAddress.id.isEmpty || selectedAddress.id == 'new') {
        throw Exception('Invalid shipping address. Please go back and select a valid address.');
      }

      // Calculate order totals
      final cartItems = cartState.items;
      final products = cartItems.map((item) => item.product).toList();

      // Calculate these values here
      final double subtotal = OrderCalculator.calculateProductSubtotal(products);
      final double shipping = 10.0;
      final double tax = OrderCalculator.calculateTax(subtotal);
      final double total = OrderCalculator.calculateTotal(
        subtotal: subtotal,
        taxAmount: tax,
        shippingAmount: shipping,
        discountAmount: 0.0,
      );

      // Create payment intent
      final paymentIntentData = await paymentService.createPaymentIntent(
        amount: widget.amount,
        currency: 'aud',
      );

      print('Payment intent created: $paymentIntentData');
      final clientSecret = paymentIntentData['clientSecret'] as String;
      final paymentIntentId = paymentIntentData['id'] as String? ?? '';

      // Confirm payment with the card details from CardField
      bool paymentSuccessful = false;
      String? stripeError;

      try {
        final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(
                name: _nameController.text,
              ),
            ),
          ),
        );

        final paymentResult = await Stripe.instance.confirmPayment(
          paymentIntentClientSecret: clientSecret,
          data: PaymentMethodParams.cardFromMethodId(
            paymentMethodData: PaymentMethodDataCardFromMethod(
              paymentMethodId: paymentMethod.id,
            ),
          ),
          options: const PaymentMethodOptions(
            setupFutureUsage: PaymentIntentsFutureUsage.OffSession,
          ),
        );

        print('Payment confirmation result: $paymentResult');
        print('Payment status: ${paymentResult.status}');

        // Check if payment was successful
        paymentSuccessful = paymentResult.status == PaymentIntentsStatus.Succeeded;
      } catch (e) {
        print('Error during payment confirmation: $e');
        stripeError = e.toString();

        paymentSuccessful = true; // Assume payment success true and let order creation determine outcome
      }

      // Create order in Supabase
      if (paymentSuccessful) {
        print('Creating order in Supabase with payment intent ID: $paymentIntentId');

        try {
          final orderData = {
            'user_id': selectedAddress.userId,
            'payment_intent_id': paymentIntentId,
            'status': 'PENDING',
            'subtotal': subtotal,
            'tax_amount': tax,
            'shipping_amount': shipping,
            'discount_amount': 0.0,
            'total_amount': total,
            'shipping_address_id': selectedAddress.id,
            'billing_address_id': selectedAddress.id, // You might want to use a different address if available
            'shipping_method': 'Standard',
            'order_number': 'ORD-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}${DateTime.now().day.toString().padLeft(2, '0')}-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
            'placed_at': DateTime.now().toIso8601String(),
          };

          // Insert the order and get the real UUID back
          final orderResult = await Supabase.instance.client
              .from('orders')
              .insert(orderData)
              .select('order_id')
              .single();

          final orderId = orderResult['order_id'];
          print('Order created successfully with real UUID: $orderId');

          // Create order payment record - Using payment_intent_id as the primary key
          await Supabase.instance.client
              .from('order_payments')
              .insert({
            'order_id': orderId,
            'payment_intent_id': paymentIntentId,
            'amount': total,
            'is_refund': false,
            'created_at': DateTime.now().toIso8601String(),
          });
          print('Order payment record created with payment_intent_id: $paymentIntentId');

          // Insert order items
          final orderItems = cartItems.map((item) => {
            'order_id': orderId,
            'product_id': item.productId,
            'variant_id': null, // No variant - TODO - connect product_variants table
            'product_name': item.name,
            'variant_name': item.selectedSize ?? 'Default', // Use selectedSize from options or default
            'sku': 'SKU-${item.productId.substring(0, 8)}', // TODO - take SKU from product_variants table once implemented. For now, just using a generate a SKU from product ID
            'quantity': item.quantity,
            'unit_price': item.price,
            'subtotal': item.price * item.quantity,
            'discount_amount': 0.0,
            'tax_amount': (item.price * item.quantity) * 0.1, // 10% tax TODO - confirm with Stefan how he wants this displayed
            'total': (item.price * item.quantity) * 1.1, // Price + tax
            'created_at': DateTime.now().toIso8601String(),
          }).toList();

          await Supabase.instance.client
              .from('order_items')
              .insert(orderItems);

          print('Order items created successfully');

          // Clear the cart
          ref.read(cartProvider.notifier).clearCart();

          // Reset checkout state
          ref.read(checkoutProvider.notifier).reset();

          // Mark checkout as complete
          try {
            ref.read(checkoutCompleteProvider.notifier).state = true;
          } catch (e) {
            print('Note: Checkout provider not available: $e');
          }

          // Prevent multiple navigations
          if (_isNavigating) return;
          _isNavigating = true;

          // Navigate to success page with Supabase order ID (UUID)
          if (mounted) {
            // Delay before navigation to allow Stripe widget to clean up
            await Future.delayed(const Duration(milliseconds: 300));

            // Check mounted again and navigate
            if (mounted) {
              context.go('/order-confirmation?order_id=$orderId');
            }
          }
        } catch (e) {
          print('Error creating order: $e');
          throw Exception('Failed to create order: $e');
        }
      } else {
        throw Exception('Payment failed: ${stripeError ?? "Unknown error"}');
      }
    } catch (e) {
      print('Payment error: $e');

      if (e is StripeException) {
        print('Stripe error code: ${e.error.code}');
        print('Stripe error message: ${e.error.message}');
        print('Stripe error decline code: ${e.error.declineCode}');
        _setErrorMessage('Payment failed: ${e.error.message}');
      } else {
        _setErrorMessage('Payment failed: ${e.toString()}');
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Main content - scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment details title
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 24),

                // Name on card field
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name on Card',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  style: TextStyle(color: colorScheme.primary),
                ),

                const SizedBox(height: 24),

                // Card details label
                Text(
                  'Card Information',
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 8),

                // Stripe CardField
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CardField(
                    onCardChanged: (details) {
                      setState(() {
                        _cardFieldInputDetails = details;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Test card info
                const Text(
                  'For testing, use card number: 4242 4242 4242 4242, any future date, and any CVC',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                const SizedBox(height: 24),

                // Order summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          Text(
                            formatPrice(widget.amount), // Use imported formatPrice
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Error message (if any)
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Security note
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, size: 16, color: Colors.grey),
                    SizedBox(width: 8),
                    Text(
                      'Payments are secure and encrypted',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Bottom buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Back button
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: _isLoading || _isNavigating ? null : widget.onBack,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Pay button
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading || _isNavigating || _cardFieldInputDetails?.complete != true
                        ? null
                        : _handlePayment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
                      ),
                    )
                        : Text(
                      'PAY ${formatPrice(widget.amount)}', // Use imported formatPrice
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
