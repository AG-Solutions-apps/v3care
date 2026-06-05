// To parse this JSON data, do
//
//     final listOfUserModel = listOfUserModelFromJson(jsonString);

import 'dart:convert';

ListOfUserModel listOfUserModelFromJson(String str) =>
    ListOfUserModel.fromJson(json.decode(str));

String listOfUserModelToJson(ListOfUserModel data) =>
    json.encode(data.toJson());

class ListOfUserModel {
  int? code;
  String? msg;
  List<ListOfUserData>? data;

  ListOfUserModel({
    this.code,
    this.msg,
    this.data,
  });

  ListOfUserModel copyWith({
    int? code,
    String? msg,
    List<ListOfUserData>? data,
  }) =>
      ListOfUserModel(
        code: code ?? this.code,
        msg: msg ?? this.msg,
        data: data ?? this.data,
      );

  factory ListOfUserModel.fromJson(Map<String, dynamic> json) =>
      ListOfUserModel(
        code: json["code"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<ListOfUserData>.from(
                json["data"]!.map((x) => ListOfUserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ListOfUserData {
  int? id;
  String? name;
  String? occupation;
  String? company;
  String? image;
  int? detailsView;
  String? profileMix;
  String? mobile;
  String? whatsappNumber;
  String? email;
  String? area;
  String? companyShort;
  String? product;
  String? profileTag;
  String? referralCode;
  String? wishes;

  ListOfUserData({
    this.id,
    this.name,
    this.occupation,
    this.company,
    this.image,
    this.detailsView,
    this.profileMix,
    this.mobile,
    this.whatsappNumber,
    this.email,
    this.area,
    this.companyShort,
    this.product,
    this.profileTag,
    this.referralCode,
    this.wishes,
  });

  ListOfUserData copyWith({
    int? id,
    String? name,
    String? occupation,
    String? company,
    String? image,
    int? detailsView,
    String? profileMix,
    String? mobile,
    String? whatsappNumber,
    String? email,
    String? area,
    String? companyShort,
    String? product,
    String? profileTag,
    String? referralCode,
    String? wishes,
  }) =>
      ListOfUserData(
        id: id ?? this.id,
        name: name ?? this.name,
        occupation: occupation ?? this.occupation,
        company: company ?? this.company,
        image: image ?? this.image,
        detailsView: detailsView ?? this.detailsView,
        profileMix: profileMix ?? this.profileMix,
        mobile: mobile ?? this.mobile,
        whatsappNumber: whatsappNumber ?? this.whatsappNumber,
        email: email ?? this.email,
        area: area ?? this.area,
        companyShort: companyShort ?? this.companyShort,
        product: product ?? this.product,
        profileTag: profileTag ?? this.profileTag,
        referralCode: referralCode ?? this.referralCode,
        wishes: wishes ?? this.wishes,
      );

  factory ListOfUserData.fromJson(Map<String, dynamic> json) => ListOfUserData(
        id: json["id"],
        name: json["name"],
        occupation: json["occupation"],
        company: json["company"],
        image: json["image"],
        detailsView: json["details_view"],
        profileMix: json["profile_mix"],
        mobile: json["mobile"],
        whatsappNumber: json["whatsapp_number"],
        email: json["email"],
        area: json["area"],
        companyShort: json["company_short"],
        product: json["product"],
        profileTag: json["profile_tag"],
        referralCode: json["referral_code"],
        wishes: json["wishes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "occupation": occupation,
        "company": company,
        "image": image,
        "details_view": detailsView,
        "profile_mix": profileMix,
        "mobile": mobile,
        "whatsapp_number": whatsappNumber,
        "email": email,
        "area": area,
        "company_short": companyShort,
        "product": product,
        "profile_tag": profileTag,
        "referral_code": referralCode,
        "wishes": wishes,
      };
}
