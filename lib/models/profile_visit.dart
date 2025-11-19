class ProfileVisit {
  final String id;
  final String? visitorId; // nullable for anonymous
  final String visitedUserId;
  final DateTime createdAt;

  ProfileVisit({
    required this.id,
    this.visitorId,
    required this.visitedUserId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
