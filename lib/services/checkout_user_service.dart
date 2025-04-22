import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

//Identifies users, creates guest users (when needed) and creates addresses at checkout
class UserAddressService {
  final SupabaseClient _supabase;

  UserAddressService(this._supabase);

  // Generate a valid UUID
  String _generateUuid() {
    return const Uuid().v4();
  }

  // Handle user and address creation/lookup
  Future<Map<String, dynamic>> handleUserAndAddress({
    required String userId,
    required dynamic shippingAddress,
    required bool isGuestCheckout,
  }) async {
    String userIdForDb;
    String? shippingAddressId;

    if (isGuestCheckout) {
      final guestResult = await _createGuestUser(shippingAddress);
      userIdForDb = guestResult['userIdForDb'];
      shippingAddressId = guestResult['shippingAddressId'];
    } else {
      // CRITICAL FIX: Determine if userId is an auth_id or user_id
      final isAuthId = await _isAuthId(userId);

      if (isAuthId) {
        // print('Provided ID is an auth_id, handling registered user by auth_id');
        final registeredResult = await _handleRegisteredUserByAuthId(userId, shippingAddress);
        userIdForDb = registeredResult['userIdForDb'];
        shippingAddressId = registeredResult['shippingAddressId'];
      } else {
        // print('Provided ID is a user_id, using directly');
        // If it's already a user_id, we can use it directly
        userIdForDb = userId;

        // Create shipping address if needed
        if (shippingAddress != null) {
          try {
            // Get email for shipping address
            final userRecord = await _supabase
                .from('users')
                .select('email')
                .eq('user_id', userId)
                .single();

            final userEmail = userRecord['email'];

            shippingAddressId = await _createShippingAddress(
                userIdForDb,
                shippingAddress,
                userEmail
            );
          } catch (e) {
            print('Error creating shipping address: $e');
            // Continue without address if it fails
          }
        }
      }
    }

    return {
      'userIdForDb': userIdForDb,
      'shippingAddressId': shippingAddressId,
    };
  }

  // Helper method to determine if an ID is an auth_id
  Future<bool> _isAuthId(String id) async {
    // First check if this ID exists in the auth system
    final session = _supabase.auth.currentSession;
    if (session != null && session.user.id == id) {
      return true; // It's definitely an auth_id
    }

    // Then check if it exists as an auth_id in our users table
    final authIdCheck = await _supabase
        .from('users')
        .select('user_id')
        .eq('auth_id', id)
        .maybeSingle();

    if (authIdCheck != null) {
      return true; // It exists as an auth_id in our users table
    }

    // Finally check if it exists as a user_id in our users table
    final userIdCheck = await _supabase
        .from('users')
        .select('user_id')
        .eq('user_id', id)
        .maybeSingle();

    if (userIdCheck != null) {
      return false; // It exists as a user_id, so it's not an auth_id
    }

    // If we can't determine for sure, assume it's an auth_id (default behavior)
    return true;
  }

  // Create guest user
  Future<Map<String, dynamic>> _createGuestUser(dynamic shippingAddress) async {
    try {
      print('Creating guest user record...');

      // Generate a random email for the guest user if not provided
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomSuffix = _generateUuid().substring(0, 8); // Take first 8 chars of UUID
      final guestEmail = shippingAddress.email ?? 'guest_${timestamp}_${randomSuffix}@example.com';

      // Generate a pure UUID for the auth_id (no prefix)
      final guestAuthId = _generateUuid();

      // Create a proper UUID for the user_id
      final guestUserId = _generateUuid();

      // Use firstName and lastName instead of name
      final firstName = shippingAddress.firstName ?? '';
      final lastName = shippingAddress.lastName ?? '';

      final guestUserResponse = await _supabase
          .from('users')
          .insert({
        'user_id': guestUserId,
        'email': guestEmail,
        'auth_id': guestAuthId, // Pure UUID format
        'user_type': 'guest',
        'first_name': firstName,
        'last_name': lastName,
        'phone': shippingAddress.phone ?? '',
        'created_at': DateTime.now().toIso8601String(),
        'is_registered': false, // Make sure this is set to false for guests
      })
          .select('user_id')
          .single();

      final userIdForDb = guestUserResponse['user_id'];
      print('Created guest user with ID: $userIdForDb');

      // Create shipping address record
      String? shippingAddressId;
      try {
        shippingAddressId = await _createShippingAddress(userIdForDb, shippingAddress, guestEmail);
      } catch (e) {
        print('Error creating shipping address: $e');
        // Continue without address if it fails
      }

      return {
        'userIdForDb': userIdForDb,
        'shippingAddressId': shippingAddressId,
      };
    } catch (e) {
      print('Error creating guest user: $e');
      throw Exception('Failed to create guest user: $e');
    }
  }

