// Domain Entity: Reservation
class Reservation {
  final String id;
  final String userId;
  final String establishmentId;
  final String reservationType; // 'room', 'table', 'service', 'event'

  // Quartos
  final String? roomId;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? numberOfGuests;

  // Mesa
  final String? tableNumber;
  final DateTime? reservationTime;
  final int? partySize;

  // Serviço
  final String? serviceId;
  final DateTime? scheduledDate;

  // Status
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String? notes;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Reservation({
    required this.id,
    required this.userId,
    required this.establishmentId,
    required this.reservationType,
    this.roomId,
    this.checkInDate,
    this.checkOutDate,
    this.numberOfGuests,
    this.tableNumber,
    this.reservationTime,
    this.partySize,
    this.serviceId,
    this.scheduledDate,
    this.status = 'pending',
    this.notes,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  Reservation copyWith({
    String? id,
    String? userId,
    String? establishmentId,
    String? reservationType,
    String? roomId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? numberOfGuests,
    String? tableNumber,
    DateTime? reservationTime,
    int? partySize,
    String? serviceId,
    DateTime? scheduledDate,
    String? status,
    String? notes,
    double? totalPrice,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      establishmentId: establishmentId ?? this.establishmentId,
      reservationType: reservationType ?? this.reservationType,
      roomId: roomId ?? this.roomId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      numberOfGuests: numberOfGuests ?? this.numberOfGuests,
      tableNumber: tableNumber ?? this.tableNumber,
      reservationTime: reservationTime ?? this.reservationTime,
      partySize: partySize ?? this.partySize,
      serviceId: serviceId ?? this.serviceId,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
