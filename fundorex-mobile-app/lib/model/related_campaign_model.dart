// To parse this JSON data, do
//
//     final featureCampaignModel = featureCampaignModelFromJson(jsonString);

import 'dart:convert';

RelatedCampaignModel relatedCampaignModelFromJson(String str) =>
    RelatedCampaignModel.fromJson(json.decode(str));

String relatedCampaignModelToJson(RelatedCampaignModel data) =>
    json.encode(data.toJson());

class RelatedCampaignModel {
  RelatedCampaignModel({
    required this.relatedCampaign,
  });

  DonationFeature relatedCampaign;

  factory RelatedCampaignModel.fromJson(Map<String, dynamic> json) =>
      RelatedCampaignModel(
        relatedCampaign: DonationFeature.fromJson(json["related_campaigns"]),
      );

  Map<String, dynamic> toJson() => {
        "related_campaigns": relatedCampaign.toJson(),
      };
}

class DonationFeature {
  DonationFeature({
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

  factory DonationFeature.fromJson(Map<String, dynamic> json) =>
      DonationFeature(
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
    this.raised,
    this.amount,
    this.image,
  });

  dynamic id;
  String? title;
  String? raised;
  String? amount;
  String? image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        raised: json["raised"],
        amount: json["amount"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "raised": raised,
        "amount": amount,
        "image": image,
      };
}
