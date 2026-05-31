import 'package:bid/models/address_model.dart';
import 'package:bid/repositories/base_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddressRepository extends BaseRepository {
  AddressRepository({SupabaseClient? client}) : super(client: client);

  // Get user addresses (only for logged in users)
  Future<List<Address>> getUserAddresses(String userId) async {
    try {
      if (userId.isEmpty) return [];

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

  // Save address and link it as the user's default when applicable.
  Future<bool> saveAddress(Address address) async {
    try {
      final addressData = address.toJson();
      addressData['user_id'] = address.userId;
      addressData['address_id'] = address.id;

      final existing = await client
          .from('addresses')
          .select('address_id')
          .eq('address_id', address.id)
          .maybeSingle();

      if (existing != null) {
        await client
            .from('addresses')
            .update(addressData)
            .eq('address_id', address.id);
      } else {
        await client.from('addresses').insert(addressData);
      }

      if (address.isDefault) {
        await _setDefaultAddressForUser(address.userId, address.id);
      }

      return true;
    } catch (e) {
      print('Error saving address: $e');
      return false;
    }
  }

  Future<void> _setDefaultAddressForUser(String userId, String addressId) async {
    await client
        .from('addresses')
        .update({'is_default': false})
        .eq('user_id', userId)
        .neq('address_id', addressId);

    await client.from('addresses').update({'is_default': true}).eq(
          'address_id',
          addressId,
        );

    await client.from('users').update({
      'default_address_id': addressId,
    }).eq('user_id', userId);
  }
}
