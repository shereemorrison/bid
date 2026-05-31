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
  bool _ordersRequested = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserDataIfNeeded();
    });
  }

  void _fetchUserDataIfNeeded() {
    if (!ref.read(isLoggedInProvider)) return;
    ref.read(authProvider.notifier).refreshUserData();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState.userData != null && !_ordersRequested) {
      _ordersRequested = true;
      final userId = authState.userData!.userId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(ordersProvider.notifier).fetchUserOrders(userId);
      });
    }

    if (authState.isLoading && authState.userData == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!authState.isLoggedIn) {
      return const Scaffold(body: LoggedOutView());
    }

    if (authState.userData == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  authState.error ?? 'Could not load your profile.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).refreshUserData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const Scaffold(body: LoggedInView());
  }
}
