// Domain Entity: Post
class Post {
  final String id;
  final String userId;
  final String? establishmentId;
  final String content;
  final List<String> imageUrls;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final bool isPublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Post({
    required this.id,
    required this.userId,
    this.establishmentId,
    required this.content,
    this.imageUrls = const [],
    this.likesCount = 0,
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.isPublic = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? establishmentId,
    String? content,
    List<String>? imageUrls,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    bool? isPublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      establishmentId: establishmentId ?? this.establishmentId,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      isPublic: isPublic ?? this.isPublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
