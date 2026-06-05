// To parse this JSON data, do
//
//     final aboutUsModel = aboutUsModelFromJson(jsonString);

import 'dart:convert';

AboutUsModel aboutUsModelFromJson(String str) =>
    AboutUsModel.fromJson(json.decode(str));

String aboutUsModelToJson(AboutUsModel data) => json.encode(data.toJson());

class AboutUsModel {
  int? code;
  Data? data;

  AboutUsModel({
    this.code,
    this.data,
  });

  AboutUsModel copyWith({
    int? code,
    Data? data,
  }) =>
      AboutUsModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory AboutUsModel.fromJson(Map<String, dynamic> json) => AboutUsModel(
        code: json["code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? companyName;
  String? companyAddress;
  dynamic companyGst;
  String? companyMobile;
  String? companyEmail;
  String? companyAbout;

  Data({
    this.id,
    this.companyName,
    this.companyAddress,
    this.companyGst,
    this.companyMobile,
    this.companyEmail,
    this.companyAbout,
  });

  Data copyWith({
    int? id,
    String? companyName,
    String? companyAddress,
    dynamic companyGst,
    String? companyMobile,
    String? companyEmail,
    String? companyAbout,
  }) =>
      Data(
        id: id ?? this.id,
        companyName: companyName ?? this.companyName,
        companyAddress: companyAddress ?? this.companyAddress,
        companyGst: companyGst ?? this.companyGst,
        companyMobile: companyMobile ?? this.companyMobile,
        companyEmail: companyEmail ?? this.companyEmail,
        companyAbout: companyAbout ?? this.companyAbout,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        companyName: json["company_name"],
        companyAddress: json["company_address"],
        companyGst: json["company_gst"],
        companyMobile: json["company_mobile"],
        companyEmail: json["company_email"],
        companyAbout: json["company_about"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company_name": companyName,
        "company_address": companyAddress,
        "company_gst": companyGst,
        "company_mobile": companyMobile,
        "company_email": companyEmail,
        "company_about": companyAbout,
      };
}
