// Domain Entity: User
// Pure Dart entity with no external dependencies

class User {
  final String id;
  final String email;
  final String? fullName;
  final String? username;
  final String? bio;
  final String? avatarUrl;
  final String? phoneNumber;
  final String? documentNumber;
  final String userType; // 'user' or 'partner'
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.fullName,
    this.username,
    this.bio,
    this.avatarUrl,
    this.phoneNumber,
    this.documentNumber,
    required this.userType,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? fullName,
    String? username,
    String? bio,
    String? avatarUrl,
    String? phoneNumber,
    String? documentNumber,
    String? userType,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      documentNumber: documentNumber ?? this.documentNumber,
      userType: userType ?? this.userType,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  List<Object?> get props => [
    id,
    email,
    fullName,
    username,
    bio,
    avatarUrl,
    phoneNumber,
    documentNumber,
    userType,
    isVerified,
    createdAt,
    updatedAt,
  ];
}
