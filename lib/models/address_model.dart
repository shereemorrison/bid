class AddressModel {
  final String addressId;
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

  AddressModel({
    required this.addressId,
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

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'],
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

  String get formattedAddress {
    final parts = [
      streetAddress,
      if (apartment != null && apartment!.isNotEmpty) apartment,
      city,
      '$state $postalCode',
      country,
    ];
    return parts.join(', ');
  }
}