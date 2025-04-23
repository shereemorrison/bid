import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/checkout_session_data.dart';
import '../services/auth_service.dart';
import '../services/checkout_session_manager.dart';

/// Handles converting a guest user to a registered user
///
/// This class is responsible for:
/// - Taking guest checkout data and creating a registered user
/// - Preserving shipping/billing information during conversion
/// - Updating the checkout session after conversion
class GuestToRegisteredConverter {
  final Ref _ref;
  final AuthService _authService;

  GuestToRegisteredConverter(this._ref, this._authService);

  // Convert guest checkout to registered user
  Future<bool> convertGuestToRegistered({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
  }) async {
    try {
      final sessionManager = _ref.read(checkoutSessionManagerProvider);
      final currentSession = sessionManager.getCurrentSession();

      if (currentSession == null || !currentSession.isGuestCheckout) {
        print('No guest checkout session to convert');
        return false;
      }

      // Use the AuthService to convert guest to registered user
      final response = await _authService.convertGuestToRegistered(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );

      if (!response) {
        print('Failed to create user account');
        return false;
      }

      print('Successfully converted guest checkout to registered user');
      return true;
    } catch (e) {
      print('Error converting guest to registered user: $e');
      return false;
    }
  }
}

// Provider for the guest to registered converter
final guestToRegisteredConverterProvider = Provider<GuestToRegisteredConverter>((ref) {
  final authService = ref.watch(authServiceProvider);
  return GuestToRegisteredConverter(ref, authService);
});
