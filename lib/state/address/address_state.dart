import 'package:flutter/foundation.dart';
import '../../models/address_model.dart';

@immutable
class AddressState {
  final List<Address> addresses;
  final Address? selectedAddress;
  final bool isLoading;
  final String? error;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    this.isLoading = false,
    this.error,
  });

  AddressState copyWith({
    List<Address>? addresses,
    Address? selectedAddress,
    bool? isLoading,
    String? error,
    bool clearSelectedAddress = false,
    bool clearError = false,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      selectedAddress: clearSelectedAddress ? null : selectedAddress ?? this.selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory AddressState.initial() {
    return const AddressState(
      addresses: [],
      selectedAddress: null,
      isLoading: false,
      error: null,
    );
  }
}
