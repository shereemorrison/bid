
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

// Service provider
final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});

// State providers
final userDataProvider = StateProvider<UserModel?>((ref) => null);
final userLoadingProvider = StateProvider<bool>((ref) => false);
final userErrorProvider = StateProvider<String?>((ref) => null);

// Controller notifier for complex state management
class UserNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;
  final UserService _userService;

  UserNotifier(this._ref, this._userService) : super(const AsyncValue.data(null));

  // Set user data
  void setUserData(UserModel userData) {
    _ref.read(userDataProvider.notifier).state = userData;
  }

  // Clear user data (e.g., on logout)
  void clearUserData() {
    _ref.read(userDataProvider.notifier).state = null;
  }

  // Update user data - fetch from database using userId
  Future<void> updateUserData(String userId) async {
    _ref.read(userLoadingProvider.notifier).state = true;
    _ref.read(userErrorProvider.notifier).state = null;

    try {
      // Fetch user data from service
      final userData = await _userService.getUserData(userId);

      if (userData != null) {
        _ref.read(userDataProvider.notifier).state = userData;
      } else {
        _ref.read(userErrorProvider.notifier).state = 'User data not found';
      }
    } catch (e) {
      _ref.read(userErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(userLoadingProvider.notifier).state = false;
    }
  }

  // Update specific user model
  Future<void> updateUserModel(UserModel userData) async {
    _ref.read(userLoadingProvider.notifier).state = true;
    _ref.read(userErrorProvider.notifier).state = null;

    try {
      // Update user in database
      final success = await _userService.updateUser(userData);

      if (success) {
        _ref.read(userDataProvider.notifier).state = userData;
      } else {
        _ref.read(userErrorProvider.notifier).state = 'Failed to update user data';
      }
    } catch (e) {
      _ref.read(userErrorProvider.notifier).state = e.toString();
    } finally {
      _ref.read(userLoadingProvider.notifier).state = false;
    }
  }
}

// Provider for the user notifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, AsyncValue<void>>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserNotifier(ref, userService);
});
