// To parse this JSON data, do
//
//     final userDetailByIdModel = userDetailByIdModelFromJson(jsonString);

import 'dart:convert';

UserDetailByIdModel userDetailByIdModelFromJson(String str) =>
    UserDetailByIdModel.fromJson(json.decode(str));

String userDetailByIdModelToJson(UserDetailByIdModel data) =>
    json.encode(data.toJson());

class UserDetailByIdModel {
  int? code;
  String? msg;
  Data? data;

  UserDetailByIdModel({
    this.code,
    this.msg,
    this.data,
  });

  UserDetailByIdModel copyWith({
    int? code,
    String? msg,
    Data? data,
  }) =>
      UserDetailByIdModel(
        code: code ?? this.code,
        msg: msg ?? this.msg,
        data: data ?? this.data,
      );

  factory UserDetailByIdModel.fromJson(Map<String, dynamic> json) =>
      UserDetailByIdModel(
        code: json["code"],
        msg: json["msg"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data?.toJson(),
      };
}

class Data {
  int? id;
  String? name;
  String? occupation;
  String? company;
  String? image;
  String? product;
  String? mobile;
  String? whatsappNumber;
  String? email;
  String? referralCode;

  Data({
    this.id,
    this.name,
    this.occupation,
    this.company,
    this.image,
    this.product,
    this.mobile,
    this.whatsappNumber,
    this.email,
    this.referralCode,
  });

  Data copyWith({
    int? id,
    String? name,
    String? occupation,
    String? company,
    String? image,
    String? product,
    String? mobile,
    String? whatsappNumber,
    String? email,
    String? referralCode,
  }) =>
      Data(
        id: id ?? this.id,
        name: name ?? this.name,
        occupation: occupation ?? this.occupation,
        company: company ?? this.company,
        image: image ?? this.image,
        product: product ?? this.product,
        mobile: mobile ?? this.mobile,
        whatsappNumber: whatsappNumber ?? this.whatsappNumber,
        email: email ?? this.email,
        referralCode: referralCode ?? this.referralCode,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        occupation: json["occupation"],
        company: json["company"],
        image: json["image"],
        product: json["product"],
        mobile: json["mobile"],
        whatsappNumber: json["whatsapp_number"],
        email: json["email"],
        referralCode: json["referral_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "occupation": occupation,
        "company": company,
        "image": image,
        "product": product,
        "mobile": mobile,
        "whatsapp_number": whatsappNumber,
        "email": email,
        "referral_code": referralCode,
      };
}
