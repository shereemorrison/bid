import 'package:bid/components/buttons/auth_button.dart';
import 'package:bid/components/common_widgets/info_item.dart';
import 'package:bid/components/common_widgets/profile_header.dart';
import 'package:bid/components/order_widgets/order_history_table.dart';
import 'package:bid/models/order_model.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoggedInView extends ConsumerWidget {
  const LoggedInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDataProvider)!;
    final orders = ref.watch(userOrdersProvider);
    final isOrderLoading = ref.watch(ordersLoadingProvider);
    final orderError = ref.watch(ordersErrorProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          const ProfileHeader(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserHeader(context, userData, colorScheme),
                const SizedBox(height: 40),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                InfoItem(
                  label: 'First Name',
                  value: userData.firstName ?? 'Not set',
                ),
                InfoItem(
                  label: 'Last Name',
                  value: userData.lastName ?? 'Not set',
                ),
                InfoItem(
                  label: 'Phone',
                  value: userData.phone ?? 'Not set',
                ),
                InfoItem(label: 'Email', value: userData.email),
                InfoItem(
                  label: 'Address',
                  value: userData.formattedAddress,
                ),
                const SizedBox(height: 10),
                _buildOrdersSection(
                  context,
                  orders,
                  isOrderLoading,
                  orderError,
                ),
                const SizedBox(height: 40),
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

  Widget _buildUserHeader(
    BuildContext context,
    UserData userData,
    ColorScheme colorScheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.person, size: 40, color: colorScheme.primary),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
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
        ),
      ],
    );
  }

  Widget _buildOrdersSection(
    BuildContext context,
    List<Order> orders,
    bool isLoading,
    String? error,
  ) {
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
        else if (orders.isEmpty)
          const InfoItem(label: 'Order ID', value: 'No recent orders')
        else
          OrderHistoryTable(
            orders: orders.take(5).toList(),
            onViewDetails: (orderId) {
              context.push('/account/order/$orderId');
            },
          ),
      ],
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign out failed: $e')),
        );
      }
    }
  }
}
