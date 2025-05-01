import 'package:bid/components/auth/checkout_auth_adapter.dart';
import 'package:bid/components/checkout/payment_tab.dart';
import 'package:bid/components/checkout/shipping_tab.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/order_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bid/components/checkout/bag_tab.dart';
import 'package:go_router/go_router.dart';


// Provider to track the current checkout step
final checkoutStepProvider = StateProvider<int>((ref) => 0);

// Provider to track if checkout is complete
final checkoutCompleteProvider = StateProvider<bool>((ref) => false);
final isGuestCheckoutProvider = StateProvider<bool>((ref) => false);

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  bool _showAuthFlow = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Initialize with the current step from provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentStep = ref.read(checkoutStepProvider);
      if (currentStep != _currentIndex) {
        _tabController.animateTo(currentStep);
        setState(() {
          _currentIndex = currentStep;
        });
      }

      // Reset checkout complete flag when page loads
      ref.read(checkoutCompleteProvider.notifier).state = false;

      // Check auth status
      _checkAuthStatus();
    });

    // Listen to tab changes
    _tabController.addListener(_handleTabChange);
  }

  void _checkAuthStatus() {
    final isGuestCheckout = ref.read(isGuestCheckoutProvider);
    final isLoggedIn = ref.read(isLoggedInProvider);

    if (!isLoggedIn && !isGuestCheckout) {
      setState(() {
        _showAuthFlow = true;
      });
    } else {
      // Initialize checkout session with logged-in user
      final authUserId = ref.read(userIdProvider);
      if (authUserId != null) {
        ref.read(checkoutProvider.notifier).initCheckout(
          ref.read(cartItemsProvider),
          isGuestCheckout: !isLoggedIn,
        );
      }
    }
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging && _tabController.index != _currentIndex) {
      setState(() {
        _currentIndex = _tabController.index;
      });
      ref.read(checkoutStepProvider.notifier).state = _currentIndex;
    }
  }

  void _handleAuthSuccess() {
    setState(() {
      _showAuthFlow = false;
    });

    // Initialize checkout session with logged-in user
    // Use the new AuthService
    final authUserId = ref.read(userIdProvider);

    if (authUserId != null) {
      ref.read(checkoutProvider.notifier).initCheckout(
        ref.read(cartItemsProvider),
        isGuestCheckout: false,
      );
    }
  }

  void _handleContinueAsGuest() {
    setState(() {
      _showAuthFlow = false;
    });

    // Initialize checkout session as guest
    ref.read(checkoutProvider.notifier).initCheckout(
      ref.read(cartItemsProvider),
      isGuestCheckout: true,
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  // Reset checkout when complete
  void _resetCheckout() {
    ref.read(checkoutStepProvider.notifier).state = 0;
    _tabController.animateTo(0);
    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCheckoutComplete = ref.watch(checkoutCompleteProvider);
    final orderId = ref.watch(orderConfirmationIdProvider);

    // Check if cart is empty - if so, redirect to cart page
    if (cartState.items.isEmpty) {
      // Post-frame callback to navigate back to cart page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/cart');
      });

      // Loading indicator while redirecting
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // If checkout is complete, reset to first tab
    if (isCheckoutComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/order-confirmation?order_id=$orderId');

        // Reset the order ID and checkout complete flag
        ref.read(orderConfirmationIdProvider.notifier).state = null;
        ref.read(checkoutCompleteProvider.notifier).state = false;
      });
    }

    // Calculate totals for display
    final double subtotal = cartState.subtotal;
    final double shipping = 10.0;
    final double tax = OrderCalculator.calculateTax(subtotal);
    final double total = OrderCalculator.calculateTotal(
      subtotal: subtotal,
      taxAmount: tax,
      shippingAmount: shipping,
      discountAmount: 0.0,
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48), // Height for tabs only
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: _currentIndex >= 0 ? colorScheme.primary : Colors.grey,
              ),
              text: 'BAG',
            ),
            Tab(
              icon: Icon(
                Icons.local_shipping_outlined,
                color: _currentIndex >= 1 ? colorScheme.primary : Colors.grey,
              ),
              text: 'SHIPPING',
            ),
            Tab(
              icon: Icon(
                Icons.payment_outlined,
                color: _currentIndex >= 2 ? colorScheme.primary : Colors.grey,
              ),
              text: 'PAYMENT',
            ),
          ],
          indicatorColor: colorScheme.primary,
          labelColor: colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          labelStyle: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: textTheme.bodyMedium,
        ),
      ),
      body: _showAuthFlow
          ? CheckoutAuthAdapter(
        onAuthSuccess: _handleAuthSuccess,
        onContinueAsGuest: _handleContinueAsGuest,
      )
          : IndexedStack(
        index: _currentIndex,
        children: [
          // Bag tab (Order Summary)
          BagTab(
            onProceed: () {
              setState(() {
                _currentIndex = 1;
              });
              _tabController.animateTo(1);
              ref.read(checkoutStepProvider.notifier).state = 1;
            },
          ),

          // Shipping tab
          ShippingTab(
            onProceed: () {
              // Save shipping info to session
              setState(() {
                _currentIndex = 2;
              });
              _tabController.animateTo(2);
              ref.read(checkoutStepProvider.notifier).state = 2;
            },
            onBack: () {
              setState(() {
                _currentIndex = 0;
              });
              _tabController.animateTo(0);
              ref.read(checkoutStepProvider.notifier).state = 0;
            },
          ),

          // Payment tab
          PaymentTab(
            amount: total,
            onBack: () {
              setState(() {
                _currentIndex = 1;
              });
              _tabController.animateTo(1);
              ref.read(checkoutStepProvider.notifier).state = 1;
            },
          ),
        ],
      ),
    );
  }
}
