import 'package:bid/models/address_model.dart';

class UserData {
  final String userId;
  final String authId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? address;
  final List<Address> addresses;
  final bool isRegistered;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final String? userType;

  UserData({
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
    this.userType,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {

    List<Address> addressList = [];
    if (json['addresses'] != null && json['addresses'] is List) {
      addressList = (json['addresses'] as List)
          .map((addr) => Address.fromJson(addr))
          .toList();
    }

    return UserData(
      userId: json['user_id'] ?? json['id'],
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
      userType: json['user_type']
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

  Address? get defaultAddress {
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

