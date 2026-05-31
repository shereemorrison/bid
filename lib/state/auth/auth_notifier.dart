import 'package:bid/core/providers/cart_providers.dart';
import 'package:bid/core/providers/checkout_helpers.dart';
import 'package:bid/core/providers/orders_providers.dart';
import 'package:bid/core/providers/session_providers.dart';
import 'package:bid/core/providers/wishlist_providers.dart';
import 'package:bid/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../base/base_notifier.dart';
import 'auth_state.dart';

class AuthNotifier extends BaseNotifier<AuthState> {
  final UserRepository _userRepository;
  final Ref _ref;
  bool _isSigningOut = false;

  AuthNotifier({
    required UserRepository userRepository,
    required Ref ref,
  })  : _userRepository = userRepository,
        _ref = ref,
        super(AuthState.initial()) {
    _initAuthState();
    _setupAuthListener();
  }

  void _setupAuthListener() {
    _userRepository.authStateChanges().listen((isLoggedIn) {
      if (_isSigningOut) return;
      if (isLoggedIn) {
        _handleSignIn();
      } else {
        _handleSignOut();
      }
    });
  }

  Future<void> _initAuthState() async {
    final isLoggedIn = _userRepository.isLoggedIn;
    final userId = _userRepository.currentUserId;

    try {
      if (isLoggedIn && userId != null) {
        state = state.copyWith(isLoggedIn: true, isLoading: true);
        await _loadUserData(userId);
      } else {
        state = state.copyWith(
          isLoggedIn: false,
          isLoading: false,
          userData: null,
          userId: null,
        );
      }
    } catch (e) {
      handleError('initializing auth', e);
    }
  }

  Future<void> _handleSignIn() async {
    final authId = _userRepository.currentUserId;
    if (authId == null) return;

    state = state.copyWith(isLoading: true);
    await _loadUserData(authId);

    final dbUserId = state.userData?.userId;
    if (dbUserId != null) {
      await _onUserSignedIn(dbUserId);
    }
  }

  Future<void> _handleSignOut() async {
    await _resetAppState();

    state = state.copyWith(
      isLoggedIn: false,
      isLoading: false,
      userData: null,
      userId: null,
    );
  }

  Future<void> _loadUserData(String authId) async {
    try {
      final userData = await _userRepository.getOrCreateUserForAuthSession();

      state = state.copyWith(
        userData: userData,
        userId: userData?.userId,
        isLoggedIn: _userRepository.isLoggedIn,
        isLoading: false,
        error: userData == null ? 'Could not load your account profile.' : null,
        clearError: userData != null,
      );
    } catch (e) {
      handleError('loading user data', e);
    }
  }

  Future<void> _onUserSignedIn(String userId) async {
    final guestUserId = _ref.read(sessionProvider).guestUserId;
    if (guestUserId != null && guestUserId != userId) {
      await _userRepository.mergeGuestProfileIntoRegistered(
        guestUserId: guestUserId,
        registeredUserId: userId,
      );
      await refreshUserData();
    }

    await _ref.read(cartProvider.notifier).mergeGuestCartOnSignIn();
    await _ref.read(wishlistProvider.notifier).refreshWishlist();
    await _ref.read(ordersProvider.notifier).fetchUserOrders(userId);
    _ref.read(sessionProvider.notifier).clearGuestState();
  }

  Future<void> _resetAppState() async {
    await _ref.read(cartProvider.notifier).resetOnSignOut();
    _ref.read(ordersProvider.notifier).clearOrders();
    _ref.read(wishlistProvider.notifier).clearWishlist();
    _ref.read(sessionProvider.notifier).clearGuestState();
    resetCheckoutState(_ref);
  }

  Future<void> signIn(String email, String password) async {
    startLoading();

    try {
      final response = await _userRepository.signInWithEmail(email, password);

      if (response.user == null) {
        state = state.copyWith(
          error: 'Invalid email or password.',
          isLoading: false,
          isLoggedIn: false,
        );
        return;
      }

      final userData = await _userRepository.getOrCreateUserForAuthSession();
      if (userData == null) {
        state = state.copyWith(
          error: 'Signed in, but your profile could not be loaded.',
          isLoading: false,
          isLoggedIn: false,
        );
        return;
      }

      state = state.copyWith(
        isLoggedIn: true,
        userData: userData,
        userId: userData.userId,
        isLoading: false,
        clearError: true,
      );

      await _onUserSignedIn(userData.userId);
    } catch (e) {
      final message = e.toString().contains('Invalid login credentials')
          ? 'Invalid email or password.'
          : 'Sign in failed: $e';
      state = state.copyWith(
        error: message,
        isLoading: false,
        isLoggedIn: false,
      );
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
        await Future.delayed(const Duration(milliseconds: 500));
        await _loadUserData(response.user!.id);
      } else {
        state = state.copyWith(error: 'Sign up failed', isLoading: false);
      }
    } catch (e) {
      handleError('signing up', e);
    }
  }

  Future<void> signOut() async {
    _isSigningOut = true;

    try {
      await _resetAppState();
      await _userRepository.signOut();
    } catch (e) {
      // Still clear local state on error
    } finally {
      _isSigningOut = false;
      state = const AuthState(
        isLoggedIn: false,
        isLoading: false,
        userData: null,
        userId: null,
      );
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final authId = _userRepository.currentUserId;
    if (authId == null) return;

    startLoading();

    try {
      final success = await _userRepository.updateUserProfile(authId, data);

      if (success) {
        await _loadUserData(authId);
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
    final authId = _userRepository.currentUserId;
    if (authId == null) return;

    if (state.userData == null) {
      state = state.copyWith(isLoading: true);
    }
    await _loadUserData(authId);
  }
}
