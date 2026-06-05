// To parse this JSON data, do
//
//     final userDetailModel = userDetailModelFromJson(jsonString);

import 'dart:convert';

UserDetailModel userDetailModelFromJson(String str) =>
    UserDetailModel.fromJson(json.decode(str));

String userDetailModelToJson(UserDetailModel data) =>
    json.encode(data.toJson());

class UserDetailModel {
  int? code;
  ProductImages? productImages;

  UserDetailModel({
    this.code,
    this.productImages,
  });

  UserDetailModel copyWith({
    int? code,
    ProductImages? productImages,
  }) =>
      UserDetailModel(
        code: code ?? this.code,
        productImages: productImages ?? this.productImages,
      );

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      UserDetailModel(
        code: json["code"],
        productImages: json["productimages"] == null
            ? null
            : ProductImages.fromJson(json["productimages"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "productimages": productImages?.toJson(),
      };
}

class ProductImages {
  int? id;
  int? bbcProfileId;
  List<String>? productImages; // Dynamic list for product images
  String? productAboutUs;
  dynamic createdAt;
  DateTime? updatedAt;
  String? name;
  String? occupation;
  String? category;
  String? company;
  String? companyShort;
  String? experience;
  String? address;
  String? area;
  String? addressProof;
  String? landline;
  String? workingHours;
  String? mobile;
  String? whatsappNumber;
  String? website;
  DateTime? dob;
  String? age;
  String? gender;
  String? spouseName;
  DateTime? spouseDob;
  String? product;
  DateTime? doa;
  String? expertise;
  String? image;
  String? userStatus;
  String? deviceId;
  int? detailsView;
  dynamic pageLink;
  dynamic profileUserType;
  dynamic community;
  dynamic communityType;
  dynamic communityOrder;
  String? email;
  dynamic emailVerifiedAt;
  String? password;
  String? cPassword;
  String? rememberToken;
  String? token;
  DateTime? lastLogin;
  String? profileTag;
  String? referralCode;
  dynamic referredByCode;
  String? profileMix;
  String? bPaid;
  String? pType;
  int? userType;
  String? adminType;

  ProductImages({
    this.id,
    this.bbcProfileId,
    this.productImages, // Initialize the product images list
    this.productAboutUs,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.occupation,
    this.category,
    this.company,
    this.companyShort,
    this.experience,
    this.address,
    this.area,
    this.addressProof,
    this.landline,
    this.workingHours,
    this.mobile,
    this.whatsappNumber,
    this.website,
    this.dob,
    this.age,
    this.gender,
    this.spouseName,
    this.spouseDob,
    this.product,
    this.doa,
    this.expertise,
    this.image,
    this.userStatus,
    this.deviceId,
    this.detailsView,
    this.pageLink,
    this.profileUserType,
    this.community,
    this.communityType,
    this.communityOrder,
    this.email,
    this.emailVerifiedAt,
    this.password,
    this.cPassword,
    this.rememberToken,
    this.token,
    this.lastLogin,
    this.profileTag,
    this.referralCode,
    this.referredByCode,
    this.profileMix,
    this.bPaid,
    this.pType,
    this.userType,
    this.adminType,
  });

  // Method to extract all product images dynamically from JSON
  factory ProductImages.fromJson(Map<String, dynamic> json) {
    List<String> dynamicProductImages = [];

    // Dynamically find product images
    json.forEach((key, value) {
      if (key.startsWith('product_image') && value is String) {
        dynamicProductImages.add(value);
      }
    });

    return ProductImages(
      id: json["id"],
      bbcProfileId: json["bbc_profile_id"],
      productImages:
          dynamicProductImages.isNotEmpty ? dynamicProductImages : null,
      productAboutUs: json["product_about_us"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
      name: json["name"],
      occupation: json["occupation"],
      category: json["category"],
      company: json["company"],
      companyShort: json["company_short"],
      experience: json["experience"],
      address: json["address"],
      area: json["area"],
      addressProof: json["address_proof"],
      landline: json["landline"],
      workingHours: json["working_hours"],
      mobile: json["mobile"],
      whatsappNumber: json["whatsapp_number"],
      website: json["website"],
      dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      age: json["age"],
      gender: json["gender"],
      spouseName: json["spouse_name"],
      spouseDob: json["spouse_dob"] == null
          ? null
          : DateTime.parse(json["spouse_dob"]),
      product: json["product"],
      doa: json["doa"] == null ? null : DateTime.parse(json["doa"]),
      expertise: json["expertise"],
      image: json["image"],
      userStatus: json["user_status"],
      deviceId: json["device_id"],
      detailsView: json["details_view"],
      pageLink: json["page_link"],
      profileUserType: json["profile_user_type"],
      community: json["community"],
      communityType: json["community_type"],
      communityOrder: json["community_order"],
      email: json["email"],
      emailVerifiedAt: json["email_verified_at"],
      password: json["password"],
      cPassword: json["cpassword"],
      rememberToken: json["remember_token"],
      token: json["token"],
      lastLogin: json["last_login"] == null
          ? null
          : DateTime.parse(json["last_login"]),
      profileTag: json["profile_tag"],
      referralCode: json["referral_code"],
      referredByCode: json["referred_by_code"],
      profileMix: json["profile_mix"],
      bPaid: json["b_paid"],
      pType: json["p_type"],
      userType: json["user_type"],
      adminType: json["admin_type"],
    );
  }

  Map<String, dynamic> toJson() {
    // Include productImages in the JSON representation
    final Map<String, dynamic> data = {
      "id": id,
      "bbc_profile_id": bbcProfileId,
      "product_about_us": productAboutUs,
      "created_at": createdAt,
      "updated_at": updatedAt?.toIso8601String(),
      "name": name,
      "occupation": occupation,
      "category": category,
      "company": company,
      "company_short": companyShort,
      "experience": experience,
      "address": address,
      "area": area,
      "address_proof": addressProof,
      "landline": landline,
      "working_hours": workingHours,
      "mobile": mobile,
      "whatsapp_number": whatsappNumber,
      "website": website,
      "dob": dob?.toIso8601String(),
      "age": age,
      "gender": gender,
      "spouse_name": spouseName,
      "spouse_dob": spouseDob?.toIso8601String(),
      "product": product,
      "doa": doa?.toIso8601String(),
      "expertise": expertise,
      "image": image,
      "user_status": userStatus,
      "device_id": deviceId,
      "details_view": detailsView,
      "page_link": pageLink,
      "profile_user_type": profileUserType,
      "community": community,
      "community_type": communityType,
      "community_order": communityOrder,
      "email": email,
      "email_verified_at": emailVerifiedAt,
      "password": password,
      "cpassword": cPassword,
      "remember_token": rememberToken,
      "token": token,
      "last_login": lastLogin?.toIso8601String(),
      "profile_tag": profileTag,
      "referral_code": referralCode,
      "referred_by_code": referredByCode,
      "profile_mix": profileMix,
      "b_paid": bPaid,
      "p_type": pType,
      "user_type": userType,
      "admin_type": adminType,
    };

    // Dynamically add productImages to the JSON
    if (productImages != null) {
      for (int i = 0; i < productImages!.length; i++) {
        data["product_image${i + 1}"] = productImages![i];
      }
    }

    return data;
  }
}
