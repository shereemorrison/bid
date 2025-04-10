import 'package:bid/models/address_model.dart';
import 'package:bid/services/address_service.dart';
import 'package:flutter/material.dart';

class AddressProvider with ChangeNotifier {
  final AddressService _addressService = AddressService();
  List<AddressModel>? _addresses;
  AddressModel? _selectedAddress;
  AddressModel? _guestAddress; // For guest users
  bool _isLoading = false;
  String? _error;

  List<AddressModel>? get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress ?? _guestAddress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all addresses for a user
  Future<void> fetchUserAddresses(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _addresses = await _addressService.getUserAddresses(userId);

      // If there's a default shipping address, select it
      if (_addresses != null && _addresses!.isNotEmpty) {
        _selectedAddress = _addresses!.firstWhere(
              (address) => address.isDefault && address.addressType == 'shipping',
          orElse: () => _addresses!.first,
        );
      }
    } catch (e) {
      _error = 'Failed to load addresses';
      print('AddressProvider: Error fetching addresses: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new address
  Future<AddressModel?> addAddress(AddressModel address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if this is a guest user
      if (address.userId.startsWith('guest-')) {
        // For guest users, just store the address in memory
        _guestAddress = address;
        _isLoading = false;
        notifyListeners();
        return address;
      }

      // For logged-in users, save to database
      final newAddress = await _addressService.addAddress(address);

      if (newAddress != null) {
        // Refresh the address list
        await fetchUserAddresses(address.userId);

        // If this is the default address or we don't have a selected address yet, select it
        if (address.isDefault || _selectedAddress == null) {
          _selectedAddress = newAddress;
        }
      }

      return newAddress;
    } catch (e) {
      _error = 'Failed to add address';
      print('AddressProvider: Error adding address: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update an existing address
  Future<bool> updateAddress(AddressModel address) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if this is a guest user
      if (address.userId.startsWith('guest-')) {
        // For guest users, just update the address in memory
        _guestAddress = address;
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // For logged-in users, update in database
      final success = await _addressService.updateAddress(address);

      if (success) {
        // Refresh the address list
        await fetchUserAddresses(address.userId);

        // Update selected address if needed
        if (_selectedAddress?.addressId == address.addressId) {
          _selectedAddress = address;
        }
      }

      return success;
    } catch (e) {
      _error = 'Failed to update address';
      print('AddressProvider: Error updating address: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Delete an address
  Future<bool> deleteAddress(String addressId, String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if this is a guest user
      if (userId.startsWith('guest-')) {
        // For guest users, just clear the address in memory
        if (_guestAddress?.addressId == addressId) {
          _guestAddress = null;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }

      // For logged-in users, delete from database
      final success = await _addressService.deleteAddress(addressId, userId);

      if (success) {
        // Refresh the address list
        await fetchUserAddresses(userId);

        // If we deleted the selected address, select another one
        if (_selectedAddress?.addressId == addressId) {
          _selectedAddress = _addresses!.isNotEmpty ? _addresses!.first : null;
        }
      }

      return success;
    } catch (e) {
      _error = 'Failed to delete address';
      print('AddressProvider: Error deleting address: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Select an address
  void selectAddress(AddressModel address) {
    // Check if this is a guest user
    if (address.userId.startsWith('guest-')) {
      _guestAddress = address;
    } else {
      _selectedAddress = address;
    }
    notifyListeners();
  }

  // Clear addresses (e.g., on logout)
  void clearAddresses() {
    _addresses = null;
    _selectedAddress = null;
    // Don't clear _guestAddress here to preserve guest checkout flow
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  // Clear guest address (e.g., after order completion)
  void clearGuestAddress() {
    _guestAddress = null;
    notifyListeners();
  }
}
