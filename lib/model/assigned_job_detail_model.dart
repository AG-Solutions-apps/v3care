// To parse this JSON data, do
//
//     final assignedJobDetailModel = assignedJobDetailModelFromJson(jsonString);

import 'dart:convert';

AssignedJobDetailModel assignedJobDetailModelFromJson(String str) =>
    AssignedJobDetailModel.fromJson(json.decode(str));

String assignedJobDetailModelToJson(AssignedJobDetailModel data) =>
    json.encode(data.toJson());

class AssignedJobDetailModel {
  int? code;
  List<AssignedJobData>? data;

  AssignedJobDetailModel({
    this.code,
    this.data,
  });

  factory AssignedJobDetailModel.fromJson(Map<String, dynamic> json) =>
      AssignedJobDetailModel(
        code: json["code"],
        data: json["data"] == null
            ? []
            : List<AssignedJobData>.from(
                json["data"]!.map((x) => AssignedJobData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class AssignedJobData {
  int? id;
  String? orderRef;
  String? orderStatus;
  String? orderCustomer;
  String? orderCustomerMobile;
  DateTime? orderServiceDate;
  String? orderTime;
  String? orderService;
  String? orderServicePriceFor;
  String? orderCustom;
  int? orderAmount;
  int? orderAdvance;
  int? orderDiscount;
  String? orderVendorAmount;
  int? orderComm;
  String? orderFlat;
  String? orderBuilding;
  String? orderLandmark;
  String? orderAddress;
  String? orderUrl;
  String? orderLocality;
  String? orderSubLocality;
  String? serviceImage;
  dynamic orderPaymentAmount;
  String? orderPaymentType;

  AssignedJobData({
    this.id,
    this.orderRef,
    this.orderStatus,
    this.orderCustomer,
    this.orderCustomerMobile,
    this.orderServiceDate,
    this.orderTime,
    this.orderService,
    this.orderServicePriceFor,
    this.orderCustom,
    this.orderAmount,
    this.orderAdvance,
    this.orderDiscount,
    this.orderVendorAmount,
    this.orderComm,
    this.orderFlat,
    this.orderBuilding,
    this.orderLandmark,
    this.orderAddress,
    this.orderUrl,
    this.orderLocality,
    this.orderSubLocality,
    this.serviceImage,
    this.orderPaymentAmount,
    this.orderPaymentType,
  });

  factory AssignedJobData.fromJson(Map<String, dynamic> json) => AssignedJobData(
    id: json["id"],
    orderRef: json["order_ref"],
    orderStatus: json["order_status"],
    orderCustomer: json["order_customer"],
    orderCustomerMobile: json["order_customer_mobile"],
    orderServiceDate: json["order_service_date"] == null
        ? null
        : DateTime.tryParse(json["order_service_date"]),
    orderTime: json["order_time"],
    orderService: json["order_service"],
    orderServicePriceFor: json["order_service_price_for"],
    orderCustom: json["order_custom"],
    orderAmount: json["order_amount"],
    orderAdvance: json["order_advance"],
    orderDiscount: json["order_discount"],
    orderVendorAmount: json["order_vendor_amount"],
    orderComm: json["order_comm"],
    orderFlat: json["order_flat"],
    orderBuilding: json["order_building"],
    orderLandmark: json["order_landmark"],
    orderAddress: json["order_address"],
    orderUrl: json["order_url"],
    orderLocality: json["order_locality"],
    orderSubLocality: json["order_sub_locality"],
    serviceImage: json["service_image"],
    orderPaymentAmount: json["order_payment_amount"],
    orderPaymentType: json["order_payment_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "order_ref": orderRef,
    "order_status": orderStatus,
    "order_customer": orderCustomer,
    "order_customer_mobile": orderCustomerMobile,
    "order_service_date": orderServiceDate?.toIso8601String(),
    "order_time": orderTime,
    "order_service": orderService,
    "order_service_price_for": orderServicePriceFor,
    "order_custom": orderCustom,
    "order_amount": orderAmount,
    "order_advance": orderAdvance,
    "order_discount": orderDiscount,
    "order_vendor_amount": orderVendorAmount,
    "order_comm": orderComm,
    "order_flat": orderFlat,
    "order_building": orderBuilding,
    "order_landmark": orderLandmark,
    "order_address": orderAddress,
    "order_url": orderUrl,
    "order_locality": orderLocality,
    "order_sub_locality": orderSubLocality,
    "service_image": serviceImage,
    "order_payment_amount": orderPaymentAmount,
    "order_payment_type": orderPaymentType,
  };
}

// class AssignedJobData {
//   int? id;
//   String? orderRef;
//   String? orderStatus;
//   String? orderCustomerMobile;
//   DateTime? orderServiceDate;
//   String? orderTime;
//   String? orderService;
//   String? orderServicePriceFor;
//   String? orderCustom;
//   int? orderAmount;
//   int? orderAdvance;
//   int? orderComm;
//   String? orderFlat;
//   dynamic orderBuilding;
//   String? orderLandmark;
//   String? orderAddress;
//   dynamic orderUrl;
//   dynamic serviceImage;
//   dynamic orderPaymentAmount;
//   dynamic orderPaymentType;
//
//   AssignedJobData({
//     this.id,
//     this.orderRef,
//     this.orderStatus,
//     this.orderCustomerMobile,
//     this.orderServiceDate,
//     this.orderTime,
//     this.orderService,
//     this.orderServicePriceFor,
//     this.orderCustom,
//     this.orderAmount,
//     this.orderAdvance,
//     this.orderComm,
//     this.orderFlat,
//     this.orderBuilding,
//     this.orderLandmark,
//     this.orderAddress,
//     this.orderUrl,
//     this.serviceImage,
//     this.orderPaymentAmount,
//     this.orderPaymentType,
//   });
//
//   factory AssignedJobData.fromJson(Map<String, dynamic> json) =>
//       AssignedJobData(
//         id: json["id"],
//         orderRef: json["order_ref"],
//         orderStatus: json["order_status"],
//         orderCustomerMobile: json["order_customer_mobile"],
//         orderServiceDate: json["order_service_date"] == null
//             ? null
//             : DateTime.parse(json["order_service_date"]),
//         orderTime: json["order_time"],
//         orderService: json["order_service"],
//         orderServicePriceFor: json["order_service_price_for"],
//         orderCustom: json["order_custom"],
//         orderAmount: json["order_amount"],
//         orderAdvance: json["order_advance"],
//         orderComm: json["order_comm"],
//         orderFlat: json["order_flat"],
//         orderBuilding: json["order_building"],
//         orderLandmark: json["order_landmark"],
//         orderAddress: json["order_address"],
//         orderUrl: json["order_url"],
//         serviceImage: json["service_image"],
//         orderPaymentAmount: json["order_payment_amount"],
//         orderPaymentType: json["order_payment_type"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "order_ref": orderRef,
//         "order_status": orderStatus,
//         "order_customer_mobile": orderCustomerMobile,
//         "order_service_date":
//             "${orderServiceDate!.year.toString().padLeft(4, '0')}-${orderServiceDate!.month.toString().padLeft(2, '0')}-${orderServiceDate!.day.toString().padLeft(2, '0')}",
//         "order_time": orderTime,
//         "order_service": orderService,
//         "order_service_price_for": orderServicePriceFor,
//         "order_custom": orderCustom,
//         "order_amount": orderAmount,
//         "order_advance": orderAdvance,
//         "order_comm": orderComm,
//         "order_flat": orderFlat,
//         "order_building": orderBuilding,
//         "order_landmark": orderLandmark,
//         "order_address": orderAddress,
//         "order_url": orderUrl,
//         "service_image": serviceImage,
//         "order_payment_amount": orderPaymentAmount,
//         "order_payment_type": orderPaymentType,
//       };
// }