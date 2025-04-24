import 'package:bid/respositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final UserRepository _userRepository;

  AuthNotifier({required UserRepository userRepository})
      : _userRepository = userRepository,
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
          isLoading: false,  // This is crucial
          userData: null,
          userId: null,
        );
      }
    } catch (e) {
      print("AuthNotifier: Error in _initAuthState: $e");
      // Make sure to set isLoading to false even if there's an error
      state = state.copyWith(
        isLoading: false,
        error: "Error initializing auth: $e",
      );
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
    }
  }

  void _handleSignOut() {
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
      state = state.copyWith(
        error: 'Failed to load user data: $e',
        isLoading: false,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _userRepository.signInWithEmail(email, password);

      if (response.user != null) {
        // Auth state listener will handle the rest
      } else {
        state = state.copyWith(
          error: 'Sign in failed',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signUp(String email, String password, {
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final response = await _userRepository.signUpWithEmail(
        email,
        password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (response.user != null) {
        // IMPORTANT: Add a small delay to ensure the database has time to update
        // before we try to load the user data
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
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _userRepository.signOut();
      // Auth state listener will handle the rest
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (state.userId == null) return;

    state = state.copyWith(isLoading: true, clearError: true);

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
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await _userRepository.resetPassword(email);

      state = state.copyWith(
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
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
