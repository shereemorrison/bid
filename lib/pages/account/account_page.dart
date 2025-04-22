
import 'package:bid/pages/account/logged_in_view.dart';
import 'package:bid/pages/account/logged_out_view.dart';
import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/providers/user_provider.dart';
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
    final isLoggedIn = ref.read(isLoggedInProvider);
    final userData = ref.read(userDataProvider);
    final isLoading = ref.read(userLoadingProvider);
    final authUserId = ref.read(authUserIdProvider);

    if (isLoggedIn && userData == null && !isLoading && authUserId != null) {
      print('Fetching user data for ID: $authUserId');
      ref.read(userNotifierProvider.notifier).updateUserData(authUserId);
    }
  }

  void _fetchOrdersIfNeeded() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    final orders = ref.read(ordersProvider);
    final isLoading = ref.read(orderLoadingProvider);
    final authUserId = ref.read(authUserIdProvider);

    if (isLoggedIn && orders == null && !isLoading && authUserId != null) {
      print('Fetching orders for user ID: $authUserId');
      ref.read(orderNotifierProvider.notifier).fetchUserOrders(authUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final userData = ref.watch(userDataProvider);
    final isLoading = ref.watch(userLoadingProvider);
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