class CheckIn {
  final String id;
  final String userId;
  final String partnerId;
  final DateTime createdAt;

  CheckIn({
    required this.id,
    required this.userId,
    required this.partnerId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'partnerId': partnerId,
    'createdAt': createdAt.toIso8601String(),
  };
}
