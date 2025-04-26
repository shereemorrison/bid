import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'base_state.dart';

abstract class BaseNotifier<T extends BaseState> extends StateNotifier<T> {
  BaseNotifier(T initialState) : super(initialState);

  // Common error handling
  void handleError(String operation, dynamic error) {
    state = state.copyWithBase(
      error: 'Error $operation: $error',
      isLoading: false,
    ) as T;
  }

  // Start loading with error clearing
  void startLoading() {
    state = state.copyWithBase(
      isLoading: true,
      clearError: true,
    ) as T;
  }

  // End loading
  void endLoading() {
    state = state.copyWithBase(
      isLoading: false,
    ) as T;
  }
}
