class OrderItem {
  final String menuItemId;
  final int quantity;
  final double price;

  OrderItem({
    required this.menuItemId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() => {
    'menuItemId': menuItemId,
    'quantity': quantity,
    'price': price,
  };
}

class Order {
  final String id;
  final String userId;
  final String partnerId;
  final List<OrderItem> items;
  final double total;
  final String status; // pending, preparing, delivered, cancelled
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.partnerId,
    required this.items,
    required this.total,
    this.status = 'pending',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'partnerId': partnerId,
    'items': items.map((i) => i.toMap()).toList(),
    'total': total,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
  };
}
