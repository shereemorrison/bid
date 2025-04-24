import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/buttons/auth_button.dart';
import '../../components/common_widgets/info_item.dart';
import '../../components/common_widgets/profile_header.dart';
import '../../components/order_widgets/order_history_table.dart';
import '../../models/order_model.dart'; // Import your Order model

class LoggedInView extends ConsumerWidget {
  const LoggedInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider);
    final orders = ref.watch(userOrdersProvider);
    final isOrderLoading = ref.watch(ordersLoadingProvider);
    final orderError = ref.watch(ordersErrorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Fetch orders if needed
    if (orders == null && !isOrderLoading) {
      final authUserId = ref.read(userIdProvider);
      if (authUserId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(ordersProvider.notifier).fetchUserOrders(authUserId);
        });
      }
    }

    return SingleChildScrollView(
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
                _buildUserHeader(context, userData, colorScheme),

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
                InfoItem(label: 'First Name', value: userData?.firstName ?? 'Not set'),
                InfoItem(label: 'Last Name', value: userData?.lastName ?? 'Not set'),
                InfoItem(label: 'Phone', value: userData?.phone ?? 'Not set'),
                InfoItem(label: 'Email', value: userData!.email),

                const SizedBox(height: 10),

                // Orders
                _buildOrdersSection(context, orders, isOrderLoading, orderError),

                const SizedBox(height: 40),

                // Sign Out Button
                AuthButton(
                  text: 'Sign Out',
                  onTap: () => _handleSignOut(context, ref),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(BuildContext context, dynamic userData, ColorScheme colorScheme) {
    final fullName = userData.firstName != null && userData.lastName != null
        ? "${userData.firstName} ${userData.lastName}"
        : userData.email;

    return Row(
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
              fullName,
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
    );
  }

  Widget _buildOrdersSection(BuildContext context, List<dynamic>? orders, bool isLoading, String? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Orders',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),

        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (error != null)
          Text('Error: $error')
        else if (orders == null || orders.isEmpty)
            InfoItem(label: 'Order ID', value: 'No recent orders')
          else
            Builder(builder: (context) {
              try {
                return OrderHistoryTable(
                  orders: orders.take(5).map((order) => order as Order).toList(),
                  onViewDetails: (orderId) {
                    // Navigate to order details page
                    context.push('/account/order/$orderId');
                  },
                );
              } catch (e) {
                return Text('Error displaying orders: $e');
              }
            }),
      ],
    );
  }

  void _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      print('Signing out...');

      // Get the auth service
      await ref.read(authProvider.notifier).signOut();

      print('Sign out complete');

      // No need to invalidate providers here - the AuthService handles state updates
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}
