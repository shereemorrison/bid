import 'package:bid/components/buttons/auth_button.dart';
import 'package:bid/components/common_widgets/info_item.dart';
import 'package:bid/components/common_widgets/profile_header.dart';
import 'package:bid/components/order_widgets/order_history_table.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/providers/order_provider.dart';
import 'package:bid/providers/supabase_auth_provider.dart';
import 'package:bid/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoggedInView extends ConsumerWidget {
  final UserModel? userData;

  const LoggedInView({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    // If userData is null, show a loading indicator
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
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
                _buildUserHeader(context, userData!, colorScheme),

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
                InfoItem(label: 'First Name', value: userData!.firstName ?? 'Not set'),
                InfoItem(label: 'Last Name', value: userData!.lastName ?? 'Not set'),
                InfoItem(label: 'Phone', value: userData!.phone ?? 'Not set'),
                InfoItem(label: 'Address', value: userData!.formattedAddress),

                const SizedBox(height: 10),

                // Orders
                _buildOrdersSection(context,ref),

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

  Widget _buildUserHeader(BuildContext context, UserModel userData, ColorScheme colorScheme) {
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
    );
  }

  Widget _buildOrdersSection(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final isLoading = ref.watch(orderLoadingProvider);
    final error = ref.watch(orderErrorProvider);

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
            OrderHistoryTable(
              orders: orders.take(5).toList(), // Show last 5 orders
              onViewDetails: (orderId) {
                // Navigate to order details page
                print('View details for order: $orderId');
              },
            ),
      ],
    );
  }

  void _handleSignOut(BuildContext context, WidgetRef ref) async {
    await ref.read(authNotifierProvider.notifier).signOut();
    ref.read(userNotifierProvider.notifier).clearUserData();
    ref.read(orderNotifierProvider.notifier).clearOrders();
  }
}
