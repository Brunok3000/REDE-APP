import 'dart:collection';
import '../../models/reservation.dart';

class ReservationRepositoryMock {
  final Map<String, Reservation> _store = {};
  // removed unused _uuid

  Future<Reservation> create(Reservation r) async {
    _store[r.id] = r;
    return r;
  }

  Future<List<Reservation>> listForPartner(String partnerId) async =>
      UnmodifiableListView(
        _store.values.where((r) => r.partnerId == partnerId),
      ).toList();

  // Very simple availability check: ensures no overlapping reservation for same room
  Future<bool> isAvailable({
    required String partnerId,
    String? roomId,
    required DateTime start,
    required DateTime end,
  }) async {
    for (final r in _store.values.where(
      (x) => x.partnerId == partnerId && x.roomId == roomId,
    )) {
      if (!(end.isBefore(r.startDate) || start.isAfter(r.endDate))) {
        return false;
      }
    }
    return true;
  }

  Future<Reservation?> getById(String id) async => _store[id];
}
