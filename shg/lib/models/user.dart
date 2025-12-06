class User {
  final String id;
  final String phone;
  final String name;
  final String role;
  final String language;
  final List<String> groups;
  final String? profilePhotoUrl;

  User({
    required this.id,
    required this.phone,
    required this.name,
    required this.role,
    required this.language,
    required this.groups,
    this.profilePhotoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? json['_id'] ?? '',
      phone: json['phone'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'MEMBER',
      language: json['language'] ?? 'te',
      groups: List<String>.from(json['groups'] ?? []),
      profilePhotoUrl: json['profilePhotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'name': name,
      'role': role,
      'language': language,
      'groups': groups,
      'profilePhotoUrl': profilePhotoUrl,
    };
  }
}
