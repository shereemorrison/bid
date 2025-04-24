import 'package:flutter/foundation.dart';
import '../../models/user_model.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;
  final UserData? userData;
  final String? userId;

  const AuthState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.error,
    this.userData,
    this.userId,
  });

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
