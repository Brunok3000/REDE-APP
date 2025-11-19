// Domain Entity: Establishment
class Establishment {
  final String id;
  final String partnerId;
  final String name;
  final String? description;
  final String
  category; // 'hotel', 'bar', 'restaurant', 'delivery', 'salon', 'mechanic', 'bakery', 'nightclub', 'event_venue'
  final String? logoUrl;
  final String? coverImageUrl;
  final String address;
  final String city;
  final String state;
  final String? zipCode;
  final double? latitude;
  final double? longitude;
  final String? phone;
  final String? email;
  final String? website;
  final double rating;
  final int totalReviews;
  final bool isActive;
  final bool offersDelivery;
  final bool offersReservation;
  final bool offersEvents;
  final bool offersServices;
  final String? openingTime;
  final String? closingTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Establishment({
    required this.id,
    required this.partnerId,
    required this.name,
    this.description,
    required this.category,
    this.logoUrl,
    this.coverImageUrl,
    required this.address,
    required this.city,
    required this.state,
    this.zipCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.email,
    this.website,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.isActive = true,
    this.offersDelivery = false,
    this.offersReservation = false,
    this.offersEvents = false,
    this.offersServices = false,
    this.openingTime,
    this.closingTime,
    required this.createdAt,
    required this.updatedAt,
  });

  Establishment copyWith({
    String? id,
    String? partnerId,
    String? name,
    String? description,
    String? category,
    String? logoUrl,
    String? coverImageUrl,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? email,
    String? website,
    double? rating,
    int? totalReviews,
    bool? isActive,
    bool? offersDelivery,
    bool? offersReservation,
    bool? offersEvents,
    bool? offersServices,
    String? openingTime,
    String? closingTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Establishment(
      id: id ?? this.id,
      partnerId: partnerId ?? this.partnerId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isActive: isActive ?? this.isActive,
      offersDelivery: offersDelivery ?? this.offersDelivery,
      offersReservation: offersReservation ?? this.offersReservation,
      offersEvents: offersEvents ?? this.offersEvents,
      offersServices: offersServices ?? this.offersServices,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
