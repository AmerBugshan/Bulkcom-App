// To parse this JSON data, do
//
//     final followedUserListModel = followedUserListModelFromJson(jsonString);

import 'dart:convert';

FollowedUserListModel followedUserListModelFromJson(String str) =>
    FollowedUserListModel.fromJson(json.decode(str));

String followedUserListModelToJson(FollowedUserListModel data) =>
    json.encode(data.toJson());

class FollowedUserListModel {
  FollowedUserListModel({
    required this.data,
  });

  List<Datum> data;

  factory FollowedUserListModel.fromJson(Map<String, dynamic> json) =>
      FollowedUserListModel(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.userType,
    this.campaignOwnerId,
    this.campaignOwnerName,
    this.campaignOwnerCampaignItem,
  });

  dynamic id;
  String? userType;
  var campaignOwnerId;
  String? campaignOwnerName;
  dynamic campaignOwnerCampaignItem;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userType: json["user_type"],
        campaignOwnerId: json["campaign_owner_id"],
        campaignOwnerName: json["campaign_owner_name"],
        campaignOwnerCampaignItem: json["campaign_owner_campaign_item"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_type": userType,
        "campaign_owner_id": campaignOwnerId,
        "campaign_owner_name": campaignOwnerName,
        "campaign_owner_campaign_item": campaignOwnerCampaignItem,
      };
}
