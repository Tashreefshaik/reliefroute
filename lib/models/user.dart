class User {
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String address;
  final String? passwordHash;
  final String? imageUrl;

  User({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
    this.passwordHash,
    this.imageUrl,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['user_id'] ?? map['userId'] ?? '',
      fullName: map['full_name'] ?? map['fullName'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'patient',
      address: map['address'] ?? '',
      passwordHash: map['password_hash'] ?? map['passwordHash'],
      imageUrl: map['image_url'] ?? map['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'address': address,
      'password_hash': passwordHash,
      'image_url': imageUrl,
    };
  }

  // Alias for Firestore compatibility
  Map<String, dynamic> toJson() => toMap();

  // Alias for Firestore compatibility
  factory User.fromJson(Map<String, dynamic> json) => User.fromMap(json);
}
