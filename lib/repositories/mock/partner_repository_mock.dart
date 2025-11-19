import 'dart:collection';
import 'package:uuid/uuid.dart';
import '../../models/partner_profile.dart';
import '../../models/check_in.dart';
import '../../models/testimonial.dart';

class PartnerRepositoryMock {
  final Map<String, PartnerProfile> _store = {};
  final List<CheckIn> _checkIns = [];
  final List<Testimonial> _testimonials = [];
  final Uuid _uuid = Uuid();

  PartnerRepositoryMock();

  Future<PartnerProfile> createPartner(PartnerProfile p) async {
    _store[p.id] = p;
    return p;
  }

  Future<PartnerProfile?> getById(String id) async => _store[id];

  Future<List<PartnerProfile>> listAll() async =>
      UnmodifiableListView(_store.values).toList();

  Future<void> update(PartnerProfile p) async {
    _store[p.id] = p;
  }

  // Check-in logic: only allow check-in if last check-in for same user/partner was >24h
  Future<bool> tryCheckIn({
    required String userId,
    required String partnerId,
  }) async {
    // find last checkin for this user/partner
    CheckIn? last;
    for (final c in _checkIns.reversed) {
      if (c.userId == userId && c.partnerId == partnerId) {
        last = c;
        break;
      }
    }
    if (last != null) {
      final diff = DateTime.now().difference(last.createdAt);
      if (diff.inHours < 24) return false;
    }
    final c = CheckIn(id: _uuid.v4(), userId: userId, partnerId: partnerId);
    _checkIns.add(c);
    return true;
  }

  // Simple mayorship: returns userId with highest number of checkins for partner
  String? computeMayor(String partnerId) {
    final counts = <String, int>{};
    for (final c in _checkIns.where((c) => c.partnerId == partnerId)) {
      counts[c.userId] = (counts[c.userId] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  // Testimonials
  Future<Testimonial> addTestimonial(Testimonial t) async {
    _testimonials.add(t);
    return t;
  }

  Future<List<Testimonial>> listPendingTestimonials(
    String targetUserId,
  ) async =>
      _testimonials
          .where((t) => t.targetUserId == targetUserId && !t.approved)
          .toList();

  Future<List<Testimonial>> listApprovedTestimonials(
    String targetUserId,
  ) async =>
      _testimonials
          .where((t) => t.targetUserId == targetUserId && t.approved)
          .toList();

  Future<void> approveTestimonial(String id) async {
    final idx = _testimonials.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      final t = _testimonials[idx];
      _testimonials[idx] = t.copyWith(approved: true);
    }
  }
}
