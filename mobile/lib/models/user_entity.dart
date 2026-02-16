class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.phone,
    required this.website,
    required this.companyName,
    required this.city,
  });

  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;
  final String website;
  final String companyName;
  final String city;

  // Keep this mapping aligned with common free mock APIs (e.g. JSONPlaceholder)
  // so switching from local mock data to HTTP is straightforward later.
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>?;
    final address = json['address'] as Map<String, dynamic>?;

    return UserEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      website: json['website'] as String,
      companyName: (company?['name'] ?? '') as String,
      city: (address?['city'] ?? '') as String,
    );
  }
}
