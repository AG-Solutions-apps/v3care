// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? code;
  Data? data;

  ProfileModel({
    this.code,
    this.data,
  });

  ProfileModel copyWith({
    int? code,
    Data? data,
  }) =>
      ProfileModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
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
  String? name;
  String? mobile;
  String? email;

  Data({
    this.id,
    this.name,
    this.mobile,
    this.email,
  });

  Data copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
  }) =>
      Data(
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    mobile: json["mobile"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile": mobile,
    "email": email,
  };
}
