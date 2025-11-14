class BookingModel {
  final String id;
  final String? userId;
  final String? establishmentId;
  final DateTime? start;
  final DateTime? end;
  final int? guests;
  final String? status;
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    this.userId,
    this.establishmentId,
    this.start,
    this.end,
    this.guests,
    this.status,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
    id: json['id'] as String,
    userId: json['user_id'] as String?,
    establishmentId: json['establishment_id'] as String?,
    start: json['check_in'] != null
        ? DateTime.parse(json['check_in'] as String)
        : null,
    end: json['check_out'] != null
        ? DateTime.parse(json['check_out'] as String)
        : null,
    guests: json['guests'] as int?,
    status: json['status'] as String?,
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'establishment_id': establishmentId,
    'check_in': start?.toIso8601String(),
    'check_out': end?.toIso8601String(),
    'guests': guests,
    'status': status,
    'created_at': createdAt?.toIso8601String(),
  };
}

class Booking {
  final String id;
  final String roomId;
  const Booking({required this.id, required this.roomId});
}
