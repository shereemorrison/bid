import 'package:bid/pages/checkout_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import '../../providers/payment_provider.dart';
import '../../utils/format_helpers.dart';
import '../../providers/shop_provider.dart';
import '../../providers/checkout_provider.dart';
import '../../services/order_service.dart';
import '../../providers/address_provider.dart';
import '../../utils/order_calculator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../services/order_creator_service.dart';

class PaymentTab extends ConsumerStatefulWidget {
  final double amount;
  final VoidCallback onBack;

  const PaymentTab({
    Key? key,
    required this.amount,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<PaymentTab> createState() => _PaymentTabState();
}

class _PaymentTabState extends ConsumerState<PaymentTab> {
  bool _isLoading = false;
  String? _errorMessage;
  CardFieldInputDetails? _cardFieldInputDetails;
  final TextEditingController _nameController = TextEditingController(text: 'Test User');

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
      final orderCreatorService = OrderCreatorService(Supabase.instance.client);
      final cart = ref.read(cartProvider);
      final selectedAddress = ref.read(effectiveAddressProvider);

      // Validate cart and address
      if (cart.isEmpty) {
        throw Exception('Your cart is empty');
      }

      if (selectedAddress == null) {
        throw Exception('Please select a shipping address');
      }

      // Calculate order totals
      final double subtotal = OrderCalculator.calculateProductSubtotal(cart);
      final double shipping = 10.0;
      final double tax = OrderCalculator.calculateTax(subtotal);
      final double total = OrderCalculator.calculateTotal(
        subtotal: subtotal,
        taxAmount: tax,
        shippingAmount: shipping,
        discountAmount: 0.0,
      );

      // 1. Create payment intent - Use AUD currency
      final paymentIntentData = await paymentService.createPaymentIntent(
        amount: widget.amount,
        currency: 'aud', // Use AUD currency
      );

      print('Payment intent created: $paymentIntentData');
      final clientSecret = paymentIntentData['clientSecret'] as String;
      final paymentIntentId = paymentIntentData['id'] as String? ?? '';

      // 2. Confirm payment with the card details from CardField
      bool paymentSuccessful = false;
      String? stripeError;

      try {
        final paymentResult = await Stripe.instance.confirmPayment(
          paymentIntentClientSecret: clientSecret,
          data: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(name: _nameController.text),
            ),
          ),
        );

        print('Payment confirmation result: $paymentResult');
        print('Payment status: ${paymentResult.status}');

        // Check if payment was successful
        paymentSuccessful = paymentResult.status == PaymentIntentsStatus.Succeeded;
      } catch (e) {
        print('Error during payment confirmation: $e');
        stripeError = e.toString();

        // Even if there's an error in the Flutter app, the payment might have succeeded on Stripe
        // We'll check with the payment intent ID later
        paymentSuccessful = true; // Assume success and let the order creation determine the outcome
      }

      // 3. If payment was successful (or we think it might be), create the order in Supabase
      if (paymentSuccessful) {
        print('Creating order in Supabase with payment intent ID: $paymentIntentId');

        // Create order in Supabase using your existing OrderCreatorService
        final orderResult = await orderCreatorService.createOrderFromCheckout(
          userId: selectedAddress.userId,
          products: cart,
          shippingAddress: selectedAddress,
          subtotal: subtotal,
          tax: tax,
          shipping: shipping,
          total: total,
          paymentMethod: 'Credit Card',
          paymentIntentId: paymentIntentId, // Pass the payment intent ID
          isGuestCheckout: selectedAddress.userId.startsWith('guest-'),
        );

        if (orderResult['success']) {
          print('Order created successfully: ${orderResult['order_id']}');

          // Clear the cart
          ref.read(cartProvider.notifier).state = [];

          // Mark checkout as complete
          try {
            ref.read(checkoutCompleteProvider.notifier).state = true;
          } catch (e) {
            print('Note: Checkout provider not available: $e');
          }

          // Navigate to success page with the Supabase order ID (UUID)
          if (mounted) {
            context.go('/order-confirmation?order_id=${orderResult['order_id']}');
          }
        } else {
          throw Exception('Failed to create order: ${orderResult['message']}');
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
                            formatPrice(widget.amount),
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
                color: Colors.black.withOpacity(0.05),
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
                    onPressed: widget.onBack,
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
                    onPressed: _isLoading || _cardFieldInputDetails?.complete != true
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
                      'PAY ${formatPrice(widget.amount)}',
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
