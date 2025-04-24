import 'package:bid/models/address_model.dart';
import 'package:bid/respositories/address_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'address_state.dart';

class AddressNotifier extends StateNotifier<AddressState> {
  final AddressRepository _addressRepository;

  AddressNotifier({required AddressRepository addressRepository})
      : _addressRepository = addressRepository,
        super(AddressState.initial());

  Future<void> fetchUserAddresses(String userId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final addresses = await _addressRepository.getUserAddresses(userId);

      // Find default address
      Address? defaultAddress;
      if (addresses.isNotEmpty) {
        defaultAddress = addresses.firstWhere(
              (address) => address.isDefault,
          orElse: () => addresses.first,
        );
      }

      state = state.copyWith(
        addresses: addresses,
        selectedAddress: defaultAddress,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch addresses: $e',
        isLoading: false,
      );
    }
  }

  Future<bool> addAddress(Address address) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final success = await _addressRepository.addAddress(address);

      if (success) {
        // Refresh addresses
        await fetchUserAddresses(address.userId);
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to add address',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Error adding address: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> updateAddress(Address address) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final success = await _addressRepository.updateAddress(address);

      if (success) {
        // Refresh addresses
        await fetchUserAddresses(address.userId);
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to update address',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Error updating address: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId, String userId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final success = await _addressRepository.deleteAddress(addressId);

      if (success) {
        // Refresh addresses
        await fetchUserAddresses(userId);
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to delete address',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Error deleting address: $e',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> setDefaultAddress(String userId, String addressId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final success = await _addressRepository.setDefaultAddress(userId, addressId);

      if (success) {
        // Refresh addresses
        await fetchUserAddresses(userId);
        return true;
      } else {
        state = state.copyWith(
          error: 'Failed to set default address',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Error setting default address: $e',
        isLoading: false,
      );
      return false;
    }
  }

  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
  }
}
