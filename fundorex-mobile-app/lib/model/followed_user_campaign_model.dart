// To parse this JSON data, do
//
//     final followedUserCampaignModel = followedUserCampaignModelFromJson(jsonString);

import 'dart:convert';

FollowedUserCampaignModel followedUserCampaignModelFromJson(String str) =>
    FollowedUserCampaignModel.fromJson(json.decode(str));

String followedUserCampaignModelToJson(FollowedUserCampaignModel data) =>
    json.encode(data.toJson());

class FollowedUserCampaignModel {
  FollowedUserCampaignModel({
    required this.data,
    required this.campaignUserId,
  });

  FollowedUserCampaignModelData data;
  String campaignUserId;

  factory FollowedUserCampaignModel.fromJson(Map<String, dynamic> json) =>
      FollowedUserCampaignModel(
        data: FollowedUserCampaignModelData.fromJson(json["data"]),
        campaignUserId: json["campaign_user_id"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "campaign_user_id": campaignUserId,
      };
}

class FollowedUserCampaignModelData {
  FollowedUserCampaignModelData({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.path,
    required this.links,
    required this.data,
  });

  dynamic currentPage;
  dynamic lastPage;
  dynamic perPage;
  String path;
  List<String> links;
  DataData data;

  factory FollowedUserCampaignModelData.fromJson(Map<String, dynamic> json) =>
      FollowedUserCampaignModelData(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        path: json["path"],
        links: List<String>.from(json["links"].map((x) => x)),
        data: DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
        "path": path,
        "links": List<dynamic>.from(links.map((x) => x)),
        "data": data.toJson(),
      };
}

class DataData {
  DataData({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    required this.to,
    required this.total,
  });

  int currentPage;
  List<Datum> data;
  String firstPageUrl;
  var from;
  dynamic lastPage;
  var lastPageUrl;
  List links;
  dynamic nextPageUrl;
  String path;
  dynamic perPage;
  dynamic prevPageUrl;
  var to;
  int total;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.amount,
    required this.raised,
    required this.image,
    required this.deadline,
    required this.reamainingTime,
  });

  dynamic id;
  String title;
  String amount;
  dynamic raised;
  String image;
  DateTime? deadline;
  DateTime? reamainingTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        amount: json["amount"],
        raised: json["raised"],
        image: json["image"],
        deadline: DateTime.tryParse(json["deadline"].toString()),
        reamainingTime: DateTime.parse(json["reamaining_time"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "raised": raised,
        "image": image,
      };
}

class Link {
  Link({
    this.url,
    required this.label,
    required this.active,
  });

  String? url;
  String label;
  bool active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
