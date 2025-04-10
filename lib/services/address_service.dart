import 'package:bid/models/address_model.dart';
import 'package:bid/supabase/supabase_config.dart';
import 'package:uuid/uuid.dart';

class AddressService {
  final _supabase = SupabaseConfig.client;

  // Get addresses for a user
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    try {
      final data = await _supabase
          .from('addresses')
          .select()
          .eq('user_id', userId);

      if (data == null || data.isEmpty) {
        return [];
      }

      return List<AddressModel>.from(
          data.map((address) => AddressModel.fromJson(address))
      );
    } catch (e) {
      print('AddressService: Error fetching user addresses: $e');
      return [];
    }
  }

  // Add a new address
  Future<AddressModel?> addAddress(AddressModel address) async {
    try {
      // If this is set as default, update all other addresses to non-default
      if (address.isDefault) {
        await _supabase
            .from('addresses')
            .update({'is_default': 'false'})
            .eq('user_id', address.userId)
            .eq('address_type', address.addressType);
      }

      // Convert model to map for Supabase
      final addressData = {
        'address_id': address.addressId,
        'user_id': address.userId,
        'address_type': address.addressType,
        'is_default': address.isDefault.toString(),
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
        'created_at': address.createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        'updated_at': address.updatedAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      };

      await _supabase.from('addresses').insert(addressData);

      return address;
    } catch (e) {
      print('AddressService: Error adding address: $e');
      return null;
    }
  }

  // Update an existing address
  Future<bool> updateAddress(AddressModel address) async {
    try {
      // If setting as default, update all other addresses to non-default
      if (address.isDefault) {
        await _supabase
            .from('addresses')
            .update({'is_default': 'false'})
            .eq('user_id', address.userId)
            .eq('address_type', address.addressType)
            .neq('address_id', address.addressId);
      }

      // Convert model to map for Supabase
      final addressData = {
        'address_type': address.addressType,
        'is_default': address.isDefault.toString(),
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
      };

      await _supabase
          .from('addresses')
          .update(addressData)
          .eq('address_id', address.addressId)
          .eq('user_id', address.userId);

      return true;
    } catch (e) {
      print('AddressService: Error updating address: $e');
      return false;
    }
  }

  // Delete an address
  Future<bool> deleteAddress(String addressId, String userId) async {
    try {
      await _supabase
          .from('addresses')
          .delete()
          .eq('address_id', addressId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('AddressService: Error deleting address: $e');
      return false;
    }
  }

  // Get default address of a specific type
  Future<AddressModel?> getDefaultAddress(String userId, String addressType) async {
    try {
      final data = await _supabase
          .from('addresses')
          .select()
          .eq('user_id', userId)
          .eq('address_type', addressType)
          .eq('is_default', 'true')
          .maybeSingle();

      if (data == null) {
        return null;
      }

      return AddressModel.fromJson(data);
    } catch (e) {
      print('AddressService: Error fetching default address: $e');
      return null;
    }
  }
}
