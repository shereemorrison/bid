import 'package:bid/components/checkout/payment_tab.dart' hide effectiveAddressProvider;
import 'package:bid/models/address_model.dart';
import 'package:bid/providers.dart';
import 'package:bid/utils/shipping_tab_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ShippingTab extends ConsumerStatefulWidget {
  final VoidCallback onProceed;
  final VoidCallback onBack;

  const ShippingTab({
    Key? key,
    required this.onProceed,
    required this.onBack,
  }) : super(key: key);

  @override
  ConsumerState<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends ConsumerState<ShippingTab> with AutomaticKeepAliveClientMixin {
  bool _showAddressSelector = false;
  bool _isSubmitting = false;

  @override
  bool get wantKeepAlive => false; // State reset between sessions

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Clear existing address data when the tab is created
      ref.read(addressProvider.notifier).clearAddresses();

      Future<void> _loadUserAddresses(String authId) async {
        try {
          // Query the users table to get the database user_id from auth_id
          final userResponse = await Supabase.instance.client
              .from('users')
              .select('user_id')
              .eq('auth_id', authId)
              .maybeSingle();

          if (userResponse != null) {
            final databaseUserId = userResponse['user_id'];
            print('ShippingTab: Found database user_id: $databaseUserId for auth_id: $authId');

            // Now fetch addresses using the database user_id
            ref.read(addressProvider.notifier).fetchUserAddresses(databaseUserId);
          } else {
            print('ShippingTab: No user found for auth_id: $authId');
          }
        } catch (e) {
          print('ShippingTab: Error loading user addresses: $e');
        }
      }

      // Load addresses for logged in users
      final isLoggedIn = ref.read(isLoggedInProvider);
      if (isLoggedIn) {
        // Get the database user ID, not the auth ID
        final authUserId = ref.read(userIdProvider);
        if (authUserId != null) {
          // Get the database user_id from the auth_id
          _loadUserAddresses(authUserId);
        }
      } else {
        // For guest users, use the guest ID directly
        final guestId = ref.read(guestUserIdProvider);
        if (guestId.isNotEmpty) {
          ref.read(addressProvider.notifier).fetchUserAddresses(guestId);
        }
      }

      // Check if cart is empty
      _checkCartEmpty();
    });
  }

  // If cart is empty and redirect if needed
  void _checkCartEmpty() {
    final cartState = ref.read(cartProvider);
    if (cartState.items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/cart', (route) => false);
      });
    }
  }

  void _handleAddressSelected(dynamic address) {
    if (mounted) {
      setState(() {
        _showAddressSelector = false;
      });

      if (address is Address) {
        ref.read(checkoutProvider.notifier).setShippingAddress(address);
        print('ShippingTab: Address selected and set in checkout provider');
      }
    }
  }

  void _handleAddressCardTap() {
    setState(() {
      _showAddressSelector = true;
    });
  }

  void _handleAddressSubmission(Address address) async {
    // Show loading indicator
    setState(() {
      _isSubmitting = true;
    });

    try {
      final addressRepository = ref.read(addressRepositoryProvider);
      String addressId;

      // Check if new address to be saved
      if (address.id.isEmpty || address.id == 'new') {
        // Generate a new ID for the address
        final newAddressId = const Uuid().v4();

        // Create a new address with the updated ID
        final addressToSave = Address(
          id: newAddressId,
          userId: address.userId,
          firstName: address.firstName,
          lastName: address.lastName,
          streetAddress: address.streetAddress,
          apartment: address.apartment,
          city: address.city,
          state: address.state,
          postalCode: address.postalCode,
          country: address.country,
          phone: address.phone,
          email: address.email,
          isDefault: address.isDefault,
          addressType: address.addressType,
        );

        // For guest users, log the user ID
        print('ShippingTab: Processing address for user ID: ${addressToSave
            .userId}');

        // Save address to Supabase - this will now create the user if needed
        final addressSaved = await addressRepository.addAddress(
            addressToSave);
        if (!addressSaved) {
          throw Exception('Failed to save shipping address');
        }

        addressId = newAddressId;
        print('New address saved to database: $addressId');
      } else {
        // Use existing address ID
        addressId = address.id;
      }

      // Update selected address in provider
      ref.read(addressProvider.notifier).selectAddress(address);

      // Store address ID in checkout state
      ref.read(checkoutProvider.notifier).setShippingAddress(address);

      // Proceed to payment
      widget.onProceed();
    } catch (e) {
      // Error if address not saved - for debugging
      print('ShippingTab: Error saving address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving address: $e')),
      );
    } finally {
      // Hide loading indicator
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final selectedAddress = ref.watch(effectiveAddressProvider);
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    // Check if cart is empty on each build
    final cartState = ref.watch(cartProvider);
    if (cartState.items.isEmpty) {
      // Return a minimal widget while we redirect
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        // Main content - scrollable
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shipping Information
                ShippingTabUIHelper.buildShippingInformation(
                  context: context,
                  showAddressSelector: _showAddressSelector,
                  selectedAddress: selectedAddress,
                  onAddressSelected: _handleAddressSelected,
                  onAddressCardTap: _handleAddressCardTap,
                ),

                const SizedBox(height: 24),

                // Shipping method
                ShippingTabUIHelper.buildShippingMethod(context),
              ],
            ),
          ),
        ),

        // Bottom buttons
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ShippingTabUIHelper.buildBottomButtons(
            context: context,
            onBack: widget.onBack,
            onProceed: widget.onProceed,
            canProceed: selectedAddress != null,
          ),
        ),
      ],
    );
  }
}