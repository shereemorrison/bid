class UserModel {
  final String userId;
  final String authId;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
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
      return email.split('@').first;
    }
  }
}

