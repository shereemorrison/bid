import 'package:bid/models/address_model.dart';
import 'package:bid/respositories/address_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/base_notifier.dart';
import 'address_state.dart';

class AddressNotifier extends BaseNotifier<AddressState> {
  final AddressRepository _addressRepository;

  AddressNotifier({required AddressRepository addressRepository})
      : _addressRepository = addressRepository,
        super(AddressState.initial());

  Future<void> fetchUserAddresses(String userId) async {
    startLoading();

    try {
      // Check for empty user ID
      if (userId.isEmpty) {
        print('AddressNotifier: Empty user ID provided');
        state = state.copyWith(
          addresses: [],
          selectedAddress: null,
        );
        endLoading();
        return;
      }

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
      );
      endLoading();
    } catch (e) {
      handleError('fetching addresses', e);
    }
  }

  Future<bool> addAddress(Address address) async {
    startLoading();

    try {
      // Check for empty user ID
      if (address.userId.isEmpty) {
        print('AddressNotifier: Empty user ID in address');
        state = state.copyWith(
          error: 'Invalid user ID',
          isLoading: false,
        );
        return false;
      }

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
      handleError('adding address', e);
      return false;
    }
  }

  Future<bool> updateAddress(Address address) async {
    startLoading();

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
      handleError('updating address', e);
      return false;
    }
  }

  Future<bool> deleteAddress(String addressId, String userId) async {
    startLoading();

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
      handleError('deleting address', e);
      return false;
    }
  }

  Future<bool> setDefaultAddress(String userId, String addressId) async {
    startLoading();

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
      handleError('setting default address', e);
      return false;
    }
  }

  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
  }

  void clearAddresses() {
    state = state.copyWith(
      addresses: [],
      selectedAddress: null,
      isLoading: false,
      error: null,
    );
    print('Address state cleared');
  }
}
