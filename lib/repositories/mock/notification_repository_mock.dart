import 'dart:collection';
import 'package:uuid/uuid.dart';

class NotificationItem {
  final String id;
  final String userId; // who should receive
  final String title;
  final String body;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class NotificationRepositoryMock {
  final List<NotificationItem> _items = [];
  final Uuid _uuid = Uuid();

  Future<NotificationItem> addNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    final n = NotificationItem(
      id: _uuid.v4(),
      userId: userId,
      title: title,
      body: body,
    );
    _items.add(n);
    return n;
  }

  Future<List<NotificationItem>> listForUser(String userId) async =>
      UnmodifiableListView(_items.where((i) => i.userId == userId)).toList();
}
