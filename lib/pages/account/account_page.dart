
import 'package:bid/pages/account/logged_in_view.dart';
import 'package:bid/pages/account/logged_out_view.dart';
import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  SupabaseAuthProvider? _authProvider;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
      authProvider.addListener(_onAuthChanged);
      _fetchUserDataIfNeeded();
      _fetchOrdersIfNeeded();
    });
  }

  void _onAuthChanged() {
    _fetchUserDataIfNeeded();
    _fetchOrdersIfNeeded();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
  }

  @override
  void dispose() {
    if (_authProvider != null) {
      _authProvider!.removeListener(_onAuthChanged);
    }
    super.dispose();
  }

  void _fetchUserDataIfNeeded() {
    final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (authProvider.isLoggedIn && userProvider.userData == null &&
        !userProvider.isLoading) {
      print('Fetching user data for ID: ${authProvider.user!.id}');
      userProvider.fetchUserData(authProvider.user!.id);
    }
  }

  void _fetchOrdersIfNeeded() {
    final authProvider = Provider.of<SupabaseAuthProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    if (authProvider.isLoggedIn && orderProvider.orders == null && !orderProvider.isLoading) {
      print('Fetching orders for user ID: ${authProvider.user!.id}');
      orderProvider.fetchUserOrders(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SupabaseAuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    final isLoading = userProvider.isLoading;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !authProvider.isLoggedIn
          ? const LoggedOutView()
          : LoggedInView(userData: userProvider.userData),
    );
  }
}