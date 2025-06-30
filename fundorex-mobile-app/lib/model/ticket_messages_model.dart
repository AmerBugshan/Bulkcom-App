// To parse this JSON data, do
//
//     final ticketMessageModel = ticketMessageModelFromJson(jsonString);

import 'dart:convert';

List<TicketMessageModel> ticketMessageModelFromJson(String str) =>
    List<TicketMessageModel>.from(
        json.decode(str).map((x) => TicketMessageModel.fromJson(x)));

String ticketMessageModelToJson(List<TicketMessageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketMessageModel {
  TicketMessageModel({
    this.id,
    this.supportTicketId,
    this.message,
    this.notify,
    this.attachment,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  var supportTicketId;
  String? message;
  String? notify;
  String? attachment;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) =>
      TicketMessageModel(
        id: json["id"],
        supportTicketId: json["support_ticket_id"],
        message: json["message"],
        notify: json["notify"],
        attachment: json["attachment"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "support_ticket_id": supportTicketId,
        "message": message,
        "notify": notify,
        "attachment": attachment,
        "type": type,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
