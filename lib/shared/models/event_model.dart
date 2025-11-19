import 'dart:convert';

class EventModelShared {
  EventModelShared({
    required this.id,
    required this.title,
    required this.image,
    required this.date,
    required this.location,
    required this.description,
  });

  String id;
  String title;
  String image;
  String date;
  String location;
  String description;

  factory EventModelShared.fromJson(Map<String, dynamic> json) =>
      EventModelShared(
        id: json["id"].toString(),
        title: json["title"].toString(),
        image: json["image"].toString(),
        date: json["date"].toString(),
        location: json["location"].toString(),
        description: json["description"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "date": date,
    "location": location,
    "description": description,
  };

  factory EventModelShared.fromRawJson(String str) =>
      EventModelShared.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());
}
