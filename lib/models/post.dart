class Post {
  final String id;
  final String authorId;
  final String? establishmentId;
  final String? content;
  final List<String>? images;
  final int likes;
  final DateTime? createdAt;

  const Post({
    required this.id,
    required this.authorId,
    this.establishmentId,
    this.content,
    this.images,
    this.likes = 0,
    this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as String,
      authorId: json['author_id'] as String,
      establishmentId: json['establishment_id'] as String?,
      content: json['content'] as String?,
      images: json['images'] != null
          ? List<String>.from((json['images'] as List<dynamic>))
          : null,
      likes: json['likes'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'author_id': authorId,
        'establishment_id': establishmentId,
        'content': content,
        'images': images,
        'likes': likes,
        'created_at': createdAt?.toIso8601String(),
      };
}

