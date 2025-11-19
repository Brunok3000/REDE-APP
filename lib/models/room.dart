import 'dart:convert';

class Room {
  final String id;
  final String partnerId;
  final String title;
  final String? description;
  final List<String> photos;
  final double price;
  final int capacity;
  final Map<String, dynamic>? availability; // simplified calendar

  Room({
    required this.id,
    required this.partnerId,
    required this.title,
    this.description,
    List<String>? photos,
    required this.price,
    required this.capacity,
    this.availability,
  }) : photos = photos ?? const [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'partnerId': partnerId,
      'title': title,
      'description': description,
      'photos': photos,
      'price': price,
      'capacity': capacity,
      'availability': availability,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      partnerId: map['partnerId'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      photos: List<String>.from(map['photos'] ?? []),
      price: (map['price'] as num).toDouble(),
      capacity: map['capacity'] as int,
      availability: map['availability'] as Map<String, dynamic>?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));
}
