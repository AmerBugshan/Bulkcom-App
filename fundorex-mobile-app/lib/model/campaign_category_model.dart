import 'dart:convert';

CampaignCategoryModel campaignCategoryModelFromJson(String str) =>
    CampaignCategoryModel.fromJson(json.decode(str));

String campaignCategoryModelToJson(CampaignCategoryModel data) =>
    json.encode(data.toJson());

class CampaignCategoryModel {
  CampaignCategoryModel({
    required this.content,
  });

  List<Content> content;

  factory CampaignCategoryModel.fromJson(Map<String, dynamic> json) =>
      CampaignCategoryModel(
        content:
            List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content": List<dynamic>.from(content.map((x) => x.toJson())),
      };
}

class Content {
  Content({
    this.id,
    this.name,
  });

  dynamic id;
  String? name;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
