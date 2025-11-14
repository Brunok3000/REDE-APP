class UserModel {
  final String id;
  final String? name;
  final String? role;
  final String? avatar;
  final String? phone;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    this.name,
    this.role,
    this.avatar,
    this.phone,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      role: json['role'] as String?,
      avatar: json['avatar'] as String?,
      phone: json['phone'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'avatar': avatar,
    'phone': phone,
    'created_at': createdAt?.toIso8601String(),
  };
}
