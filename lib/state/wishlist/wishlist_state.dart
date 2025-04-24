import 'package:flutter/foundation.dart';

@immutable
class WishlistState {
  final List<String> productIds;
  final bool isLoading;
  final String? error;

  const WishlistState({
    this.productIds = const [],
    this.isLoading = false,
    this.error,
  });

  WishlistState copyWith({
    List<String>? productIds,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return WishlistState(
      productIds: productIds ?? this.productIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  factory WishlistState.initial() {
    return const WishlistState(
      productIds: [],
      isLoading: false,
      error: null,
    );
  }
}
