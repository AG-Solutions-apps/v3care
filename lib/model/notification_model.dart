// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  int? code;
  List<NotificationData>? data;

  NotificationModel({
    this.code,
    this.data,
  });

  NotificationModel copyWith({
    int? code,
    List<NotificationData>? data,
  }) =>
      NotificationModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
                json["data"]!.map((x) => NotificationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NotificationData {
  int? id;
  String? notificationHeading;
  String? notificationSubHeading;
  String? notificationStatus;
  dynamic notificationImage;
  DateTime? notificationCreateDate;

  NotificationData({
    this.id,
    this.notificationHeading,
    this.notificationSubHeading,
    this.notificationStatus,
    this.notificationImage,
    this.notificationCreateDate,
  });

  NotificationData copyWith({
    int? id,
    String? notificationHeading,
    String? notificationSubHeading,
    String? notificationStatus,
    dynamic notificationImage,
    DateTime? notificationCreateDate,
  }) =>
      NotificationData(
        id: id ?? this.id,
        notificationHeading: notificationHeading ?? this.notificationHeading,
        notificationSubHeading:
            notificationSubHeading ?? this.notificationSubHeading,
        notificationStatus: notificationStatus ?? this.notificationStatus,
        notificationImage: notificationImage ?? this.notificationImage,
        notificationCreateDate:
            notificationCreateDate ?? this.notificationCreateDate,
      );

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        notificationHeading: json["notification_heading"],
        notificationSubHeading: json["notification_sub_heading"],
        notificationStatus: json["notification_status"],
        notificationImage: json["notification_image"],
        notificationCreateDate: json["notification_create_date"] == null
            ? null
            : DateTime.parse(json["notification_create_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notification_heading": notificationHeading,
        "notification_sub_heading": notificationSubHeading,
        "notification_status": notificationStatus,
        "notification_image": notificationImage,
        "notification_create_date":
            "${notificationCreateDate!.year.toString().padLeft(4, '0')}-${notificationCreateDate!.month.toString().padLeft(2, '0')}-${notificationCreateDate!.day.toString().padLeft(2, '0')}",
      };
}
