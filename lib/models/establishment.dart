class Establishment {
  final String id;
  final String name;
  final String? ownerId;
  final String? type;
  final Map<String, dynamic>? addressJson;
  final Map<String, dynamic>? servicesJson;
  final double? rating;
  final List<String>? photos;
  final DateTime? createdAt;

  const Establishment({
    required this.id,
    required this.name,
    this.ownerId,
    this.type,
    this.addressJson,
    this.servicesJson,
    this.rating,
    this.photos,
    this.createdAt,
  });

  factory Establishment.fromJson(Map<String, dynamic> json) {
    return Establishment(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['owner_id'] as String?,
      type: json['type'] as String?,
      addressJson: json['address_json'] as Map<String, dynamic>?,
      servicesJson: json['services_json'] as Map<String, dynamic>?,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      photos: json['photos'] != null
          ? List<String>.from(json['photos'] as List<dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_id': ownerId,
    'name': name,
    'type': type,
    'address_json': addressJson,
    'services_json': servicesJson,
    'rating': rating,
    'photos': photos,
    'created_at': createdAt?.toIso8601String(),
  };
}