  // Renamed method to clarify it's for auth_id lookup
  Future<Map<String, dynamic>> _handleRegisteredUserByAuthId(String authId, dynamic shippingAddress) async {
    try {
      print('Looking up registered user for auth_id: $authId');

      // Get the current authenticated user's email
      final session = _supabase.auth.currentSession;
      String? authEmail;

      if (session != null && session.user.id == authId) {
        authEmail = session.user.email;
        print('Found authenticated user email: $authEmail');
      }

      String userIdForDb;
      String? shippingAddressId;

      // CRITICAL: First try to find user by email - this is the most reliable way
      var userQuery = [];
      if (authEmail != null) {
        print('Looking up user by email first: $authEmail');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email, auth_id')
            .eq('email', authEmail);

        if (userQuery.isNotEmpty) {
          print('Found user by email: ${userQuery[0]['user_id']} with email: ${userQuery[0]['email']}');

          // If found by email but auth_id doesn't match, update the auth_id
          if (userQuery[0]['auth_id'] != authId) {
            print('Updating auth_id from ${userQuery[0]['auth_id']} to $authId');
            await _supabase
                .from('users')
                .update({'auth_id': authId})
                .eq('user_id', userQuery[0]['user_id']);
            print('Updated auth_id for user found by email');
          }
        }
      }

      // If not found by email, try by auth_id
      if (userQuery.isEmpty) {
        print('User not found by email, trying by auth_id: $authId');
        userQuery = await _supabase
            .from('users')
            .select('user_id, email')
            .eq('auth_id', authId);
      }

      // If user doesn't exist in our users table, we should NOT create one during checkout
      // This is a critical error - the user should be registered or logged in before checkout
      if (userQuery.isEmpty) {
        throw Exception('User not found in database. Please register or log in before checkout.');
      }

      // User exists, get their ID
      userIdForDb = userQuery[0]['user_id'];
      print('Found existing user_id: $userIdForDb with email: ${userQuery[0]['email']}');

      // Update auth_id if it doesn't match and ensure email is correct
      if (authEmail != null && userQuery[0]['email'] != authEmail) {
        await _supabase
            .from('users')
            .update({
          'auth_id': authId,
          'email': authEmail, // Ensure email is always up to date
        })
            .eq('user_id', userIdForDb);
        print('Updated auth_id and email for user: $userIdForDb');
      }

      // Get or create shipping address for registered user
      if (shippingAddress != null) {
        try {
          // Always use the authenticated email for shipping address if available
          final emailForShipping = authEmail ??
              (userQuery.isNotEmpty ? userQuery[0]['email'] : null) ??
              shippingAddress.email;

          shippingAddressId = await _createShippingAddress(
              userIdForDb,
              shippingAddress,
              emailForShipping
          );
        } catch (e) {
          print('Error creating shipping address: $e');
          // Continue without address if it fails
        }
      }

      return {
        'userIdForDb': userIdForDb,
        'shippingAddressId': shippingAddressId,
      };
    } catch (e) {
      print('Error handling registered user: $e');
      throw Exception('Error handling registered user: $e');
    }
  }

  // Create shipping address
  Future<String> _createShippingAddress(String userIdForDb, dynamic shippingAddress, String? fallbackEmail) async {
    // print('Creating shipping address record...');
    final addressResponse = await _supabase
        .from('addresses')
        .insert({
      'address_id': _generateUuid(),
      'user_id': userIdForDb,
      'address_type': 'shipping',
      'is_default': true,
      'first_name': shippingAddress.firstName ?? '',
      'last_name': shippingAddress.lastName ?? '',
      'phone': shippingAddress.phone ?? '',
      'email': shippingAddress.email ?? fallbackEmail ?? '',
      'street_address': shippingAddress.streetAddress ?? '',
      'apartment': shippingAddress.apartment ?? '',
      'city': shippingAddress.city ?? '',
      'state': shippingAddress.state ?? '',
      'postal_code': shippingAddress.postalCode ?? '',
      'country': shippingAddress.country ?? 'US',
      'created_at': DateTime.now().toIso8601String(),
    })
        .select('address_id')
        .single();

    final shippingAddressId = addressResponse['address_id'];
    print('Created shipping address with ID: $shippingAddressId');
    return shippingAddressId;
  }
}
