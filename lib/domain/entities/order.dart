// Domain Entity: Order
class Order {
  final String id;
  final String userId;
  final String establishmentId;
  final String
  status; // 'pending', 'confirmed', 'preparing', 'ready', 'on_the_way', 'delivered', 'cancelled'
  final String orderType; // 'delivery', 'takeaway'
  final int totalItems;
  final double subtotal;
  final double deliveryFee;
  final double tax;
  final double totalPrice;
  final String? deliveryAddress;
  final double? deliveryLatitude;
  final double? deliveryLongitude;
  final DateTime? estimatedDeliveryTime;
  final DateTime? deliveredAt;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.userId,
    required this.establishmentId,
    this.status = 'pending',
    required this.orderType,
    this.totalItems = 0,
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.tax = 0,
    required this.totalPrice,
    this.deliveryAddress,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
  });

  Order copyWith({
    String? id,
    String? userId,
    String? establishmentId,
    String? status,
    String? orderType,
    int? totalItems,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? totalPrice,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
    DateTime? estimatedDeliveryTime,
    DateTime? deliveredAt,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      establishmentId: establishmentId ?? this.establishmentId,
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      totalItems: totalItems ?? this.totalItems,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
      deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
      estimatedDeliveryTime:
          estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
