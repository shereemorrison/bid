import 'package:bid/components/address_widgets/address_form.dart';
import 'package:bid/models/address_model.dart';
import 'package:bid/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddressSelector extends ConsumerStatefulWidget {
  final Function(Address) onAddressSelected;

  const AddressSelector({
    Key? key,
    required this.onAddressSelected,
  }) : super(key: key);

  @override
  ConsumerState<AddressSelector> createState() => _AddressSelectorState();
}

class _AddressSelectorState extends ConsumerState<AddressSelector> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAddresses();
    });
  }

  void _loadAddresses() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    final userData = ref.read(userDataProvider);

    if (isLoggedIn && userData != null) {
      ref.read(addressProvider.notifier).fetchUserAddresses(userData.userId);
    }
  }

  void _navigateToAddressForm({Address? addressToEdit}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddressForm(
          addressToEdit: addressToEdit,
          onSave: (address) {
            final addressNotifier = ref.read(addressProvider.notifier);

            if (address.userId.startsWith('guest-') || addressToEdit != null) {
              addressNotifier.updateAddress(address);
            } else {
              addressNotifier.addAddress(address);
            }

            widget.onAddressSelected(address);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLoading = ref.watch(addressProvider).isLoading;
    final selectedAddress = ref.watch(selectedAddressProvider);

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // If no address is selected, show a simple "Add Address" button
    if (selectedAddress == null) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _navigateToAddressForm(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colorScheme.primary),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            'ADD NEW ADDRESS',
            style: TextStyle(color: colorScheme.primary),
          ),
        ),
      );
    }

    // Show the selected address
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedAddress.addressType.toUpperCase(),
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  if (selectedAddress.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'DEFAULT',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                selectedAddress.formattedAddress,
                style: const TextStyle(fontSize: 14),
              ),
              if (selectedAddress.phone != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Phone: ${selectedAddress.phone}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),

        // Address selection and add new
        const SizedBox(height: 12),
        Row(
          children: [
            // Edit address button
            Expanded(
              child: OutlinedButton(
                onPressed: () => _navigateToAddressForm(addressToEdit: selectedAddress),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'EDIT ADDRESS',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Add new address button
            OutlinedButton(
              onPressed: () => _navigateToAddressForm(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colorScheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              child: Icon(Icons.add, color: colorScheme.primary),
            ),
          ],
        ),
      ],
    );
  }
}
