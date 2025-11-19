import 'dart:convert';

import 'establishment_type.dart';

class PartnerProfile {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final List<EstablishmentType> types;
  final bool active;
  final String? address;
  final Map<String, double>? geo; // {lat, lng}
  final Map<String, dynamic>? hours;
  final List<String> gallery;
  final Map<String, String>? contact;
  final String verificationStatus;

  PartnerProfile({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    List<EstablishmentType>? types,
    this.active = false,
    this.address,
    this.geo,
    this.hours,
    List<String>? gallery,
    this.contact,
    this.verificationStatus = 'unverified',
  }) : types = types ?? const [],
       gallery = gallery ?? const [];

  PartnerProfile copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    List<EstablishmentType>? types,
    bool? active,
    String? address,
    Map<String, double>? geo,
    Map<String, dynamic>? hours,
    List<String>? gallery,
    Map<String, String>? contact,
    String? verificationStatus,
  }) {
    return PartnerProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      types: types ?? this.types,
      active: active ?? this.active,
      address: address ?? this.address,
      geo: geo ?? this.geo,
      hours: hours ?? this.hours,
      gallery: gallery ?? this.gallery,
      contact: contact ?? this.contact,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'types': types.map((t) => t.name).toList(),
      'active': active,
      'address': address,
      'geo': geo,
      'hours': hours,
      'gallery': gallery,
      'contact': contact,
      'verificationStatus': verificationStatus,
    };
  }

  factory PartnerProfile.fromMap(Map<String, dynamic> map) {
    return PartnerProfile(
      id: map['id'] as String,
      userId: map['userId'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      types:
          (map['types'] as List<dynamic>?)
              ?.map((e) => EstablishmentTypeX.fromString(e as String))
              .toList() ??
          [],
      active: map['active'] as bool? ?? false,
      address: map['address'] as String?,
      geo: (map['geo'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      ),
      hours: map['hours'] as Map<String, dynamic>?,
      gallery: List<String>.from(map['gallery'] ?? []),
      contact: (map['contact'] as Map<String, dynamic>?)?.map(
        (k, v) => MapEntry(k, v.toString()),
      ),
      verificationStatus: map['verificationStatus'] as String? ?? 'unverified',
    );
  }

  String toJson() => json.encode(toMap());

  factory PartnerProfile.fromJson(String source) =>
      PartnerProfile.fromMap(json.decode(source));
}
