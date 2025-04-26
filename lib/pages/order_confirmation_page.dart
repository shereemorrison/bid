import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/components/cart_widgets/empty_state.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/order_confirmation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// State provider for order details
final orderDetailsProvider = StateProvider.family<Map<String, dynamic>?, String?>((ref, orderId) => null);

class OrderConfirmationPage extends ConsumerStatefulWidget {
  final String? orderId;

  const OrderConfirmationPage({
    Key? key,
    this.orderId,
  }) : super(key: key);

  @override
  ConsumerState<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends ConsumerState<OrderConfirmationPage> {
  bool _isLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _orderDetails;
  bool _hasNavigatedAway = false;

  @override
  void initState() {
    super.initState();
    print('OrderConfirmationPage initialized with orderId: ${widget.orderId}');
    _loadOrderDetails();

    // Clear the cart immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderConfirmationHelper.clearCartAndCheckoutState(ref);
    });
  }

  @override
  void dispose() {
    if (!_hasNavigatedAway) {
      try {
        ref.read(cartProvider.notifier).clearCart();
      } catch (e) {
        print('Error clearing cart in dispose: $e');
      }
    }
    super.dispose();
  }

  Future<void> _loadOrderDetails() async {
    if (widget.orderId == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No order ID provided';
      });
      return;
    }

    try {
      print('Loading order details for ID: ${widget.orderId}');
      final orderQueryService = OrderQueryService(Supabase.instance.client);

      // Try to get order details
      Map<String, dynamic>? orderDetails;
      try {
        // First check if this is a payment intent ID
        if (widget.orderId!.startsWith('pi_')) {
          print('This appears to be a payment intent ID, looking up order by payment_intent_id');

          // Try to find the order by payment_intent_id
          final orderByPaymentIntent = await Supabase.instance.client
              .from('orders')
              .select('order_id')
              .eq('payment_intent_id', widget.orderId)
              .maybeSingle();

          if (orderByPaymentIntent != null) {
            print('Found order with payment intent ID: ${orderByPaymentIntent['order_id']}');
            orderDetails = await orderQueryService.getOrderDetails(orderByPaymentIntent['order_id']);
          } else {
            print('No order found with payment intent ID: ${widget.orderId}');
            throw Exception('No order found with this payment reference');
          }
        } else {
          // Regular order ID lookup
          orderDetails = await orderQueryService.getOrderDetails(widget.orderId!);
        }
      } catch (e) {
        print('Error fetching order details: $e');
        // If we can't get order details, create a placeholder
        orderDetails = {
          'order_id': widget.orderId,
          'status': 'PENDING',
          'total_amount': 0.0,
          'order_items': [],
        };
      }

      if (mounted) {
        setState(() {
          _orderDetails = orderDetails;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load order details: $e';
          _isLoading = false;
        });
      }
    }
  }

  // Navigate back to home and ensure cart is cleared
  void _navigateToHome() {
    try {
      ref.read(cartProvider.notifier).clearCart();
    } catch (e) {
      print('Error clearing cart: $e');
    }

    // Prevent double-clearing in dispose
    _hasNavigatedAway = true;

    // Navigate to home page using the root navigator
    context.go('/');
  }

  void _navigateToCreateAccount() {
    // Get shipping info from order if available
    Map<String, dynamic> initialData = {
      'isGuestCheckout': true,
    };

    if (_orderDetails != null && _orderDetails!['shipping_address'] != null) {
      final shippingAddress = _orderDetails!['shipping_address'];
      initialData['firstName'] = shippingAddress['first_name'] ?? '';
      initialData['lastName'] = shippingAddress['last_name'] ?? '';
      initialData['email'] = shippingAddress['email'] ?? '';
    }

    // Navigate to register page with initial data
    context.push('/account/register', extra: initialData);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final isLoggedIn = ref.watch(isLoggedInProvider);

    // TODO
    return WillPopScope(
      // Prevent back navigation with hardware back button
      onWillPop: () async {
        _navigateToHome();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Confirmation', style: TextStyle(color: colorScheme.primary)),
          backgroundColor: colorScheme.surface,
          automaticallyImplyLeading: false, // Remove back button
          actions: [
            // Add a close button
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _navigateToHome,
            ),
          ],
        ),
        body: _buildBody(colorScheme, isLoggedIn),
      ),
    );
  }

  Widget _buildBody(ColorScheme colorScheme, bool isLoggedIn) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Error Loading Order',
        subtitle: _errorMessage!,
      );
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              color: colorScheme.primary,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your order #${widget.orderId != null ? widget.orderId!.substring(0, 8) : 'N/A'} has been placed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'You will receive a confirmation email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: colorScheme.onSurface),
            ),

            if (_orderDetails != null) ...[
              const SizedBox(height: 32),
              OrderConfirmationHelper.buildOrderSummary(_orderDetails, colorScheme),
            ],

            const SizedBox(height: 32),

            // Create account button for guest users
            if (!isLoggedIn)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _navigateToCreateAccount,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.primary),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: const Text(
                    'CREATE AN ACCOUNT TO TRACK YOUR ORDER',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),

            BaseStyledButton(
              text: "CONTINUE SHOPPING",
              onTap: _navigateToHome,
              textColor: colorScheme.primary,
              borderColor: colorScheme.primary,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class OrderQueryService {
  final SupabaseClient client;

  OrderQueryService(this.client);

  Future<Map<String, dynamic>> getOrderDetails(String orderId) async {
    try {
      final response = await client
          .from('orders')
          .select('''
            *,
            order_items (
              *,
              product:product_id (*)
            )
          ''')
          .eq('order_id', orderId)
          .single();

      return response as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching order details: $e');
      throw Exception('Failed to load order details');
    }
  }
}
