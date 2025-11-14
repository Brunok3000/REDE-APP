class OrderModel {
  final String id;
  final String? establishmentId;
  final String? userId;
  final String? consumerId;
  final List<dynamic>? items;
  final double? total;
  final String? status;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    this.establishmentId,
    this.userId,
    this.consumerId,
    this.items,
    this.total,
    this.status,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      establishmentId: json['establishment_id'] as String?,
      userId: json['user_id'] as String?,
      consumerId: json['consumer_id'] as String?,
      items: json['items'] as List<dynamic>?,
      total: json['total'] != null ? (json['total'] as num).toDouble() : null,
      status: json['status'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'establishment_id': establishmentId,
    'user_id': userId,
    'consumer_id': consumerId,
    'items': items,
    'total': total,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
  };
}
