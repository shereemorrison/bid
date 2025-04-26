import 'package:bid/models/user_model.dart';
import 'package:flutter/foundation.dart';
import '../base/base_state.dart';

@immutable
class AuthState extends BaseState {
  final bool isLoggedIn;
  final UserData? userData;
  final String? userId;

  const AuthState({
    this.isLoggedIn = false,
    bool isLoading = false,
    String? error,
    this.userData,
    this.userId,
  }) : super(isLoading: isLoading, error: error);

  @override
  AuthState copyWithBase({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      userData: userData,
      userId: userId,
    );
  }

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
    UserData? userData,
    String? userId,
    bool clearError = false,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      userData: userData ?? this.userData,
      userId: userId ?? this.userId,
    );
  }

  factory AuthState.initial() {
    return const AuthState(
      isLoggedIn: false,
      isLoading: true, // Start with loading to check auth state
      error: null,
      userData: null,
      userId: null,
    );
  }
}
