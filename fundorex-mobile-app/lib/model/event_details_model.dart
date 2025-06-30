// To parse this JSON data, do
//
//     final eventDetailsModel = eventDetailsModelFromJson(jsonString);

import 'dart:convert';

EventDetailsModel eventDetailsModelFromJson(String str) =>
    EventDetailsModel.fromJson(json.decode(str));

String eventDetailsModelToJson(EventDetailsModel data) =>
    json.encode(data.toJson());

class EventDetailsModel {
  EventDetailsModel({
    this.event,
    this.image,
  });

  Event? event;
  String? image;

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) =>
      EventDetailsModel(
        event: Event.fromJson(json["event"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "event": event?.toJson(),
        "image": image,
      };
}

class Event {
  Event({
    this.id,
    this.title,
    this.content,
    this.categoryId,
    this.status,
    this.date,
    this.time,
    this.cost,
    this.availableTickets,
    this.image,
    this.organizer,
    this.organizerEmail,
    this.organizerWebsite,
    this.organizerPhone,
    this.venue,
    this.slug,
    this.venueLocation,
    this.venuePhone,
    this.metaTags,
    this.metaTitle,
    this.metaDescription,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  dynamic id;
  String? title;
  String? content;
  String? categoryId;
  String? status;
  DateTime? date;
  String? time;
  String? cost;
  String? availableTickets;
  String? image;
  String? organizer;
  String? organizerEmail;
  String? organizerWebsite;
  String? organizerPhone;
  String? venue;
  String? slug;
  String? venueLocation;
  dynamic venuePhone;
  dynamic metaTags;
  dynamic metaTitle;
  dynamic metaDescription;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        categoryId: json["category_id"],
        status: json["status"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        cost: json["cost"],
        availableTickets: json["available_tickets"],
        image: json["image"],
        organizer: json["organizer"],
        organizerEmail: json["organizer_email"],
        organizerWebsite: json["organizer_website"],
        organizerPhone: json["organizer_phone"],
        venue: json["venue"],
        slug: json["slug"],
        venueLocation: json["venue_location"],
        venuePhone: json["venue_phone"],
        metaTags: json["meta_tags"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        category: Category.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "category_id": categoryId,
        "status": status,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "time": time,
        "cost": cost,
        "available_tickets": availableTickets,
        "image": image,
        "organizer": organizer,
        "organizer_email": organizerEmail,
        "organizer_website": organizerWebsite,
        "organizer_phone": organizerPhone,
        "venue": venue,
        "slug": slug,
        "venue_location": venueLocation,
        "venue_phone": venuePhone,
        "meta_tags": metaTags,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "category": category?.toJson(),
      };
}

class Category {
  Category({
    this.id,
    this.title,
  });

  dynamic id;
  String? title;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
