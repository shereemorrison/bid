import 'package:flutter/foundation.dart';
import '../base/base_state.dart';

@immutable
class WishlistState extends BaseState {
  final List<String> productIds;

  const WishlistState({
    this.productIds = const [],
    bool isLoading = false,
    String? error,
  }) : super(isLoading: isLoading, error: error);

  @override
  WishlistState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return WishlistState(
      productIds: productIds,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

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
