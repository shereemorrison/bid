
import 'package:bid/components/buttons/auth_button.dart';
import 'package:bid/components/common_widgets/profile_header.dart';
import 'package:bid/components/common_widgets/social_login_row.dart';
import 'package:bid/components/order_widgets/order_history_table.dart';
import 'package:bid/modals/loginmodal.dart';
import 'package:bid/modals/registrationmodal.dart';
import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:bid/utils/ui_helpers.dart';
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
          ? _buildNotLoggedInView(context)
          : userData == null
          ? _buildNoProfileView(context, authProvider)
          : SingleChildScrollView(
        child: Column(
          children: [
            const ProfileHeader(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section with user name and email
                  Row(
                    children: [
                      Container(
                        child: Center(
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData.fullName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            userData.email,
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Personal Information
                  Text(
                    'Personal Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildInfoItem(context, 'First Name', userData.firstName ?? 'Not set'),
                  buildInfoItem(context, 'Last Name', userData.lastName ?? 'Not set'),
                  buildInfoItem(context, 'Phone', userData.phone ?? 'Not set'),
                  buildInfoItem(context, 'Address', userData.formattedAddress),

                  const SizedBox(height: 10),

                  //Orders
                  const Text(
                    'Orders',
                    style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<OrderProvider>(
                    builder: (context, orderProvider, child) {
                      if (orderProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (orderProvider.error != null) {
                        return Text('Error: ${orderProvider.error}');
                      }

                      final orders = orderProvider.orders;
                      if (orders == null || orders.isEmpty) {
                        return buildInfoItem(context, 'Order ID', 'No recent orders');
                      }

                      return OrderHistoryTable(
                        orders: orders.take(5).toList(), // Show last 5 orders
                        onViewDetails: (orderId) {
                          // Navigate to order details page
                          print('View details for order: $orderId');
                        },
                      );
                    },
                    ),

                  const SizedBox(height: 40),

                  /*// Edit Profile Button
                  SizedBox(
                    width: double.infinity,
                    child: MyButton(
                      text: "Edit Profile",
                      onTap: () {
                        // TODO - Add edit profile ability
                      },
                    ),
                  ),*/

                  // Sign Out Button
                  AuthButton(text: 'Sign Out', onTap: () async {
                    final userProvider = Provider.of<UserProvider>(context, listen: false);
                    Provider.of<OrderProvider>(context, listen: false);

                    //Sign out
                    await authProvider.signOut();

                    //Clear data after sign out
                    userProvider.clearUserData();
                  },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfileView(BuildContext context, SupabaseAuthProvider authProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),

          Text(
            'No profile found for this account.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Sign out button
          AuthButton(
            text: "Sign Out",
            onTap: () async {
              await authProvider.signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: colorScheme.secondary,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  color: colorScheme.primary
              ),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileHeader(),
          const SizedBox(height: 30),

          Text(
            'You need to log in to view your profile',
            style: TextStyle(fontSize: 16,
                color: colorScheme.secondary),
          ),
          const SizedBox(height: 20),

          AuthButton(
            text: "Login",
            onTap: () => _showLoginModal(context),
          ),
          const SizedBox(height: 15),
          AuthButton(
            text: "Sign Up",
            onTap: () => _showRegistrationModal(context),
          ),
          const SizedBox(height: 15),
          const SocialLoginRow(),
        ],
      ),
    );
  }

  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LoginPage(
          onTap: () {
            Navigator.pop(context);
            _showRegistrationModal(context);
          },
        );
      },
    );
  }

  void _showRegistrationModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RegistrationPage(
          onTap: () {
            Navigator.pop(context);
            _showLoginModal(context);
          },
        );
      },
    );
  }
}