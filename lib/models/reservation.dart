import 'dart:convert';

class Reservation {
  final String id;
  final String userId;
  final String partnerId;
  final String? roomId; // optional for restaurant table/reservation
  final DateTime startDate;
  final DateTime endDate;
  final int guests;
  final double total;
  final String status; // pending/confirmed/cancelled

  Reservation({
    required this.id,
    required this.userId,
    required this.partnerId,
    this.roomId,
    required this.startDate,
    required this.endDate,
    required this.guests,
    required this.total,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'partnerId': partnerId,
      'roomId': roomId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'guests': guests,
      'total': total,
      'status': status,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as String,
      userId: map['userId'] as String,
      partnerId: map['partnerId'] as String,
      roomId: map['roomId'] as String?,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      guests: map['guests'] as int,
      total: (map['total'] as num).toDouble(),
      status: map['status'] as String? ?? 'pending',
    );
  }

  String toJson() => json.encode(toMap());

  factory Reservation.fromJson(String source) =>
      Reservation.fromMap(json.decode(source));
}
