import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';

/// A widget that listens to auth state changes and triggers actions
class AuthListener extends ConsumerStatefulWidget {
  final Widget child;

  const AuthListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  ConsumerState<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends ConsumerState<AuthListener> {
  @override
  void initState() {
    super.initState();

    // Perform any initialization that needs auth state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleAuthStateChange();
    });
  }

  void _handleAuthStateChange() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    final userId = ref.read(userIdProvider);

    if (isLoggedIn && userId != null) {
      // User is logged in, load their data
      _loadUserData(userId);
    } else {
      // User is logged out, clear cart if needed
      ref.read(cartProvider.notifier).clearCart();
    }
  }

  Future<void> _loadUserData(String userId) async {
    // Load user's orders
    ref.read(ordersProvider.notifier).fetchUserOrders(userId);

    // Load user's addresses
    ref.read(addressProvider.notifier).fetchUserAddresses(userId);

    // Load initial product data
    ref.read(productsProvider.notifier).loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen(isLoggedInProvider, (previous, current) {
      if (previous != current) {
        _handleAuthStateChange();
      }
    });

    return widget.child;
  }
}
