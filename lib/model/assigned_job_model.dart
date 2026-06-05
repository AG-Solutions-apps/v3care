// To parse this JSON data, do
//
//     final assignedJobModel = assignedJobModelFromJson(jsonString);

import 'dart:convert';

import 'booking_job_model.dart';

AssignedJobModel assignedJobModelFromJson(String str) =>
    AssignedJobModel.fromJson(json.decode(str));

String assignedJobModelToJson(AssignedJobModel data) =>
    json.encode(data.toJson());

class AssignedJobModel {
  int? code;
  List<BookingJobData>? data;

  AssignedJobModel({
    this.code,
    this.data,
  });

  AssignedJobModel copyWith({
    int? code,
    List<BookingJobData>? data,
  }) =>
      AssignedJobModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory AssignedJobModel.fromJson(Map<String, dynamic> json) =>
      AssignedJobModel(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<BookingJobData>.from(
                json["data"]!.map((x) => BookingJobData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
