import 'dart:convert';

class CartItemModel {
  int? id;
  final String userId;
  final int productId;
  final double pricePerOne;
  final double totalPrice;
  final int quantity;
  final String productName;
  final String imagePath;

  CartItemModel({
    this.id,
    required this.userId,
    required this.productId,
    required this.pricePerOne,
    required this.totalPrice,
    required this.quantity,
    required this.productName,
    required this.imagePath,
  });

  CartItemModel copyWith({
    int? id,
    String? userId,
    int? productId,
    double? pricePerOne,
    double? totalPrice,
    int? quantity,
    String? productName,
    String? imagePath,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      pricePerOne: pricePerOne ?? this.pricePerOne,
      totalPrice: totalPrice ?? this.totalPrice,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'product_id': productId,
      'price_per_one': pricePerOne,
      'total_price': totalPrice,
      'quantity': quantity,
      'product_name': productName,
      'image_path': imagePath,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      id: map['id']?.toInt(),
      userId: map['user_id'] ?? '',
      productId: map['product_id'] ?? 0,
      pricePerOne:
          (map['price_per_one'] is num)
              ? (map['price_per_one'] as num).toDouble()
              : double.tryParse(map['price_per_one']?.toString() ?? '') ?? 0.0,
      totalPrice:
          (map['total_price'] is num)
              ? (map['total_price'] as num).toDouble()
              : double.tryParse(map['total_price']?.toString() ?? '') ?? 0.0,
      quantity:
          (map['quantity'] is int)
              ? map['quantity'] as int
              : int.tryParse(map['quantity']?.toString() ?? '') ?? 0,
      productName: map['product_name'] ?? '',
      imagePath: map['image_path'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartItemModel(id: $id, userId: $userId, productId: $productId, pricePerOne: $pricePerOne, totalPrice: $totalPrice, quantity: $quantity, productName: $productName, imagePath: $imagePath)';
  }
}
