// To parse this JSON data, do
//
//     final featureCampaignModel = featureCampaignModelFromJson(jsonString);

import 'dart:convert';

FeatureCampaignModel featureCampaignModelFromJson(String str) =>
    FeatureCampaignModel.fromJson(json.decode(str));

String featureCampaignModelToJson(FeatureCampaignModel data) =>
    json.encode(data.toJson());

class FeatureCampaignModel {
  FeatureCampaignModel({
    required this.donationFeature,
  });

  DonationFeature donationFeature;

  factory FeatureCampaignModel.fromJson(Map<String, dynamic> json) =>
      FeatureCampaignModel(
        donationFeature: DonationFeature.fromJson(json["donation_feature"]),
      );

  Map<String, dynamic> toJson() => {
        "donation_feature": donationFeature.toJson(),
      };
}

class DonationFeature {
  DonationFeature({
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
  List links;
  Data data;

  factory DonationFeature.fromJson(Map<String, dynamic> json) =>
      DonationFeature(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        path: json["path"],
        links: List<String>.from(json["links"].map((x) => x)),
        data: Data.fromJson(json["data"]),
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

class Data {
  Data({
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

  int? currentPage;
  List<Datum> data;
  String firstPageUrl;
  var from;
  dynamic lastPage;
  String lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String path;
  dynamic perPage;
  dynamic prevPageUrl;
  var to;
  int? total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: int.tryParse(json["current_page"].toString()) ?? 1,
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
        total: int.tryParse(json["total"].toString()) ?? 1,
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
    required this.raised,
    required this.amount,
    required this.image,
    required this.deadline,
    required this.reamainingTime,
  });

  dynamic id;
  String title;
  dynamic raised;
  String amount;
  String image;
  DateTime? deadline;
  DateTime? reamainingTime;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        raised: json["raised"],
        amount: json["amount"],
        image: json["image"],
        deadline: DateTime.tryParse(json["deadline"]),
        reamainingTime: DateTime.tryParse(json["reamaining_time"].toString()),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "raised": raised,
        "amount": amount,
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
        active: json["active"].toString() == "true",
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "label": label,
        "active": active,
      };
}
