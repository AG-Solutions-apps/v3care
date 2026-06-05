// To parse this JSON data, do
//
//     final userDataModel = userDataModelFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) =>
    UserDataModel.fromJson(json.decode(str));

String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

class UserDataModel {
  int? code;
  String? msg;
  Data? data;

  UserDataModel({
    this.code,
    this.msg,
    this.data,
  });

  UserDataModel copyWith({
    int? code,
    String? msg,
    Data? data,
  }) =>
      UserDataModel(
        code: code ?? this.code,
        msg: msg ?? this.msg,
        data: data ?? this.data,
      );

  factory UserDataModel.fromJson(Map<dynamic, dynamic> json) => UserDataModel(
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
  String? token;
  User? user;

  Data({
    this.token,
    this.user,
  });

  Data copyWith({
    String? token,
    User? user,
  }) =>
      Data(
        token: token ?? this.token,
        user: user ?? this.user,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

class User {
  int? id;
  String? name;
  String? mobile;
  String? email;
  dynamic vendorId;
  int? userType;
  int? branchId;
  String? viewBranchId;
  dynamic userAadharNo;
  dynamic userAadhar;
  dynamic userPancardNo;
  dynamic userPancard;
  String? status;
  dynamic emailVerifiedAt;
  String? cpassword;
  String? token;
  dynamic deviceId;
  DateTime? lastLogin;
  dynamic remarks;
  DateTime? createdAt;
  String? createdBy;
  DateTime? updatedAt;
  dynamic updatedBy;

  User({
    this.id,
    this.name,
    this.mobile,
    this.email,
    this.vendorId,
    this.userType,
    this.branchId,
    this.viewBranchId,
    this.userAadharNo,
    this.userAadhar,
    this.userPancardNo,
    this.userPancard,
    this.status,
    this.emailVerifiedAt,
    this.cpassword,
    this.token,
    this.deviceId,
    this.lastLogin,
    this.remarks,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  User copyWith({
    int? id,
    String? name,
    String? mobile,
    String? email,
    dynamic vendorId,
    int? userType,
    int? branchId,
    String? viewBranchId,
    dynamic userAadharNo,
    dynamic userAadhar,
    dynamic userPancardNo,
    dynamic userPancard,
    String? status,
    dynamic emailVerifiedAt,
    String? cpassword,
    String? token,
    dynamic deviceId,
    DateTime? lastLogin,
    dynamic remarks,
    DateTime? createdAt,
    String? createdBy,
    DateTime? updatedAt,
    dynamic updatedBy,
  }) =>
      User(
        id: id ?? this.id,
        name: name ?? this.name,
        mobile: mobile ?? this.mobile,
        email: email ?? this.email,
        vendorId: vendorId ?? this.vendorId,
        userType: userType ?? this.userType,
        branchId: branchId ?? this.branchId,
        viewBranchId: viewBranchId ?? this.viewBranchId,
        userAadharNo: userAadharNo ?? this.userAadharNo,
        userAadhar: userAadhar ?? this.userAadhar,
        userPancardNo: userPancardNo ?? this.userPancardNo,
        userPancard: userPancard ?? this.userPancard,
        status: status ?? this.status,
        emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
        cpassword: cpassword ?? this.cpassword,
        token: token ?? this.token,
        deviceId: deviceId ?? this.deviceId,
        lastLogin: lastLogin ?? this.lastLogin,
        remarks: remarks ?? this.remarks,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        updatedAt: updatedAt ?? this.updatedAt,
        updatedBy: updatedBy ?? this.updatedBy,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
        vendorId: json["vendor_id"],
        userType: json["user_type"],
        branchId: json["branch_id"],
        viewBranchId: json["view_branch_id"],
        userAadharNo: json["user_aadhar_no"],
        userAadhar: json["user_aadhar"],
        userPancardNo: json["user_pancard_no"],
        userPancard: json["user_pancard"],
        status: json["status"],
        emailVerifiedAt: json["email_verified_at"],
        cpassword: json["cpassword"],
        token: json["token"],
        deviceId: json["device_id"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
        remarks: json["remarks"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
        "vendor_id": vendorId,
        "user_type": userType,
        "branch_id": branchId,
        "view_branch_id": viewBranchId,
        "user_aadhar_no": userAadharNo,
        "user_aadhar": userAadhar,
        "user_pancard_no": userPancardNo,
        "user_pancard": userPancard,
        "status": status,
        "email_verified_at": emailVerifiedAt,
        "cpassword": cpassword,
        "token": token,
        "device_id": deviceId,
        "last_login":
            "${lastLogin!.year.toString().padLeft(4, '0')}-${lastLogin!.month.toString().padLeft(2, '0')}-${lastLogin!.day.toString().padLeft(2, '0')}",
        "remarks": remarks,
        "created_at": createdAt?.toIso8601String(),
        "created_by": createdBy,
        "updated_at": updatedAt?.toIso8601String(),
        "updated_by": updatedBy,
      };
}
