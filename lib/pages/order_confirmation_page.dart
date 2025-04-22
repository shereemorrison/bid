import 'package:bid/components/auth/auth_modal.dart';
import 'package:bid/components/buttons/shopping_buttons.dart';
import 'package:bid/components/common_widgets/empty_state.dart';
import 'package:bid/providers/shop_provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/services/order_service.dart';
import 'package:bid/utils/order_confirmation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


// Create a simple state provider for order details
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
    _loadOrderDetails();

    // Clear the cart immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      OrderConfirmationHelper.clearCartAndCheckoutState(ref);
    });
  }

  @override
  void dispose() {
    // Make sure we don't have any lingering state
    if (!_hasNavigatedAway) {
      try {
        ref.read(cartProvider.notifier).state = [];
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
      });
      return;
    }

    try {
      final orderService = ref.read(orderServiceProvider);
      final orderDetails = await orderService.getOrderDetails(widget.orderId!);

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
    // Clear the cart again just to be sure
    try {
      ref.read(cartProvider.notifier).state = [];
    } catch (e) {
      print('Error clearing cart: $e');
    }

    // Set flag to prevent double-clearing in dispose
    _hasNavigatedAway = true;

    // Navigate to home page using the root navigator
    context.go('/');
  }

  void _showCreateAccountDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AuthModal(
          initialType: AuthModalType.register,
          onRegisterSuccess: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoggedIn = ref.watch(isLoggedInProvider);

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
                  onPressed: _showCreateAccountDialog,
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
