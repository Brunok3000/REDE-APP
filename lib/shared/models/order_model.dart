import 'dart:convert';

class OrderModelShared {
  int? id;
  final List<int> cartItemsId;
  final String address;
  final List<String> cartItemsName;
  final double totalPrice;
  final String userId;

  OrderModelShared({
    this.id,
    required this.cartItemsId,
    required this.address,
    required this.cartItemsName,
    required this.totalPrice,
    required this.userId,
  });

  OrderModelShared copyWith({
    int? id,
    List<int>? cartItemsId,
    String? address,
    List<String>? cartItemsName,
    double? totalPrice,
    String? userId,
  }) {
    return OrderModelShared(
      id: id ?? this.id,
      cartItemsId: cartItemsId ?? this.cartItemsId,
      address: address ?? this.address,
      cartItemsName: cartItemsName ?? this.cartItemsName,
      totalPrice: totalPrice ?? this.totalPrice,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cart_items_id': cartItemsId,
      'address': address,
      'cart_items_name': cartItemsName,
      'total_price': totalPrice,
      'user_id': userId,
    };
  }

  factory OrderModelShared.fromMap(Map<String, dynamic> map) {
    return OrderModelShared(
      id: map['id']?.toInt(),
      cartItemsId: List<int>.from(map['cart_items_id'] ?? []),
      address: map['address'] ?? '',
      cartItemsName: List<String>.from(map['cart_items_name'] ?? []),
      totalPrice:
          (map['total_price'] is num)
              ? (map['total_price'] as num).toDouble()
              : double.tryParse(map['total_price']?.toString() ?? '') ?? 0.0,
      userId: map['user_id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModelShared.fromJson(String source) =>
      OrderModelShared.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderModelShared(id: $id, cartItemsId: $cartItemsId, address: $address, cartItemsName: $cartItemsName, totalPrice: $totalPrice, userId: $userId)';
  }
}
