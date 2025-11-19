import 'package:flutter_test/flutter_test.dart';
import 'package:rede/repositories/mock/reservation_repository_mock.dart';
import 'package:uuid/uuid.dart';
import 'package:rede/models/reservation.dart';

void main() {
  group('ReservationRepositoryMock', () {
    test('prevents overlapping reservations for same room', () async {
      final repo = ReservationRepositoryMock();
      final uuid = Uuid();
      final partnerId = uuid.v4();
      final roomId = uuid.v4();

      final r1 = Reservation(
        id: uuid.v4(),
        userId: uuid.v4(),
        partnerId: partnerId,
        roomId: roomId,
        startDate: DateTime(2025, 11, 20),
        endDate: DateTime(2025, 11, 22),
        guests: 2,
        total: 100.0,
      );
      await repo.create(r1);

      final avail = await repo.isAvailable(
        partnerId: partnerId,
        roomId: roomId,
        start: DateTime(2025, 11, 21),
        end: DateTime(2025, 11, 23),
      );
      expect(avail, isFalse);

      final avail2 = await repo.isAvailable(
        partnerId: partnerId,
        roomId: roomId,
        start: DateTime(2025, 11, 23),
        end: DateTime(2025, 11, 24),
      );
      expect(avail2, isTrue);
    });
  });
}
