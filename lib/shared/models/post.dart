// Post model adapted from legacy project and converted to map-based constructor
class PostModel {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;
  final Map<String, dynamic> likes;

  PostModel({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
    required this.likes,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId']?.toString() ?? '',
      ownerId: map['ownerId']?.toString() ?? '',
      username: map['username']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      mediaUrl: map['mediaUrl']?.toString() ?? '',
      likes: Map<String, dynamic>.from(map['likes'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'ownerId': ownerId,
      'username': username,
      'location': location,
      'description': description,
      'mediaUrl': mediaUrl,
      'likes': likes,
    };
  }

  int getLikeCount() {
    if (likes.isEmpty) return 0;
    var count = 0;
    for (final v in likes.values) {
      if (v == true) count += 1;
    }
    return count;
  }
}
