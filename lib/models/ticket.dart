class TicketModel {
  final String id;
  final String? eventId;
  final String? userId;
  final int? quantity;
  final double? total;
  final DateTime? createdAt;

  TicketModel({
    required this.id,
    this.eventId,
    this.userId,
    this.quantity,
    this.total,
    this.createdAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
    id: json['id'] as String,
    eventId: json['event_id'] as String?,
    userId: json['user_id'] as String?,
    quantity: json['quantity'] as int?,
    total: json['total'] != null ? (json['total'] as num).toDouble() : null,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'event_id': eventId,
    'user_id': userId,
    'quantity': quantity,
    'total': total,
    'created_at': createdAt?.toIso8601String(),
  };
}

class Ticket {
  final String id;
  final String eventId;
  const Ticket({required this.id, required this.eventId});
}
