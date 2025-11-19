class Rating {
  final String id;
  final String raterId;
  final String targetUserId;
  final String category; // 'legal','sexy','confiavel'
  final int value; // 1..5
  final DateTime createdAt;

  Rating({
    required this.id,
    required this.raterId,
    required this.targetUserId,
    required this.category,
    required this.value,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
