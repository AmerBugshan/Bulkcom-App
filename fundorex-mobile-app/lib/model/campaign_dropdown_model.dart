// To parse this JSON data, do
//
//     final campaignDropdownModel = campaignDropdownModelFromJson(jsonString);

import 'dart:convert';

CampaignDropdownModel campaignDropdownModelFromJson(String str) =>
    CampaignDropdownModel.fromJson(json.decode(str));

String campaignDropdownModelToJson(CampaignDropdownModel data) =>
    json.encode(data.toJson());

class CampaignDropdownModel {
  CampaignDropdownModel({
    required this.donationList,
  });

  List<DonationList> donationList;

  factory CampaignDropdownModel.fromJson(Map<String, dynamic> json) =>
      CampaignDropdownModel(
        donationList: List<DonationList>.from(
            json["donation_list"].map((x) => DonationList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "donation_list":
            List<dynamic>.from(donationList.map((x) => x.toJson())),
      };
}

class DonationList {
  DonationList({
    this.id,
    this.title,
  });

  dynamic id;
  String? title;

  factory DonationList.fromJson(Map<String, dynamic> json) => DonationList(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
