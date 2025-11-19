import 'dart:collection';
import '../../models/order.dart';

class OrderRepositoryMock {
  final Map<String, Order> _store = {};
  // removed unused _uuid

  Future<Order> create(Order order) async {
    _store[order.id] = order;
    return order;
  }

  Future<List<Order>> listForUser(String userId) async =>
      UnmodifiableListView(
        _store.values.where((o) => o.userId == userId),
      ).toList();

  Future<Order?> getById(String id) async => _store[id];
}
