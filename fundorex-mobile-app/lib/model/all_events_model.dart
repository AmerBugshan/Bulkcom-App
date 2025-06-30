// To parse this JSON data, do
//
//     final allEventsModel = allEventsModelFromJson(jsonString);

import 'dart:convert';

AllEventsModel allEventsModelFromJson(String str) =>
    AllEventsModel.fromJson(json.decode(str));

String allEventsModelToJson(AllEventsModel data) => json.encode(data.toJson());

class AllEventsModel {
  AllEventsModel({
    required this.eventList,
  });

  EventList eventList;

  factory AllEventsModel.fromJson(Map<String, dynamic> json) => AllEventsModel(
        eventList: EventList.fromJson(json["event_list"]),
      );

  Map<String, dynamic> toJson() => {
        "event_list": eventList.toJson(),
      };
}

class EventList {
  EventList({
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

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
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
    this.title,
    this.image,
    this.date,
    this.time,
    this.cost,
    this.venueLocation,
  });

  dynamic id;
  String? title;
  String? image;
  DateTime? date;
  String? time;
  String? cost;
  String? venueLocation;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        cost: json["cost"]?.toString(),
        venueLocation: json["venue_location"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "date":
            "${date?.year.toString().padLeft(4, '0')}-${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}",
        "time": time,
        "cost": cost,
        "venue_location": venueLocation,
      };
}
