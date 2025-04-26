
import 'package:bid/pages/account/logged_in_view.dart';
import 'package:bid/pages/account/logged_out_view.dart';
import 'package:bid/providers.dart';
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
    final authUserId = ref.read(userIdProvider);
  }

  void _fetchOrdersIfNeeded() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    final userData = ref.read(userDataProvider);
    final authUserId = ref.read(userIdProvider);

    if (isLoggedIn && userData == null && authUserId != null) {
      print('Fetching user data for ID: $authUserId');
      ref.read(ordersProvider.notifier).fetchUserOrders(authUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final userData = ref.watch(userDataProvider);
    final isLoading = ref.watch(authLoadingProvider);
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