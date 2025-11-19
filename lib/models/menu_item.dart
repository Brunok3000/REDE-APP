import 'dart:convert';

class MenuItem {
  final String id;
  final String partnerId;
  final String title;
  final String? description;
  final double price;
  final List<String> photos;
  final List<String> tags;

  MenuItem({
    required this.id,
    required this.partnerId,
    required this.title,
    this.description,
    required this.price,
    List<String>? photos,
    List<String>? tags,
  }) : photos = photos ?? const [],
       tags = tags ?? const [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'partnerId': partnerId,
      'title': title,
      'description': description,
      'price': price,
      'photos': photos,
      'tags': tags,
    };
  }

  factory MenuItem.fromMap(Map<String, dynamic> map) {
    return MenuItem(
      id: map['id'] as String,
      partnerId: map['partnerId'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      price: (map['price'] as num).toDouble(),
      photos: List<String>.from(map['photos'] ?? []),
      tags: List<String>.from(map['tags'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuItem.fromJson(String source) =>
      MenuItem.fromMap(json.decode(source));
}
