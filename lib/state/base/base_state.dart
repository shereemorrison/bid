import 'package:flutter/foundation.dart';

@immutable
abstract class BaseState {
  final bool isLoading;
  final String? error;

  const BaseState({
    this.isLoading = false,
    this.error,
  });

  // Abstract copyWith that will be implemented by subclasses
  BaseState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  });
}
