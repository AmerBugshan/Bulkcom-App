// To parse this JSON data, do
//
//     final rewardPointsModel = rewardPointsModelFromJson(jsonString);

import 'dart:convert';

RewardPointsModel rewardPointsModelFromJson(String str) =>
    RewardPointsModel.fromJson(json.decode(str));

String rewardPointsModelToJson(RewardPointsModel data) =>
    json.encode(data.toJson());

class RewardPointsModel {
  RewardPointsModel({
    required this.rewardPoints,
  });

  List<RewardPoint> rewardPoints;

  factory RewardPointsModel.fromJson(Map<String, dynamic> json) =>
      RewardPointsModel(
        rewardPoints: List<RewardPoint>.from(
            json["reward_points"].map((x) => RewardPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "reward_points":
            List<dynamic>.from(rewardPoints.map((x) => x.toJson())),
      };
}

class RewardPoint {
  RewardPoint({
    this.id,
    this.causeId,
    this.rewardPoint,
    this.rewardAmount,
    this.createdAt,
    this.cause,
  });

  dynamic id;
  dynamic causeId;
  dynamic rewardPoint;
  dynamic rewardAmount;
  DateTime? createdAt;
  Cause? cause;

  factory RewardPoint.fromJson(Map<String, dynamic> json) => RewardPoint(
        id: json["id"],
        causeId: json["cause_id"],
        rewardPoint: json["reward_point"],
        rewardAmount: json["reward_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        cause: Cause.fromJson(json["cause"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cause_id": causeId,
        "reward_point": rewardPoint,
        "reward_amount": rewardAmount,
        "created_at": createdAt?.toIso8601String(),
        "cause": cause?.toJson(),
      };
}

class Cause {
  Cause({
    this.id,
    this.title,
  });

  dynamic id;
  String? title;

  factory Cause.fromJson(Map<String, dynamic> json) => Cause(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
