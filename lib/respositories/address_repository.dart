import 'package:bid/models/address_model.dart';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddressRepository extends BaseRepository {
  AddressRepository({SupabaseClient? client}) : super(client: client);

  // Get user addresses
  Future<List<Address>> getUserAddresses(String userId) async {
    try {
      print('AddressRepository: Getting addresses for user: $userId');

      // Check for empty user ID
      if (userId.isEmpty) {
        print('AddressRepository: Empty user ID provided');
        return [];
      }

      final response = await client
          .from('addresses')
          .select('*')
          .eq('user_id', userId)
          .order('is_default', ascending: false);

      return (response as List).map((data) => Address.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching user addresses: $e');
      return [];
    }
  }

  // Get default address
  Future<Address?> getDefaultAddress(String userId) async {
    try {
      // Check for empty user ID
      if (userId.isEmpty) {
        print('AddressRepository: Empty user ID provided');
        return null;
      }

      final response = await client
          .from('addresses')
          .select('*')
          .eq('user_id', userId)
          .eq('is_default', true)
          .maybeSingle();

      if (response == null) return null;
      return Address.fromJson(response);
    } catch (e) {
      print('Error fetching default address: $e');
      return null;
    }
  }

  // Create a user directly in the database
  Future<String> createGuestUser(String guestUserId, String userEmail) async {
    try {
      print('AddressRepository: Creating guest user with email: $userEmail');

      // Create the user data - using is_registered=false for guest users
      final userData = {
        'user_id': guestUserId,
        'email': userEmail,
        'user_type': 'guest',
        'is_registered': false,  // This identifies a guest user
        'created_at': DateTime.now().toIso8601String(),
      };

      print('AddressRepository: Inserting user with data: $userData');

      try {
        // First try direct insert
        await client.from('users').insert(userData);
        print('AddressRepository: User created via direct insert');
      } catch (insertError) {
        print('AddressRepository: Direct insert failed: $insertError');

        // If direct insert fails, try using the RPC function
        final result = await client.rpc('create_guest_user', params: {
          'p_user_id': guestUserId,
          'p_email': userEmail,
          'p_is_registered': false,
        });

        print('AddressRepository: User creation RPC result: $result');
      }

      // Wait a moment to ensure the database has time to update
      await Future.delayed(const Duration(milliseconds: 500));

      // Verify the user was created
      final verifyUser = await client
          .from('users')
          .select('user_id')
          .eq('user_id', guestUserId)
          .maybeSingle();

      if (verifyUser == null) {
        print('AddressRepository: Failed to verify user creation');
        throw Exception('Failed to verify user creation');
      }

      print('AddressRepository: Verified user creation: ${verifyUser['user_id']}');
      return guestUserId;
    } catch (e) {
      print('AddressRepository: Error creating user directly: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  // Add address with improved guest user handling
  Future<bool> addAddress(Address address) async {
    try {
      String userId = address.userId;
      String? userEmail = address.email;

      // Check for empty user ID
      if (userId.isEmpty) {
        print('AddressRepository: Empty user ID provided');
        return false;
      }

      print('AddressRepository: Adding address for user ID: $userId');

      // First check if this user exists in the database
      final userExists = await client
          .from('users')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();

      // If user doesn't exist, create a new guest user
      if (userExists == null) {
        print('AddressRepository: User does not exist, creating guest user first');
        try {
          // Check if email is null or empty
          if (userEmail == null || userEmail.isEmpty) {
            print('AddressRepository: No email provided for guest user');
            return false;
          }
          // Create a new guest user and get its ID
          userId = await createGuestUser(userId, userEmail);
          print('AddressRepository: Created new guest user with ID: $userId');
        } catch (e) {
          print('AddressRepository: Failed to create guest user: $e');
          return false;
        }
      } else {
        print('AddressRepository: Found existing user: ${userExists['user_id']}');
      }

      // Double-check that user exists now
      final userVerified = await client
          .from('users')
          .select('user_id')
          .eq('user_id', userId)
          .maybeSingle();

      if (userVerified == null) {
        print('AddressRepository: User still does not exist after creation attempt');
        return false;
      }

      print('AddressRepository: Verified user exists, proceeding with address creation');

      // Generate a proper UUID for the address_id if needed
      final addressData = address.toJson();
      addressData['user_id'] = userId; // Use the resolved database user_id

      if (!_isValidUuid(addressData['address_id'])) {
        addressData['address_id'] = const Uuid().v4();
      }

      print('AddressRepository: Adding address with data: $addressData');
      await client.from('addresses').insert(addressData);
      print('AddressRepository: Address added successfully');
      return true;
    } catch (e) {
      print('AddressRepository: Error adding address: $e');
      return false;
    }
  }

  // Update address
  Future<bool> updateAddress(Address address) async {
    try {
      String userId = address.userId;

      // Check for empty user ID
      if (userId.isEmpty) {
        print('AddressRepository: Empty user ID provided');
        return false;
      }

      // If setting as default, update all other addresses to non-default
      if (address.isDefault) {
        await client
            .from('addresses')
            .update({'is_default': false})
            .eq('user_id', userId)
            .eq('address_type', address.addressType)
            .neq('address_id', address.id);
      }

      // Convert model to map for Supabase
      final addressData = {
        'address_type': address.addressType,
        'is_default': address.isDefault,
        'first_name': address.firstName,
        'last_name': address.lastName,
        'phone': address.phone,
        'email': address.email,
        'street_address': address.streetAddress,
        'apartment': address.apartment,
        'city': address.city,
        'state': address.state,
        'postal_code': address.postalCode,
        'country': address.country,
        'updated_at': DateTime.now().toIso8601String(),
        'user_id': userId,
      };

      await client
          .from('addresses')
          .update(addressData)
          .eq('address_id', address.id);

      return true;
    } catch (e) {
      print('AddressRepository: Error updating address: $e');
      return false;
    }
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      await client.from('addresses').delete().eq('address_id', addressId);
      return true;
    } catch (e) {
      print('Error deleting address: $e');
      return false;
    }
  }

  // Set default address
  Future<bool> setDefaultAddress(String userId, String addressId) async {
    try {
      // Check for empty user ID
      if (userId.isEmpty) {
        print('AddressRepository: Empty user ID provided');
        return false;
      }

      // First, set all addresses to non-default
      await client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId);

      // Then set the selected address as default
      await client
          .from('addresses')
          .update({'is_default': true})
          .eq('address_id', addressId);

      return true;
    } catch (e) {
      print('Error setting default address: $e');
      return false;
    }
  }

  // Helper method to check if a string is a valid UUID
  bool _isValidUuid(String str) {
    // Simple regex to check UUID format
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(str);
  }

  // Get address by ID
  Future<Address?> getAddressById(String addressId) async {
    try {
      final response = await client
          .from('addresses')
          .select()
          .eq('address_id', addressId)
          .maybeSingle();

      if (response == null) return null;
      return Address.fromJson(response);
    } catch (e) {
      print('Error getting address by ID: $e');
      return null;
    }
  }
}
