import 'dart:collection';
import 'package:uuid/uuid.dart';
import '../../models/profile_visit.dart';

class ProfileVisitRepositoryMock {
  final List<ProfileVisit> _visits = [];
  final Uuid _uuid = Uuid();

  Future<ProfileVisit> addVisit({
    String? visitorId,
    required String visitedUserId,
  }) async {
    final v = ProfileVisit(
      id: _uuid.v4(),
      visitorId: visitorId,
      visitedUserId: visitedUserId,
    );
    _visits.add(v);
    return v;
  }

  Future<List<ProfileVisit>> listForUser(String visitedUserId) async =>
      UnmodifiableListView(
        _visits.where((v) => v.visitedUserId == visitedUserId),
      ).toList();

  Future<int> countForUser(String visitedUserId) async =>
      _visits.where((v) => v.visitedUserId == visitedUserId).length;
}
