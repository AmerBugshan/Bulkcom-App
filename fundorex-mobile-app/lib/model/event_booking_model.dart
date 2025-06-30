// To parse this JSON data, do
//
//     final eventBookingModel = eventBookingModelFromJson(jsonString);

import 'dart:convert';

EventBookingModel eventBookingModelFromJson(String str) =>
    EventBookingModel.fromJson(json.decode(str));

String eventBookingModelToJson(EventBookingModel data) =>
    json.encode(data.toJson());

class EventBookingModel {
  EventBookingModel({
    required this.bookedEvents,
  });

  BookedEvents bookedEvents;

  factory EventBookingModel.fromJson(Map<String, dynamic> json) =>
      EventBookingModel(
        bookedEvents: BookedEvents.fromJson(json["booked_events"]),
      );

  Map<String, dynamic> toJson() => {
        "booked_events": bookedEvents.toJson(),
      };
}

class BookedEvents {
  BookedEvents({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.path,
    required this.links,
    required this.data,
  });

  dynamic currentPage;
  dynamic lastPage;
  dynamic perPage;
  String? path;
  List links;
  List<Datum> data;

  factory BookedEvents.fromJson(Map<String, dynamic> json) => BookedEvents(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        path: json["path"],
        links: List<String>.from(json["links"].map((x) => x)),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
        "path": path,
        "links": List<dynamic>.from(links.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.status,
    this.paymentStatus,
    this.eventName,
    this.checkoutType,
    this.userId,
    this.eventCost,
    this.eventId,
    this.quantity,
    this.customFields,
    this.attachment,
    this.createdAt,
    this.updatedAt,
    this.paymentGateway,
    this.event,
  });

  dynamic id;
  dynamic status;
  String? paymentStatus;
  String? eventName;
  String? checkoutType;
  dynamic userId;
  String? eventCost;
  String? eventId;
  String? quantity;
  String? customFields;
  String? attachment;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? paymentGateway;
  Event? event;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        paymentStatus: json["payment_status"],
        eventName: json["event_name"],
        checkoutType: json["checkout_type"],
        userId: json["user_id"],
        eventCost: json["event_cost"],
        eventId: json["event_id"],
        quantity: json["quantity"],
        customFields: json["custom_fields"],
        attachment: json["attachment"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        paymentGateway: json["payment_gateway"],
        event: Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "payment_status": paymentStatus,
        "event_name": eventName,
        "checkout_type": checkoutType,
        "user_id": userId,
        "event_cost": eventCost,
        "event_id": eventId,
        "quantity": quantity,
        "custom_fields": customFields,
        "attachment": attachment,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "payment_gateway": paymentGateway,
        "event": event?.toJson(),
      };
}

class Event {
  Event({
    this.id,
    this.date,
  });

  dynamic id;
  DateTime? date;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
      };
}
