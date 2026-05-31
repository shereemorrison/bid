import 'package:bid/models/address_model.dart';
import 'package:bid/models/user_model.dart';
import 'package:bid/repositories/base_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Identity rules:
/// - One [public.users] row per email (unique on lower(email)).
/// - [auth_id] is set only after Supabase login/register; null for guest checkout.
/// - [is_guest] true only for checkout-as-guest without an auth session.
/// - [user_id] is what addresses/orders reference — never auth.users.id.
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

    if (response.user != null) {
      final normalizedEmail = _normalizedEmail(email);
      if (normalizedEmail != null) {
        await _ensureCanonicalProfileForAuth(
          authId: response.user!.id,
          email: normalizedEmail,
          firstName: firstName,
          lastName: lastName,
          phone: phone,
        );
      }
    }
    return response;
  }

  /// Links the current Supabase auth session to the single profile row for [email].
  Future<String> _ensureCanonicalProfileForAuth({
    required String authId,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final rows =
        await client.from('users').select().ilike('email', email) as List;

    if (rows.isEmpty) {
      final userId = const Uuid().v4();
      await client.from('users').insert({
        'user_id': userId,
        'auth_id': authId,
        'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        'is_registered': true,
        'is_guest': false,
        'user_type': 'customer',
        'created_at': DateTime.now().toIso8601String(),
        'last_login': DateTime.now().toIso8601String(),
      });
      return userId;
    }

    final canonicalUserId = await _pickBestUserIdFromRows(rows);

    await _consolidateSiblingUsersByEmail(
      canonicalUserId: canonicalUserId,
      normalizedEmail: email,
      authId: authId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );

    return canonicalUserId;
  }

  Future<String> _pickBestUserIdFromRows(List<dynamic> rows) async {
    var bestId = rows.first['user_id'].toString();
    var bestScore = -1;

    for (final row in rows) {
      final userId = row['user_id'].toString();
      final addressRows = await client
          .from('addresses')
          .select('address_id')
          .eq('user_id', userId);
      final addressCount = (addressRows as List).length;
      final score =
          _profileCompletenessScore(row as Map<String, dynamic>) +
          addressCount * 10;
      if (score > bestScore) {
        bestScore = score;
        bestId = userId;
      }
    }

    return bestId;
  }

  /// Guest checkout profile — one row per email, never sets auth_id.
  Future<UserData> ensureGuestProfile({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final normalizedEmail = _normalizedEmail(email) ?? email.trim();

    final existingRows =
        await client.from('users').select().ilike('email', normalizedEmail)
            as List;

    if (existingRows.isNotEmpty) {
      final userId = await _pickBestUserIdFromRows(existingRows);
      await client.from('users').update({
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        'email': normalizedEmail,
        'last_login': DateTime.now().toIso8601String(),
      }).eq('user_id', userId);

      final profile = await getUserByUserId(userId);
      if (profile != null) return profile;
    }

    final userId = const Uuid().v4();
    final response = await client.from('users').insert({
      'email': normalizedEmail,
      'first_name': firstName ?? 'Guest',
      'last_name': lastName ?? 'User',
      'phone': phone ?? '',
      'is_registered': false,
      'is_guest': true,
      'auth_id': null,
      'user_id': userId,
      'user_type': 'guest',
      'created_at': DateTime.now().toIso8601String(),
      'last_login': DateTime.now().toIso8601String(),
    }).select().single();

    return UserData.fromJson(response);
  }

  /// Moves guest checkout data onto the logged-in profile when IDs differ.
  Future<void> mergeGuestProfileIntoRegistered({
    required String guestUserId,
    required String registeredUserId,
  }) async {
    if (guestUserId == registeredUserId) return;

    await client
        .from('addresses')
        .update({'user_id': registeredUserId})
        .eq('user_id', guestUserId);

    await client
        .from('orders')
        .update({'user_id': registeredUserId})
        .eq('user_id', guestUserId);

    final guestRow = await client
        .from('users')
        .select()
        .eq('user_id', guestUserId)
        .maybeSingle();

    if (guestRow != null) {
      final registered = await client
          .from('users')
          .select()
          .eq('user_id', registeredUserId)
          .single();

      final updates = <String, dynamic>{};
      for (final field in ['first_name', 'last_name', 'phone', 'address']) {
        final registeredValue = registered[field]?.toString();
        final guestValue = guestRow[field]?.toString();
        if (_nonEmpty(registeredValue) == null && _nonEmpty(guestValue) != null) {
          updates[field] = guestValue;
        }
      }
      if (updates.isNotEmpty) {
        await client
            .from('users')
            .update(updates)
            .eq('user_id', registeredUserId);
      }

      await client.from('users').delete().eq('user_id', guestUserId);
    }
  }

  // Deprecated path — delegates to email-first canonical profile.
  Future<void> createUserRecord({
    required String authId,
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    String? address,
  }) async {
    final normalizedEmail = _normalizedEmail(email);
    if (normalizedEmail == null) return;

    await _ensureCanonicalProfileForAuth(
      authId: authId,
      email: normalizedEmail,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }

  // Sign out
  Future<void> signOut() async {
    print("UserRepository: Starting sign out process");
    try {
      await client.auth.signOut();
      print("UserRepository: Sign out completed successfully");
      
      // Verify the session is cleared
      final session = client.auth.currentSession;
      print("UserRepository: Current session after sign out: $session");
    } catch (e) {
      print("UserRepository: Error during sign out: $e");
      rethrow;
    }
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

  /// Loads profile for the current Supabase auth session (email-first lookup).
  Future<UserData?> getOrCreateUserForAuthSession() async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;

    final normalizedEmail = _normalizedEmail(authUser.email);
    if (normalizedEmail == null) return null;

    final userId = await _ensureCanonicalProfileForAuth(
      authId: authUser.id,
      email: normalizedEmail,
      firstName: authUser.userMetadata?['first_name'] as String?,
      lastName: authUser.userMetadata?['last_name'] as String?,
      phone: authUser.userMetadata?['phone'] as String?,
    );

    var profile = await getUserByUserId(userId);
    if (profile == null) return null;

    return syncProfileFromAuthAndAddresses(authUser, profile);
  }

  /// Moves addresses/orders from every duplicate [users] row with the same email
  /// onto [canonicalUserId]. Fixes guest-checkout rows pointing at a different UUID.
  Future<void> _consolidateSiblingUsersByEmail({
    required String canonicalUserId,
    required String normalizedEmail,
    required String authId,
    String? firstName,
    String? lastName,
    String? phone,
  }) async {
    final siblings = await client
        .from('users')
        .select('user_id, first_name, last_name, phone, address, email')
        .ilike('email', normalizedEmail);

    if ((siblings as List).length <= 1) {
      await client.from('users').update({
        'auth_id': authId,
        'is_registered': true,
        'is_guest': false,
        'user_type': 'customer',
        'email': normalizedEmail,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
        'last_login': DateTime.now().toIso8601String(),
      }).eq('user_id', canonicalUserId);
      return;
    }

    print(
      'UserRepository: Consolidating ${siblings.length} rows for '
      '$normalizedEmail into $canonicalUserId',
    );

    Map<String, dynamic>? canonicalRow;
    for (final row in siblings) {
      if (row['user_id'].toString() == canonicalUserId) {
        canonicalRow = row as Map<String, dynamic>;
        break;
      }
    }

    final profileUpdates = <String, dynamic>{
      'auth_id': authId,
      'is_registered': true,
      'is_guest': false,
      'user_type': 'customer',
      'email': normalizedEmail,
      'last_login': DateTime.now().toIso8601String(),
    };

    if (firstName != null) profileUpdates['first_name'] = firstName;
    if (lastName != null) profileUpdates['last_name'] = lastName;
    if (phone != null) profileUpdates['phone'] = phone;

    for (final row in siblings) {
      final siblingId = row['user_id'].toString();
      if (siblingId == canonicalUserId) continue;

      await client
          .from('addresses')
          .update({'user_id': canonicalUserId})
          .eq('user_id', siblingId);

      await client
          .from('orders')
          .update({'user_id': canonicalUserId})
          .eq('user_id', siblingId);

      for (final field in ['first_name', 'last_name', 'phone', 'address']) {
        final canonicalValue = canonicalRow?[field]?.toString();
        final siblingValue = row[field]?.toString();
        if (_nonEmpty(canonicalValue) == null && _nonEmpty(siblingValue) != null) {
          profileUpdates[field] = siblingValue;
        }
      }

      await client.from('users').delete().eq('user_id', siblingId);
    }

    await client
        .from('users')
        .update(profileUpdates)
        .eq('user_id', canonicalUserId);

    await _syncDefaultAddressId(canonicalUserId);
  }

  Future<void> _syncDefaultAddressId(String userId) async {
    final defaultRow = await client
        .from('addresses')
        .select('address_id')
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: true)
        .limit(1)
        .maybeSingle();

    if (defaultRow == null) return;

    await client.from('users').update({
      'default_address_id': defaultRow['address_id'],
    }).eq('user_id', userId);
  }

  int _profileCompletenessScore(Map<String, dynamic> row) {
    var score = 0;
    if (_nonEmpty(row['first_name'] as String?) != null) score += 2;
    if (_nonEmpty(row['last_name'] as String?) != null) score += 2;
    if (_nonEmpty(row['phone'] as String?) != null) score += 1;
    if (_nonEmpty(row['address'] as String?) != null) score += 1;
    if (row['is_registered'] == true) score += 1;
    if (row['auth_id'] != null) score += 1;
    return score;
  }

  /// Load profile by [public.users.user_id] including addresses.
  Future<UserData?> getUserByUserId(String userId) async {
    try {
      final userData = await client
          .from('users')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (userData == null) return null;

      final user = UserData.fromJson(userData);
      final addresses = await resolveUserAddresses(user);

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
        userType: user.userType,
      );
    } catch (e) {
      print('UserRepository: Error getting user by user_id: $e');
      return null;
    }
  }

  String? _normalizedEmail(String? email) {
    if (email == null) return null;
    final trimmed = email.trim().toLowerCase();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Backfills missing profile fields from auth metadata and saved addresses.
  Future<UserData> syncProfileFromAuthAndAddresses(
    User authUser,
    UserData profile,
  ) async {
    final metadata = authUser.userMetadata ?? {};
    final defaultAddress = profile.defaultAddress;

    final firstName = _nonEmpty(profile.firstName) ??
        _nonEmpty(defaultAddress?.firstName) ??
        _nonEmpty(metadata['first_name'] as String?);
    final lastName = _nonEmpty(profile.lastName) ??
        _nonEmpty(defaultAddress?.lastName) ??
        _nonEmpty(metadata['last_name'] as String?);
    final phone = _nonEmpty(profile.phone) ??
        _nonEmpty(defaultAddress?.phone) ??
        _nonEmpty(metadata['phone'] as String?);
    final email = _nonEmpty(profile.email) ??
        authUser.email?.trim().toLowerCase() ??
        profile.email;

    final updates = <String, dynamic>{
      'last_login': DateTime.now().toIso8601String(),
    };

    if (firstName != null && firstName != profile.firstName) {
      updates['first_name'] = firstName;
    }
    if (lastName != null && lastName != profile.lastName) {
      updates['last_name'] = lastName;
    }
    if (phone != null && phone != profile.phone) {
      updates['phone'] = phone;
    }
    if (email != profile.email) {
      updates['email'] = email;
    }

    if (updates.length > 1) {
      try {
        await client.from('users').update({
          ...updates,
          'is_registered': true,
          'is_guest': false,
          'user_type': 'customer',
        }).eq('user_id', profile.userId);
      } catch (e) {
        print('UserRepository: Could not sync profile fields: $e');
      }
    }

    return UserData(
      userId: profile.userId,
      authId: authUser.id,
      email: email,
      firstName: firstName ?? profile.firstName,
      lastName: lastName ?? profile.lastName,
      phone: phone ?? profile.phone,
      address: profile.address,
      addresses: profile.addresses,
      isRegistered: true,
      createdAt: profile.createdAt,
      lastLogin: profile.lastLogin,
      userType: 'customer',
    );
  }

  String? _nonEmpty(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  // Get user data by auth_id (delegates to email-first canonical row when needed).
  Future<UserData?> getUserByAuthId(String authId) async {
    try {
      final userData = await client
          .from('users')
          .select()
          .eq('auth_id', authId)
          .maybeSingle();

      if (userData == null) return null;

      return getUserByUserId(userData['user_id'].toString());
    } catch (e) {
      print('UserRepository: Error getting user data: $e');
      return null;
    }
  }

  // Get addresses for a user (public.users.user_id — NOT auth.users.id).
  Future<List<Address>> getUserAddresses(String userId) async {
    try {
      var addressData = await client
          .from('addresses')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false);

      if ((addressData as List).isNotEmpty) {
        return List<Address>.from(
            addressData.map((addr) => Address.fromJson(addr)));
      }

      // Orphan addresses may still point at a guest/duplicate row with the same email.
      final relinked = await _relinkOrphanAddressesByEmail(userId);
      if (relinked.isEmpty) return [];

      addressData = await client
          .from('addresses')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false);

      return List<Address>.from(
          addressData.map((addr) => Address.fromJson(addr)));
    } catch (e) {
      print('UserRepository: Error getting addresses: $e');
      return [];
    }
  }

  Future<List<Address>> _relinkOrphanAddressesByEmail(String canonicalUserId) async {
    final userRow = await client
        .from('users')
        .select('email')
        .eq('user_id', canonicalUserId)
        .maybeSingle();

    if (userRow == null) return [];

    final normalizedEmail = _normalizedEmail(userRow['email'] as String?);
    if (normalizedEmail == null) return [];

    final siblings = await client
        .from('users')
        .select('user_id')
        .ilike('email', normalizedEmail);

    final relinked = <Address>[];
    for (final sibling in siblings as List) {
      final siblingId = sibling['user_id'].toString();
      if (siblingId == canonicalUserId) continue;

      final orphanRows = await client
          .from('addresses')
          .select()
          .eq('user_id', siblingId);

      if ((orphanRows as List).isEmpty) continue;

      print(
        'UserRepository: Relinking ${orphanRows.length} address(es) from '
        '$siblingId to $canonicalUserId',
      );

      await client
          .from('addresses')
          .update({'user_id': canonicalUserId})
          .eq('user_id', siblingId);

      relinked.addAll(
        orphanRows.map((row) {
          final json = Map<String, dynamic>.from(row as Map);
          json['user_id'] = canonicalUserId;
          return Address.fromJson(json);
        }),
      );
    }

    return relinked;
  }

  /// Loads saved addresses, migrating legacy [users.address] text when needed.
  Future<List<Address>> resolveUserAddresses(UserData user) async {
    final saved = await getUserAddresses(user.userId);
    if (saved.isNotEmpty) return saved;

    final legacyAddress = _nonEmpty(user.address);
    if (legacyAddress == null) return [];

    final migrated = Address(
      id: const Uuid().v4(),
      userId: user.userId,
      addressType: 'shipping',
      isDefault: true,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      email: user.email,
      streetAddress: legacyAddress,
      city: '—',
      state: '—',
      postalCode: '0000',
      country: 'Australia',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await client.from('addresses').insert(migrated.toJson());
      await client.from('users').update({
        'default_address_id': migrated.id,
      }).eq('user_id', user.userId);
      print('UserRepository: Migrated legacy address for user ${user.userId}');
      return [migrated];
    } catch (e) {
      print('UserRepository: Could not persist legacy address: $e');
      return [migrated];
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
      print('Converting guest to registered user for email: $email');
      
      // Check if user already exists in database
      final existingUser = await client
          .from('users')
          .select('auth_id, is_registered')
          .eq('email', email)
          .maybeSingle();
          
      if (existingUser != null) {
        print('User already exists in database');
        
        // If user is already registered, just sign them in
        if (existingUser['is_registered'] == true) {
          print('User is already registered, attempting sign in');
          try {
            await client.auth.signInWithPassword(email: email, password: password);
            print('Successfully signed in existing user');
            return true;
          } catch (e) {
            print('Failed to sign in existing user: $e');
            return false;
          }
        } else {
          // User exists but not registered, update their profile
          final authId = existingUser['auth_id'];
          final profileData = {
            'first_name': firstName,
            'last_name': lastName,
            'phone': phone,
            'is_registered': true,
            'last_login': DateTime.now().toIso8601String(),
            ...?additionalData,
          };
          
          await client.from('users').update(profileData).eq('auth_id', authId);
          print('Updated existing user profile to registered');
          return true;
        }
      }
      
      // User doesn't exist, create new account
      print('Creating new user account');
      final response = await signUpWithEmail(email, password);

      if (response.user == null) {
        print('Failed to create new user account');
        return false;
      }

      // Update their profile with additional information
      final userId = response.user!.id;
      final profileData = {
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        ...?additionalData,
      };

      final success = await updateUserProfile(userId, profileData);
      print('Guest conversion result: $success');
      return success;
    } catch (e) {
      print('Error converting guest to registered user: $e');
      return false;
    }
  }

  // Guest checkout — one profile per email, auth_id stays null until login.
  Future<UserData> createGuestUser({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
  }) {
    return ensureGuestProfile(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
  }

// Finde users by email and type (guest or registered)
  Future<List<UserData>> getUsersByEmail(String email,
      {String? userType}) async {
    try {
      final normalizedEmail = _normalizedEmail(email) ?? email.trim();

      var query = client.from('users').select().ilike('email', normalizedEmail);

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
