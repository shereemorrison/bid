import 'package:bid/models/address_model.dart';

class UserModel {
  final String userId;
  final String authId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final List<AddressModel> addresses;
  final bool isRegistered;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.userId,
    required this.authId,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.addresses = const [],
    this.isRegistered = false,
    this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      authId: json['auth_id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      address: json['address'],
      isRegistered: json['is_registered'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
    );
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return email
          .split('@')
          .first;
    }
  }

  AddressModel? get defaultAddress {
    if (addresses.isEmpty) return null;

    // Try to find default address
    final defaultAddr = addresses.firstWhere(
            (addr) => addr.isDefault,
        orElse: () => addresses.first
    );

    return defaultAddr;
  }

  // Get formatted address string
  String get formattedAddress {
    final addr = defaultAddress;
    if (addr != null) {
      // Format with line breaks
      final streetLine = (addr.apartment != null && addr.apartment!.isNotEmpty
          ? '${addr.apartment}, '
          : '') + addr.streetAddress;

      final parts = [
        streetLine,
        '${addr.city}, ${addr.state} ${addr.postalCode}',
        addr.country,
      ];
      return parts.join('\n'); // Join with newlines
    }
    return address ?? 'Not set';
  }
}

