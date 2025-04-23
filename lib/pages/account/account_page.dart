
import 'package:bid/pages/account/logged_in_view.dart';
import 'package:bid/pages/account/logged_out_view.dart';
import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:bid/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserDataIfNeeded();
      _fetchOrdersIfNeeded();
    });
  }

  void _fetchUserDataIfNeeded() {
    final authService = ref.read(authServiceProvider);
    final isLoggedIn = ref.read(authService.isLoggedInProvider);
    final userData = ref.read(authService.userProvider);
    final authUserId = ref.read(authService.authUserIdProvider);

    if (isLoggedIn && userData == null && authUserId != null) {
      print('Fetching user data for ID: $authUserId');
      authService.initAuthState();
    }
  }

  void _fetchOrdersIfNeeded() {
    final authService = ref.read(authServiceProvider);
    final isLoggedIn = ref.read(authService.isLoggedInProvider);
    final orders = ref.read(ordersProvider);
    final isLoading = ref.read(orderLoadingProvider);
    final authUserId = ref.read(authService.authUserIdProvider);

    if (isLoggedIn && orders == null && !isLoading && authUserId != null) {
      print('Fetching orders for user ID: $authUserId');
      ref.read(orderNotifierProvider.notifier).fetchUserOrders(authUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.watch(authServiceProvider);
    final isLoggedIn = ref.watch(authService.isLoggedInProvider);
    final userData = ref.watch(authService.userProvider);
    final isLoading = ref.watch(authService.authLoadingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !isLoggedIn
          ? const LoggedOutView()
          : LoggedInView(),
    );
  }
}