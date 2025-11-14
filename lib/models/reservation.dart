class ReservationModel {
  final String id;
  final String? userId;
  final String? establishmentId;
  final DateTime? reservedFor;
  final int? partySize;
  final String? status;
  final DateTime? createdAt;

  ReservationModel({
    required this.id,
    this.userId,
    this.establishmentId,
    this.reservedFor,
    this.partySize,
    this.status,
    this.createdAt,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) =>
      ReservationModel(
        id: json['id'] as String,
        userId: json['user_id'] as String?,
        establishmentId: json['establishment_id'] as String?,
        reservedFor: json['reserved_for'] != null
            ? DateTime.parse(json['reserved_for'] as String)
            : null,
        partySize: json['party_size'] as int?,
        status: json['status'] as String?,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'establishment_id': establishmentId,
    'reserved_for': reservedFor?.toIso8601String(),
    'party_size': partySize,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
  };
}

class Reservation {
  final String id;
  final String establishmentId;
  const Reservation({required this.id, required this.establishmentId});
}
