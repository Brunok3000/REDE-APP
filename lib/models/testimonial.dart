import 'dart:convert';

class Testimonial {
  final String id;
  final String authorId;
  final String targetUserId;
  final String content;
  final bool isSecret;
  final bool approved;
  final DateTime createdAt;
  final String? reply;

  Testimonial({
    required this.id,
    required this.authorId,
    required this.targetUserId,
    required this.content,
    this.isSecret = false,
    this.approved = false,
    DateTime? createdAt,
    this.reply,
  }) : createdAt = createdAt ?? DateTime.now();

  Testimonial copyWith({
    String? id,
    String? authorId,
    String? targetUserId,
    String? content,
    bool? isSecret,
    bool? approved,
    DateTime? createdAt,
    String? reply,
  }) {
    return Testimonial(
      id: id ?? this.id,
      authorId: authorId ?? this.authorId,
      targetUserId: targetUserId ?? this.targetUserId,
      content: content ?? this.content,
      isSecret: isSecret ?? this.isSecret,
      approved: approved ?? this.approved,
      createdAt: createdAt ?? this.createdAt,
      reply: reply ?? this.reply,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorId': authorId,
      'targetUserId': targetUserId,
      'content': content,
      'isSecret': isSecret,
      'approved': approved,
      'createdAt': createdAt.toIso8601String(),
      'reply': reply,
    };
  }

  factory Testimonial.fromMap(Map<String, dynamic> map) {
    return Testimonial(
      id: map['id'] as String,
      authorId: map['authorId'] as String,
      targetUserId: map['targetUserId'] as String,
      content: map['content'] as String,
      isSecret: map['isSecret'] as bool? ?? false,
      approved: map['approved'] as bool? ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      reply: map['reply'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Testimonial.fromJson(String source) =>
      Testimonial.fromMap(json.decode(source));
}
