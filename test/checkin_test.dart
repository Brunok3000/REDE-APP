import 'package:flutter_test/flutter_test.dart';
import 'package:rede/repositories/mock/partner_repository_mock.dart';
import 'package:uuid/uuid.dart';

void main() {
  group('PartnerRepositoryMock - checkin', () {
    test('enforces 24h rule for same user/partner', () async {
      final repo = PartnerRepositoryMock();
      final uuid = Uuid();
      final userId = uuid.v4();
      final partnerId = uuid.v4();

      final first = await repo.tryCheckIn(userId: userId, partnerId: partnerId);
      expect(first, isTrue);

      // immediate second checkin should be rejected
      final second = await repo.tryCheckIn(
        userId: userId,
        partnerId: partnerId,
      );
      expect(second, isFalse);
    });
  });
}
