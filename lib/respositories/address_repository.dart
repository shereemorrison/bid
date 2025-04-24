import 'package:bid/models/address_model.dart';
import 'package:bid/respositories/base_respository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class AddressRepository extends BaseRepository {
  AddressRepository({SupabaseClient? client}) : super(client: client);

  // Get user addresses
  Future<List<Address>> getUserAddresses(String userId) async {
    try {
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

  // Add address
  Future<bool> addAddress(Address address) async {
    try {
      await client.from('addresses').insert(address.toJson());
      return true;
    } catch (e) {
      print('Error adding address: $e');
      return false;
    }
  }

  // Update address
  Future<bool> updateAddress(Address address) async {
    try {
      await client
          .from('addresses')
          .update(address.toJson())
          .eq('id', address.id);
      return true;
    } catch (e) {
      print('Error updating address: $e');
      return false;
    }
  }

  // Delete address
  Future<bool> deleteAddress(String addressId) async {
    try {
      await client.from('addresses').delete().eq('id', addressId);
      return true;
    } catch (e) {
      print('Error deleting address: $e');
      return false;
    }
  }

  // Set default address
  Future<bool> setDefaultAddress(String userId, String addressId) async {
    try {
      // First, set all addresses to non-default
      await client
          .from('addresses')
          .update({'is_default': false})
          .eq('user_id', userId);

      // Then set the selected address as default
      await client
          .from('addresses')
          .update({'is_default': true})
          .eq('id', addressId);

      return true;
    } catch (e) {
      print('Error setting default address: $e');
      return false;
    }
  }
}
