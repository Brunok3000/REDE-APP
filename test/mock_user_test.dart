import 'package:flutter_test/flutter_test.dart';
import 'package:rede/repositories/mock/user_repository_mock.dart';

void main() {
  group('UserRepositoryMock', () {
    test('creates and finds user by email', () async {
      final repo = UserRepositoryMock();
      final user = await repo.createUser(name: 'Alice', email: 'alice@local');
      expect(user.id, isNotNull);
      final found = await repo.findByEmail('alice@local');
      expect(found, isNotNull);
      expect(found!.email, 'alice@local');
    });
  });
}
