import 'package:bid/components/common_widgets/theme_toggle.dart';
import 'package:bid/components/common_widgets/webdrawer.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class WebAppLayout extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const WebAppLayout({Key? key, required this.navigationShell})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth >= 1200;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [const Text('BELIEVE IN DREAMS')]),
        actions: [
          ThemeToggle(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              navigationShell.goBranch(3);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      drawer: Webdrawer(child: _buildDrawerContent(context, ref)),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWideScreen ? 32.0 : 16.0,
              ),
              child: Column(children: [Expanded(child: navigationShell)]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerContent(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('Home'),
          onTap: () {
            navigationShell.goBranch(0);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.favorite),
          title: const Text('Wishlist'),
          onTap: () {
            navigationShell.goBranch(1);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: const Text('Shop'),
          onTap: () {
            navigationShell.goBranch(2);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.shopping_cart),
          title: const Text('Cart'),
          onTap: () {
            navigationShell.goBranch(3);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Account'),
          onTap: () {
            navigationShell.goBranch(4);
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        // Sign out option for logged in users
        Consumer(
          builder: (context, ref, child) {
            final isLoggedIn = ref.watch(isLoggedInProvider);
            if (isLoggedIn) {
              return ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () async {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  await _handleSignOut(context, ref);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Men'),
          onTap: () {
            context.go('/shop/men');
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Women'),
          onTap: () {
            context.go('/shop/women');
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        ListTile(
          leading: const Icon(Icons.category),
          title: const Text('Accessories'),
          onTap: () {
            context.go('/shop/accessories');
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      print('Signing out from web layout...');

      // The auth service handles all state clearing through the state coordinator
      await ref.read(authProvider.notifier).signOut();

      print('Sign out complete from web layout');

      // Navigate to home page
      context.go('/');
    } catch (e) {
      print('Error signing out from web layout: $e');
    }
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BID',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Premium streetwear for the modern individual.',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.chat),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.facebook),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Quick links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Links',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildFooterLink(context, 'Home', () {
                      GoRouter.of(context).go('/');
                    }),
                    _buildFooterLink(context, 'Shop', () {
                      GoRouter.of(context).go('/shop');
                    }),
                    _buildFooterLink(context, 'Cart', () {
                      GoRouter.of(context).go('/cart');
                    }),
                    _buildFooterLink(context, 'Account', () {
                      GoRouter.of(context).go('/account');
                    }),
                  ],
                ),
              ),
              // Categories
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildFooterLink(context, 'Men', () {
                      GoRouter.of(context).go('/shop/men');
                    }),
                    _buildFooterLink(context, 'Women', () {
                      GoRouter.of(context).go('/shop/women');
                    }),
                    _buildFooterLink(context, 'Accessories', () {
                      GoRouter.of(context).go('/shop/accessories');
                    }),
                  ],
                ),
              ),
              // Contact
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    const Text('Email: stefancasic@bid.com'),
                    const SizedBox(height: 8),
                    const Text('Phone: +61 480-424508'),
                    const SizedBox(height: 8),
                    const Text('Address: Southbank, Melbourne, Australia'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            '© 2025 B.I.D. All rights reserved.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(
    BuildContext context,
    String text,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
