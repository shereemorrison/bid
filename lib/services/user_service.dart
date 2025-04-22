import 'dart:math';
import 'package:bid/models/address_model.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'package:uuid/uuid.dart';


class UserService {
  final _supabase = SupabaseConfig.client;

  // Create a new user in the users table
  Future<void> createUser({
    required String authId,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    print("Attempting to create user with authId: $authId, email: $email");
    try {

      final session = _supabase.auth.currentSession;
      String actualEmail = email;

      if (session != null && session.user.id == authId) {
        actualEmail = session.user.email ?? email;
        print('Using authenticated email from session: $actualEmail');
      }

      final existingUserByEmail = email.isNotEmpty ? await _supabase
          .from('users')
          .select('user_id, auth_id')
          .eq('email', email)
          .maybeSingle() : null;

      final existingUserByAuthId = await _supabase
          .from('users')
          .select('user_id, email')
          .eq('auth_id', authId)
          .maybeSingle();

      // If user exists by email, update record with current auth_id
      if (existingUserByEmail != null) {
        print('Found user with matching email but different auth_id. Updating auth_id.');
        await _supabase.from('users').update({
          'auth_id': authId,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phone != null) 'phone': phone,
          'is_registered': true,
          'last_login': DateTime.now().toIso8601String(),
          if (address != null) 'address': address,
        }).eq('user_id', existingUserByEmail['user_id']);
        return;
      }

      print('Creating new user record');

      // If user exists by auth_id but email doesnt match, update the email
      if (existingUserByAuthId != null) {
        print('Updating existing user by auth_id');
        await _supabase.from('users').update({
          'email': email,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phone != null) 'phone': phone,
          'is_registered': true,
          'last_login': DateTime.now().toIso8601String(),
          if (address != null) 'address': address,
        }).eq('auth_id', authId);
        return;
      }
      print('Creating new user record');

      // Only create a new user if no existing user was found by email or auth_id
      print('No existing user found. Creating new user record with email: $actualEmail');

      // Generate a UUID for user_id
      final userId = _generateUuid();

      // Insert new user
      await _supabase.from('users').insert({
        'auth_id': authId,
        'email': email,
        'user_id': userId,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        'is_registered': true,
        'created_at': DateTime.now().toIso8601String(),
        'last_login': DateTime.now().toIso8601String(),
      }).select();
      print("User created successfully");
    } catch (e) {
      print("Error creating user: $e");
      rethrow;
    }
  }

  // Helper method to generate UUID
  String _generateUuid() {
    return const Uuid().v4();
  }

  Future<UserModel?> getUserData(String authId) async {
    try {
      // Get the current authenticated user's email
      final session = _supabase.auth.currentSession;
      String? authEmail;

      if (session != null && session.user.id == authId) {
        authEmail = session.user.email;
        print('Found authenticated user email for lookup: $authEmail');
      }

      // First try to find user by email if available (prioritize email lookup)
      var data;
      if (authEmail != null) {
        print('Looking up user by email first: $authEmail');
        data = await _supabase
            .from('users')
            .select()
            .eq('email', authEmail)
            .maybeSingle();

        // If found by email but auth_id doesn't match, update the auth_id
        if (data != null && data['auth_id'] != authId) {
          print('Found user by email, but auth_id doesn\'t match. Updating auth_id from ${data['auth_id']} to $authId');
          await _supabase
              .from('users')
              .update({'auth_id': authId})
              .eq('user_id', data['user_id']);
          print('Updated auth_id for user found by email');
        }
      }

      // If not found by email, try by auth_id
      if (data == null) {
        print('User not found by email, trying by auth_id: $authId');
        data = await _supabase
            .from('users')
            .select()
            .eq('auth_id', authId)
            .maybeSingle();
      }

      if (data == null) {
        print('UserService: No user data found for authId: $authId or email: $authEmail');
        return null;
      }

      print('Found user data: user_id=${data['user_id']}, auth_id=${data['auth_id']}, email=${data['email']}');

      UserModel user = UserModel.fromJson(data);
      final addresses = await getUserAddresses(user.userId);

      // Return a new user model with the addresses
      return UserModel(
        userId: user.userId,
        authId: user.authId,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        address: user.address,
        addresses: addresses,
        isRegistered: user.isRegistered,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
      );
    } catch (e) {
      print('UserService: Error fetching user data: $e');
      return null;
    }
  }

  // Get user addresses
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    try {
      final data = await _supabase
          .from('addresses') // Assuming your table is named 'addresses'
          .select()
          .eq('user_id', userId);

      if (data == null || data.isEmpty) {
        return [];
      }

      return List<AddressModel>.from(
          data.map((address) => AddressModel.fromJson(address))
      );
    } catch (e) {
      print('UserService: Error fetching user addresses: $e');
      return [];
    }
  }


  // Get user data from the users table by user_id
  Future<UserModel?> getUserDataById(int userId) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) {
        return null;
      }

      UserModel user = UserModel.fromJson(data);

      // Fetch addresses for this user
      final addresses = await getUserAddresses(user.userId);

      // Return a new user model with the addresses
      return UserModel(
        userId: user.userId,
        authId: user.authId,
        email: user.email,
        firstName: user.firstName,
        lastName: user.lastName,
        phone: user.phone,
        address: user.address,
        addresses: addresses,
        isRegistered: user.isRegistered,
        createdAt: user.createdAt,
        lastLogin: user.lastLogin,
      );
    } catch (e) {
      return null;
    }
  }

// Update user data in the users table
  Future<void> updateUserData({
    required String authId,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      final updates = {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
      };

      if (updates.isNotEmpty) {
        await _supabase
            .from('users')
            .update(updates)
            .eq('auth_id', authId);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Update last login timestamp
  Future<void> updateLastLogin(String authId) async {
    try {
      await _supabase.from('users').update({
        'last_login': DateTime.now().toIso8601String(),
      }).eq('auth_id', authId);
    } catch (e) {
      // Silently fail - updating last login is not critical
    }
  }

  // Get user orders
  Future<List<Map<String, dynamic>>> getUserOrders(String authId) async {
    try {
      final userData = await getUserData(authId);
      if (userData == null) {
        return [];
      }

      final data = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userData.userId);

      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      await _supabase
          .from('users')
          .update({
        'first_name': user.firstName,
        'last_name': user.lastName,
        'phone': user.phone,
        'address': user.address,
        // Add other fields as needed
      })
          .eq('user_id', user.userId);

      return true;
    } catch (e) {
      print('Error updating user: $e');
      return false;
    }
  }

  // Find user by email - direct method to get user_id by email
  Future<String?> findUserIdByEmail(String email) async {
    try {
      print('Directly looking up user by email: $email');
      final result = await _supabase
          .from('users')
          .select('user_id')
          .eq('email', email)
          .maybeSingle();

      if (result != null) {
        final userId = result['user_id'];
        print('Found user_id: $userId for email: $email');
        return userId;
      }

      print('No user found with email: $email');
      return null;
    } catch (e) {
      print('Error finding user by email: $e');
      return null;
    }
  }
}



