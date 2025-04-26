import 'dart:math';
import 'package:bid/models/address_model.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';


class UserRepository extends BaseRepository {
  UserRepository({SupabaseClient? client}) : super(client: client);

  // Get current auth state
  bool get isLoggedIn {
    final result = client.auth.currentSession != null;
    print("UserRepository: isLoggedIn=$result");
    return result;
  }

  // Get current user ID
  String? get currentUserId => client.auth.currentUser?.id;

  // Sign in with email and password
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Sign up with email and password
  Future<AuthResponse> signUpWithEmail(String email,
      String password, {
        String? firstName,
        String? lastName,
        String? phone,
      }) async {
    final response = await client.auth.signUp(
      email: email,
      password: password,
    );

    // Create user record in database if signup successful
    if (response.user != null) {
      await createUserRecord(
        authId: response.user!.id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
      );
    }
    return response;
  }

  // Create or update user record in database
  Future<void> createUserRecord({
    required String authId,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    print("Creating user record for authId: $authId, email: $email");
    try {
      // Check if user already exists
      final existingUser = await client
          .from('users')
          .select('user_id')
          .eq('auth_id', authId)
          .maybeSingle();

      if (existingUser != null) {
        // Update existing user
        await client.from('users').update({
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

      // Generate a user ID (similar to your old implementation)
      final random = Random();
      final userId = random.nextInt(100000) + 1;

      // Insert new user
      await client.from('users').insert({
        'auth_id': authId,
        'email': email,
        'user_id': userId.toString(), // Make sure this matches your schema type
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        'is_registered': true,
        'created_at': DateTime.now().toIso8601String(),
        'last_login': DateTime.now().toIso8601String(),
      });

      print("User record created successfully");
    } catch (e) {
      print("Error creating user record: $e");
      // Don't rethrow - we don't want auth to fail if this fails
    }
  }

  // Sign out
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // Get user profile data
  Future<UserData?> getUserProfile(String userId) async {
    try {
      final response = await client
          .from('users')
          .select()
          .eq('auth_id', userId)
          .single();

      return UserData.fromJson(response);
    } catch (e) {
      print('Error fetching user profile: $e');
      return null;
    }
  }

  // Get user data by auth_id
  Future<UserData?> getUserByAuthId(String authId) async {
    try {
      print('UserRepository: Getting user data for auth_id: $authId');

      // Get user data
      final userData = await client
          .from('users')
          .select()
          .eq('auth_id', authId)
          .single();

      if (userData == null) {
        print('UserRepository: No user found for auth_id: $authId');
        return null;
      }

      print('UserRepository: Found user with user_id: ${userData['user_id']}');

      // Get addresses for this user
      final addresses = await getUserAddresses(userData['user_id'].toString());

      // Create UserData object with addresses
      final user = UserData.fromJson(userData);

      // Return a new user with addresses included
      return UserData(
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
      print('UserRepository: Error getting user data: $e');
      return null;
    }
  }

  // Get addresses for a user
  Future<List<Address>> getUserAddresses(String userId) async {
    try {
      final addressData = await client
          .from('addresses')
          .select()
          .eq('user_id', userId);

      if (addressData == null || addressData.isEmpty) {
        return [];
      }

      return List<Address>.from(
          addressData.map((addr) => Address.fromJson(addr))
      );
    } catch (e) {
      print('UserRepository: Error getting addresses: $e');
      return [];
    }
  }

  // Update user profile
  Future<bool> updateUserProfile(String userId,
      Map<String, dynamic> data) async {
    try {
      await client
          .from('users')
          .update(data)
          .eq('auth_id', userId);
      return true;
    } catch (e) {
      print('Error updating user profile: $e');
      return false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await client.auth.resetPasswordForEmail(email);
  }

  // Listen to auth state changes
  Stream<bool> authStateChanges() {
    return client.auth.onAuthStateChange.map((event) {
      return event.session != null;
    });
  }

  // Convert guest to registered user
  Future<bool> convertGuestToRegistered({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // First register the user
      final response = await signUpWithEmail(email, password);

      if (response.user == null) {
        return false;
      }

      // Then update their profile with additional information
      final userId = response.user!.id;
      final profileData = {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        ...?additionalData,
      };

      return await updateUserProfile(userId, profileData);
    } catch (e) {
      print('Error converting guest to registered user: $e');
      return false;
    }
  }

  // Guest users
  Future<UserData> createGuestUser({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    try {
      print("Creating guest user record for email: $email");

      // Generate UUIDs for user_id and auth_id
      final userId = const Uuid().v4();
      final authId = const Uuid().v4();

      // Insert the guest user
      final response = await client.from('users').insert({
        'email': email,
        'first_name': firstName ?? 'Guest',
        'last_name': lastName ?? 'User',
        'phone': phone ?? '',
        'is_registered': false,
        'is_guest': true,
        'created_at': DateTime.now().toIso8601String(),
        'last_login': DateTime.now().toIso8601String(),
        'auth_id': authId,
        'user_id': userId,
        'user_type': 'guest',
      }).select().single();

      print("Guest user created with ID: $userId");

      // Return the created user
      return UserData.fromJson(response);
    } catch (e) {
      print('Error creating guest user: $e');
      throw e;
    }
  }

// Finde users by email and type (guest or registered)
  Future<List<UserData>> getUsersByEmail(String email,
      {String? userType}) async {
    try {
      var query = client.from('users').select().eq('email', email);

      if (userType != null) {
        query = query.eq('user_type', userType);
      }

      final response = await query;

      return (response as List).map((data) => UserData.fromJson(data)).toList();
    } catch (e) {
      print('Error finding users by email: $e');
      return [];
    }
  }

// Get user by ID
  Future<UserData?> getUserById(String userId) async {
    try {
      final response = await client
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) return null;
      return UserData.fromJson(response);
    } catch (e) {
      print('Error getting user by ID: $e');
      return null;
    }
  }

// Mark guest user as converted
  Future<bool> markGuestUserConverted(String guestUserId,
      String registeredUserId) async {
    try {
      await client.from('users').update({
        'converted_to_user_id': registeredUserId,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('user_id', guestUserId);

      return true;
    } catch (e) {
      print('Error marking guest user as converted: $e');
      return false;
    }
  }
}
