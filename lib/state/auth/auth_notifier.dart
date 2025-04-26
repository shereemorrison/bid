import 'package:bid/providers.dart';
import 'package:bid/respositories/user_repository.dart';
import 'package:bid/services/app_state_coordinator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../base/base_notifier.dart';
import 'auth_state.dart';

class AuthNotifier extends BaseNotifier<AuthState> {
  final UserRepository _userRepository;
  final Ref _ref;
  final AppStateCoordinator _stateCoordinator;

  AuthNotifier({
    required UserRepository userRepository,
    required Ref ref,
    required AppStateCoordinator stateCoordinator,
  }) : _userRepository = userRepository,
        _ref = ref,
        _stateCoordinator = stateCoordinator,
        super(AuthState.initial()) {
    // Initialize auth state
    print("AuthNotifier: Initializing");
    _initAuthState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _userRepository.authStateChanges().listen((isLoggedIn) {
      print("AuthNotifier: Auth state changed, isLoggedIn=$isLoggedIn");
      if (isLoggedIn) {
        _handleSignIn();
      } else {
        _handleSignOut();
      }
    });
  }

  Future<void> _initAuthState() async {
    print("AuthNotifier: _initAuthState called");
    final isLoggedIn = _userRepository.isLoggedIn;
    final userId = _userRepository.currentUserId;

    print("AuthNotifier: isLoggedIn=$isLoggedIn, userId=$userId");

    try {
      if (isLoggedIn && userId != null) {
        state = state.copyWith(
          isLoggedIn: true,
          userId: userId,
          isLoading: true,
        );

        await _loadUserData(userId);
      } else {
        print("AuthNotifier: Not logged in, setting isLoading=false");
        state = state.copyWith(
          isLoggedIn: false,
          isLoading: false,
          userData: null,
          userId: null,
        );
      }
    } catch (e) {
      print("AuthNotifier: Error in _initAuthState: $e");
      handleError('initializing auth', e);
    }
  }

  Future<void> _handleSignIn() async {
    final userId = _userRepository.currentUserId;
    if (userId != null) {
      state = state.copyWith(
        isLoggedIn: true,
        userId: userId,
        isLoading: true,
      );

      await _loadUserData(userId);

      // Use the state coordinator to handle sign in
      await _stateCoordinator.handleUserSignIn(userId);
    }
  }

  Future<void> _handleSignOut() async {
    // Use the state coordinator to handle sign out
    await _stateCoordinator.handleUserSignOut();

    state = state.copyWith(
      isLoggedIn: false,
      isLoading: false,
      userData: null,
      userId: null,
    );
  }

  Future<void> _loadUserData(String userId) async {
    print("AuthNotifier: Loading user data for $userId");
    try {
      final userData = await _userRepository.getUserProfile(userId);
      print("AuthNotifier: User data loaded: ${userData != null}");
      if (userData != null) {
        print("AuthNotifier: First name: ${userData.firstName}, Last name: ${userData.lastName}");
      }

      state = state.copyWith(
        userData: userData,
        isLoading: false,
        clearError: true,
      );
      print("AuthNotifier: isLoading set to false after loading user data");
    } catch (e) {
      print("AuthNotifier: Error loading user data: $e");
      handleError('loading user data', e);
    }
  }

  Future<void> signIn(String email, String password) async {
    startLoading();

    try {
      final response = await _userRepository.signInWithEmail(email, password);

      if (response.user == null) {
        state = state.copyWith(
          error: 'Sign in failed',
          isLoading: false,
        );
      }
      // Auth state listener will handle the rest if successful
    } catch (e) {
      handleError('signing in', e);
    }
  }

  Future<void> signUp(String email, String password, {
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    startLoading();

    try {
      final response = await _userRepository.signUpWithEmail(
        email,
        password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (response.user != null) {
        // Delay to ensure the database has time to update before loading user data
        await Future.delayed(Duration(milliseconds: 500));

        // Force refresh user data instead of waiting for auth state listener
        await _loadUserData(response.user!.id);
      } else {
        state = state.copyWith(
          error: 'Sign up failed',
          isLoading: false,
        );
      }
    } catch (e) {
      handleError('signing up', e);
    }
  }

  Future<void> signOut() async {
    startLoading();

    try {
      // Use the state coordinator to reset app state
      await _stateCoordinator.resetAppState();

      // Sign out from Supabase
      await _userRepository.signOut();

      // Explicitly set the state to logged out and not loading
      state = AuthState.initial().copyWith(isLoading: false);

      print("AuthNotifier: Sign out complete, isLoading=${state.isLoading}, isLoggedIn=${state.isLoggedIn}");
    } catch (e) {
      handleError('signing out', e);
      // Even if there's an error, make sure we're not stuck in loading state
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (state.userId == null) return;

    startLoading();

    try {
      final success = await _userRepository.updateUserProfile(state.userId!, data);

      if (success) {
        await _loadUserData(state.userId!);
      } else {
        state = state.copyWith(
          error: 'Failed to update profile',
          isLoading: false,
        );
      }
    } catch (e) {
      handleError('updating profile', e);
    }
  }

  Future<void> resetPassword(String email) async {
    startLoading();

    try {
      await _userRepository.resetPassword(email);
      endLoading();
    } catch (e) {
      handleError('resetting password', e);
    }
  }

  Future<void> refreshUserData() async {
    final userId = _userRepository.currentUserId;
    if (userId != null) {
      state = state.copyWith(isLoading: true);
      await _loadUserData(userId);
    }
  }
}
