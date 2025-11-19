import 'dart:convert';

class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final String content;
  final List<String> likedBy;
  int commentsCount;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.content,
    List<String>? likedBy,
    this.commentsCount = 0,
    DateTime? createdAt,
  }) : likedBy = likedBy ?? [],
       createdAt = createdAt ?? DateTime.now();

  Post copyWith({
    String? id,
    String? authorId,
    String? authorName,
    String? authorAvatar,
    String? content,
    List<String>? likedBy,
    int? commentsCount,
    DateTime? createdAt,
  }) {
    return Post(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      content: content ?? this.content,
      likedBy: likedBy ?? this.likedBy,
      commentsCount: commentsCount ?? this.commentsCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'content': content,
      'likes': likedBy.length,
      'commentsCount': commentsCount,
      'likedBy': likedBy, // Include likedBy in the map
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      authorName: map['authorName'] as String,
      authorAvatar: map['authorAvatar'] as String?,
      content: map['content'] as String,
      commentsCount: map['commentsCount'] as int? ?? 0,
      likedBy: List<String>.from(map['likedBy'] ?? <String>[]),
      createdAt:
          map['createdAt'] == null
              ? DateTime.now()
              : DateTime.parse(map['createdAt'] as String),
    );
  }

  int get likes => likedBy.length;

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));
}
