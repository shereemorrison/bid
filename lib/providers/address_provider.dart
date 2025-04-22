// lib/providers/address_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address_model.dart';
import '../services/address_service.dart';

// Service provider
final addressServiceProvider = Provider<AddressService>((ref) {
  return AddressService();
});

// State providers
final addressesProvider = StateProvider<List<AddressModel>?>((ref) => null);
final selectedAddressProvider = StateProvider<AddressModel?>((ref) => null);
final guestAddressProvider = StateProvider<AddressModel?>((ref) => null);
final addressLoadingProvider = StateProvider<bool>((ref) => false);
final addressErrorProvider = StateProvider<String?>((ref) => null);

// Computed provider for effective selected address (selected or guest)
final effectiveAddressProvider = Provider<AddressModel?>((ref) {
  final selectedAddress = ref.watch(selectedAddressProvider);
  final guestAddress = ref.watch(guestAddressProvider);
  return selectedAddress ?? guestAddress;
});

// Controller notifier for complex state management
class AddressNotifier extends StateNotifier<AsyncValue<void>> {
  final AddressService _addressService;
  final Ref _ref;

  AddressNotifier(this._addressService, this._ref)
      : super(const AsyncValue.data(null));

  // Fetch all addresses for a user
  Future<void> fetchUserAddresses(String userId) async {
    _ref
        .read(addressLoadingProvider.notifier)
        .state = true;
    _ref
        .read(addressErrorProvider.notifier)
        .state = null;

    try {
      final addresses = await _addressService.getUserAddresses(userId);

      _ref
          .read(addressesProvider.notifier)
          .state = addresses;

      // If there's a default shipping address, select it
      if (addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
              (address) =>
          address.isDefault && address.addressType == 'shipping',
          orElse: () => addresses.first,
        );
        _ref
            .read(selectedAddressProvider.notifier)
            .state = defaultAddress;
      }
    } catch (e) {
      _ref
          .read(addressErrorProvider.notifier)
          .state = 'Failed to load addresses';
      print('AddressNotifier: Error fetching addresses: $e');
    } finally {
      _ref
          .read(addressLoadingProvider.notifier)
          .state = false;
    }
  }

  // Add a new address
  Future<AddressModel?> addAddress(AddressModel address) async {
    _ref
        .read(addressLoadingProvider.notifier)
        .state = true;
    _ref
        .read(addressErrorProvider.notifier)
        .state = null;

    try {
      // Check if this is a guest user
      if (address.userId.startsWith('guest-')) {
        // For guest users, just store the address in memory
        _ref
            .read(guestAddressProvider.notifier)
            .state = address;
        _ref
            .read(addressLoadingProvider.notifier)
            .state = false;
        return address;
      }

      // For logged-in users, save to database
      final newAddress = await _addressService.addAddress(address);

      if (newAddress != null) {
        // Refresh the address list
        await fetchUserAddresses(address.userId);

        // If this is the default address or we don't have a selected address yet, select it
        if (address.isDefault || _ref.read(selectedAddressProvider) == null) {
          _ref
              .read(selectedAddressProvider.notifier)
              .state = newAddress;
        }
      }

      return newAddress;
    } catch (e) {
      _ref
          .read(addressErrorProvider.notifier)
          .state = 'Failed to add address';
      print('AddressNotifier: Error adding address: $e');
      return null;
    } finally {
      _ref
          .read(addressLoadingProvider.notifier)
          .state = false;
    }
  }

  // Update an existing address
  Future<bool> updateAddress(AddressModel address) async {
    _ref
        .read(addressLoadingProvider.notifier)
        .state = true;
    _ref
        .read(addressErrorProvider.notifier)
        .state = null;

    try {
      // Check if this is a guest user
      if (address.userId.startsWith('guest-')) {
        // For guest users, just update the address in memory
        _ref
            .read(guestAddressProvider.notifier)
            .state = address;
        _ref
            .read(addressLoadingProvider.notifier)
            .state = false;
        return true;
      }

      // For logged-in users, update in database
      final success = await _addressService.updateAddress(address);

      if (success) {
        // Refresh the address list
        await fetchUserAddresses(address.userId);

        // Update selected address if needed
        final selectedAddress = _ref.read(selectedAddressProvider);
        if (selectedAddress?.addressId == address.addressId) {
          _ref
              .read(selectedAddressProvider.notifier)
              .state = address;
        }
      }

      return success;
    } catch (e) {
      _ref
          .read(addressErrorProvider.notifier)
          .state = 'Failed to update address';
      print('AddressNotifier: Error updating address: $e');
      return false;
    } finally {
      _ref
          .read(addressLoadingProvider.notifier)
          .state = false;
    }
  }

  // Delete an address
  Future<bool> deleteAddress(String addressId, String userId) async {
    _ref
        .read(addressLoadingProvider.notifier)
        .state = true;
    _ref
        .read(addressErrorProvider.notifier)
        .state = null;

    try {
      // Check if this is a guest user
      if (userId.startsWith('guest-')) {
        // For guest users, just clear the address in memory
        final guestAddress = _ref.read(guestAddressProvider);
        if (guestAddress?.addressId == addressId) {
          _ref
              .read(guestAddressProvider.notifier)
              .state = null;
        }
        _ref
            .read(addressLoadingProvider.notifier)
            .state = false;
        return true;
      }

      // For logged-in users, delete from database
      final success = await _addressService.deleteAddress(addressId, userId);

      if (success) {
        // Refresh the address list
        await fetchUserAddresses(userId);

        // If we deleted the selected address, select another one
        final selectedAddress = _ref.read(selectedAddressProvider);
        final addresses = _ref.read(addressesProvider);
        if (selectedAddress?.addressId == addressId) {
          _ref
              .read(selectedAddressProvider.notifier)
              .state =
          addresses != null && addresses.isNotEmpty ? addresses.first : null;
        }
      }

      return success;
    } catch (e) {
      _ref
          .read(addressErrorProvider.notifier)
          .state = 'Failed to delete address';
      print('AddressNotifier: Error deleting address: $e');
      return false;
    } finally {
      _ref
          .read(addressLoadingProvider.notifier)
          .state = false;
    }
  }

  // Select an address
  void selectAddress(AddressModel address) {
    // Check if this is a guest user
    if (address.userId.startsWith('guest-')) {
      _ref
          .read(guestAddressProvider.notifier)
          .state = address;
    } else {
      _ref
          .read(selectedAddressProvider.notifier)
          .state = address;
    }
  }

  // Clear all address data (for logout)
  void clearAddressData() {
    _ref.read(addressesProvider.notifier).state = [];
    _ref.read(selectedAddressProvider.notifier).state = null;
    _ref.read(addressErrorProvider.notifier).state = null;
    _ref.read(guestAddressProvider.notifier).state = null;
  }

  // Modify the clearAddresses method to clear ALL address data including guest addresses
  void clearAddresses() {
    _ref.read(addressesProvider.notifier).state = null;
    _ref.read(selectedAddressProvider.notifier).state = null;
    //_ref.read(guestAddressProvider.notifier).state = null; // IMPORTANT: Clear guest address too
    _ref.read(addressErrorProvider.notifier).state = null;
    print('All address data cleared');
  }

// Add a new method to clear absolutely everything
  void clearAllAddressData() {
    clearAddresses();
    //clearGuestAddress();
    // Force invalidate all providers to ensure complete reset
    _ref.invalidate(addressesProvider);
    _ref.invalidate(selectedAddressProvider);
    //_ref.invalidate(guestAddressProvider);
    _ref.invalidate(addressErrorProvider);
    print('Address providers completely reset');
  }
}

// Provider for the address notifier
final addressNotifierProvider = StateNotifierProvider<AddressNotifier, AsyncValue<void>>((ref) {
  final addressService = ref.watch(addressServiceProvider);
  return AddressNotifier(addressService, ref);
});
