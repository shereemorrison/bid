import 'dart:math';
import '../models/user_model.dart';
import '../supabase/supabase_config.dart';

class UserService {
  final _supabase = SupabaseConfig.client;

  // Create a new user in the users table
  Future<void> createUser({
    required String authId,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
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
      print('UserService: User data found: ${data['email']}');
      return UserModel.fromJson(data);
    } catch (e) {
      print('UserService: Error fetching user data: $e');
      return null;
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

      return UserModel.fromJson(data);
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



