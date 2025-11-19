import 'dart:collection';
import 'package:uuid/uuid.dart';
import '../../models/user.dart';

class UserRepositoryMock {
  final Map<String, User> _store = {};
  final Uuid _uuid = Uuid();
  String? _currentUserId;

  UserRepositoryMock() {
    // seed with a demo user
    final demo = User(
      id: _uuid.v4(),
      name: 'Demo User',
      email: 'demo@local',
      role: UserRole.user,
    );
    _store[demo.id] = demo;
    _currentUserId = demo.id;
  }

  Future<User> createUser({
    required String name,
    required String email,
    UserRole role = UserRole.user,
  }) async {
    final id = _uuid.v4();
    final user = User(id: id, name: name, email: email, role: role);
    _store[id] = user;
    return user;
  }

  Future<User?> getById(String id) async => _store[id];

  Future<User?> findByEmail(String email) async {
    for (final u in _store.values) {
      if (u.email == email) return u;
    }
    return null;
  }

  Future<List<User>> listAll() async =>
      UnmodifiableListView(_store.values).toList();

  Future<User?> signInMock(String email) async {
    for (final u in _store.values) {
      if (u.email == email) return u;
    }
    return null;
  }

  // Current user helpers (simple mock auth)
  Future<User?> getCurrentUser() async =>
      _currentUserId == null ? null : _store[_currentUserId!];

  void setCurrentUser(String id) {
    if (_store.containsKey(id)) _currentUserId = id;
  }
}
