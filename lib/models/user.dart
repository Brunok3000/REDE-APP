import 'dart:convert';

enum UserRole { user, partner }

class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final UserRole role;
  final DateTime createdAt;
  final Map<String, dynamic> settings;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.role = UserRole.user,
    DateTime? createdAt,
    Map<String, dynamic>? settings,
  }) : createdAt = createdAt ?? DateTime.now(),
       settings = settings ?? const {"optOutProfileVisits": false};

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    UserRole? role,
    DateTime? createdAt,
    Map<String, dynamic>? settings,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'settings': settings,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatarUrl'] as String?,
      role:
          (map['role'] as String) == 'partner'
              ? UserRole.partner
              : UserRole.user,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
