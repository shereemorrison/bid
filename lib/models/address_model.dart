class Address {
  final String id;
  final String userId;
  final String addressType;
  final bool isDefault;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final String streetAddress;
  final String? apartment;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    required this.id,
    required this.userId,
    required this.addressType,
    required this.isDefault,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    required this.streetAddress,
    this.apartment,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.createdAt,
    this.updatedAt,
  });

  Address copyWith({
    String? id,
    String? userId,
    String? firstName,
    String? lastName,
    String? streetAddress,
    String? apartment,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    bool? isDefault,
    String? addressType,
  }) {
    return Address(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      streetAddress: streetAddress ?? this.streetAddress,
      apartment: apartment ?? this.apartment,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isDefault: isDefault ?? this.isDefault,
      addressType: addressType ?? this.addressType,
    );
  }

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['address_id'] ?? json['id'],
      userId: json['user_id'],
      addressType: json['address_type'],
      isDefault: json['is_default'] == 'true' || json['is_default'] == true,
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone']?.toString(),
      email: json['email'],
      streetAddress: json['street_address'],
      apartment: json['apartment'],
      city: json['city'],
      state: json['state'],
      postalCode: json['postal_code'].toString(),
      country: json['country'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': id,
      'user_id': userId,
      'address_type': addressType,
      'is_default': isDefault,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'street_address': streetAddress,
      'apartment': apartment,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
    };
  }

  String get formattedAddress {
    final List<String> parts = [];
    if (apartment != null && apartment!.isNotEmpty) {
      parts.add('Unit $apartment, $streetAddress');
    } else {
      parts.add(streetAddress);
    }

    parts.add('$city, $state $postalCode');

    if (country != 'Australia') {
      parts.add(country);
    }
    return parts.join(', ');
  }
}