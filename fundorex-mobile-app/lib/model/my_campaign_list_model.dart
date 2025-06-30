// To parse this JSON data, do
//
//     final myCampaignListModel = myCampaignListModelFromJson(jsonString);

import 'dart:convert';

MyCampaignListModel myCampaignListModelFromJson(String str) =>
    MyCampaignListModel.fromJson(json.decode(str));

String myCampaignListModelToJson(MyCampaignListModel data) =>
    json.encode(data.toJson());

class MyCampaignListModel {
  MyCampaignListModel({
    required this.allCampaigns,
  });

  List<AllCampaign> allCampaigns;

  factory MyCampaignListModel.fromJson(Map<String, dynamic> json) =>
      MyCampaignListModel(
        allCampaigns: List<AllCampaign>.from(
            json["all_campaigns"].map((x) => AllCampaign.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "all_campaigns":
            List<dynamic>.from(allCampaigns.map((x) => x.toJson())),
      };
}

class AllCampaign {
  AllCampaign({
    this.id,
    this.causeUpdateId,
    this.title,
    this.causeContent,
    this.amount,
    this.raised,
    this.status,
    this.image,
    this.metaTags,
    this.metaTitle,
    this.metaDescription,
    this.slug,
    this.userId,
    this.createdAt,
    this.createdBy,
    this.adminId,
    this.faq,
    this.deadline,
    this.imageGallery,
    this.featured,
    this.categoriesId,
    this.excerpt,
    this.ogMetaTitle,
    this.ogMetaDescription,
    this.ogMetaImage,
    this.updatedAt,
    this.medicalDocument,
    this.emmergency,
    this.reward,
    this.giftStatus,
    this.monthlyDonationStatus,
  });

  dynamic id;
  dynamic causeUpdateId;
  String? title;
  String? causeContent;
  String? amount;
  dynamic raised;
  String? status;
  String? image;
  dynamic metaTags;
  dynamic metaTitle;
  dynamic metaDescription;
  String? slug;
  dynamic userId;
  DateTime? createdAt;
  String? createdBy;
  dynamic adminId;
  String? faq;
  String? deadline;
  dynamic imageGallery;
  dynamic featured;
  dynamic categoriesId;
  dynamic excerpt;
  dynamic ogMetaTitle;
  dynamic ogMetaDescription;
  dynamic ogMetaImage;
  DateTime? updatedAt;
  dynamic medicalDocument;
  dynamic emmergency;
  dynamic reward;
  dynamic giftStatus;
  dynamic monthlyDonationStatus;

  factory AllCampaign.fromJson(Map<String, dynamic> json) => AllCampaign(
        id: json["id"],
        causeUpdateId: json["cause_update_id"],
        title: json["title"],
        causeContent: json["cause_content"],
        amount: json["amount"],
        raised: json["raised"],
        status: json["status"],
        image: json["image"],
        metaTags: json["meta_tags"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        slug: json["slug"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        adminId: json["admin_id"],
        faq: json["faq"],
        deadline: json["deadline"],
        imageGallery: json["image_gallery"],
        featured: json["featured"],
        categoriesId: json["categories_id"],
        excerpt: json["excerpt"],
        ogMetaTitle: json["og_meta_title"],
        ogMetaDescription: json["og_meta_description"],
        ogMetaImage: json["og_meta_image"],
        updatedAt: DateTime.parse(json["updated_at"]),
        medicalDocument: json["medical_document"],
        emmergency: json["emmergency"],
        reward: json["reward"],
        giftStatus: json["gift_status"],
        monthlyDonationStatus: json["monthly_donation_status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cause_update_id": causeUpdateId,
        "title": title,
        "cause_content": causeContent,
        "amount": amount,
        "raised": raised,
        "status": status,
        "image": image,
        "meta_tags": metaTags,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "slug": slug,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "admin_id": adminId,
        "faq": faq,
        "deadline": deadline,
        "image_gallery": imageGallery,
        "featured": featured,
        "categories_id": categoriesId,
        "excerpt": excerpt,
        "og_meta_title": ogMetaTitle,
        "og_meta_description": ogMetaDescription,
        "og_meta_image": ogMetaImage,
        "updated_at": updatedAt?.toIso8601String(),
        "medical_document": medicalDocument,
        "emmergency": emmergency,
        "reward": reward,
        "gift_status": giftStatus,
        "monthly_donation_status": monthlyDonationStatus,
      };
}
