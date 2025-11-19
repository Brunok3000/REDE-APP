// User model adapted from legacy project and converted to map-based constructor
class AppUser {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String photoUrl;
  final String bio;

  AppUser({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.photoUrl,
    required this.bio,
  });

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      displayName: map['displayName']?.toString() ?? '',
      photoUrl: map['photoUrl']?.toString() ?? '',
      bio: map['bio']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'bio': bio,
    };
  }
}
