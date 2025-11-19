import 'dart:collection';
import 'package:rede/models/order.dart';

class CartRepositoryMock {
  final Map<String, List<OrderItem>> _carts = {}; // userId -> items
  // removed unused _uuid field

  Future<void> addItem(String userId, OrderItem item) async {
    final items = _carts[userId] ?? [];
    items.add(item);
    _carts[userId] = items;
  }

  Future<List<OrderItem>> getItems(String userId) async {
    final items = _carts[userId] ?? <OrderItem>[];
    // Return an immutable copy
    return UnmodifiableListView<OrderItem>(items).toList();
  }

  Future<void> removeItem(String userId, String menuItemId) async {
    final items = _carts[userId] ?? [];
    items.removeWhere((i) => i.menuItemId == menuItemId);
    _carts[userId] = items;
  }

  Future<void> clear(String userId) async {
    _carts.remove(userId);
  }

  Future<double> computeTotal(String userId) async {
    final items = _carts[userId] ?? <OrderItem>[];
    double total = 0.0;
    for (final e in items) {
      total += e.price * e.quantity;
    }
    return total;
  }
}
