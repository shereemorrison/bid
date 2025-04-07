import 'dart:math';
import 'package:bid/models/address_model.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/supabase/supabase_config.dart';


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
      // Check if the user already exists
      final existingUser = await _supabase
          .from('users')
          .select('user_id')
          .eq('auth_id', authId)
          .maybeSingle();

      if (existingUser != null) {
        // Update existing user
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

      final random = Random();
      final userId = random.nextInt(100) + 1;

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

  // Get user data from the users table by auth_id
  Future<UserModel?> getUserData(String authId) async {
    try {
      final data = await _supabase
          .from('users')
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (data == null) {
        print('UserService: No user data found for authId: $authId');
        return null;
      }

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
}



