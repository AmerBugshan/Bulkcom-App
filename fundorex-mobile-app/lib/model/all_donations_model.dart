// To parse this JSON data, do
//
//     final allDonationsModel = allDonationsModelFromJson(jsonString);

import 'dart:convert';

AllDonationsModel allDonationsModelFromJson(String str) =>
    AllDonationsModel.fromJson(json.decode(str));

String allDonationsModelToJson(AllDonationsModel data) =>
    json.encode(data.toJson());

class AllDonationsModel {
  AllDonationsModel({
    required this.donations,
  });

  Donations donations;

  factory AllDonationsModel.fromJson(Map<String, dynamic> json) =>
      AllDonationsModel(
        donations: Donations.fromJson(json["donations"]),
      );

  Map<String, dynamic> toJson() => {
        "donations": donations.toJson(),
      };
}

class Donations {
  Donations({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<Datum> data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  List links;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory Donations.fromJson(Map<String, dynamic> json) => Donations(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] ?? [],
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
        "links": links,
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
    this.id,
    this.status,
    this.causeId,
    this.amount,
    this.paymentGateway,
    this.createdAt,
    this.cause,
  });

  dynamic id;
  dynamic status;
  dynamic causeId;
  String? amount;
  String? paymentGateway;
  DateTime? createdAt;
  Cause? cause;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        status: json["status"],
        causeId: json["cause_id"],
        amount: json["amount"],
        paymentGateway: json["payment_gateway"],
        createdAt: DateTime.parse(json["created_at"]),
        cause: Cause.fromJson(json["cause"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "cause_id": causeId,
        "amount": amount,
        "payment_gateway": paymentGateway,
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
