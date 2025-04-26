import 'package:flutter/foundation.dart';
import '../../models/address_model.dart';
import '../base/base_state.dart';

@immutable
class AddressState extends BaseState {
  final List<Address> addresses;
  final Address? selectedAddress;

  const AddressState({
    this.addresses = const [],
    this.selectedAddress,
    bool isLoading = false,
    String? error,
  }) : super(isLoading: isLoading, error: error);

  @override
  AddressState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AddressState(
      addresses: addresses,
      selectedAddress: selectedAddress,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

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
