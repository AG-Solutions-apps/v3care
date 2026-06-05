import 'dart:convert';

BookingJobModel bookingJobModelFromJson(String str) =>
    BookingJobModel.fromJson(json.decode(str));

String bookingJobModelToJson(BookingJobModel data) =>
    json.encode(data.toJson());

class BookingJobModel {
  int? code;
  List<BookingJobData>? data;

  BookingJobModel({
    this.code,
    this.data,
  });

  BookingJobModel copyWith({
    int? code,
    List<BookingJobData>? data,
  }) =>
      BookingJobModel(
        code: code ?? this.code,
        data: data ?? this.data,
      );

  factory BookingJobModel.fromJson(Map<String, dynamic> json) =>
      BookingJobModel(
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

class BookingJobData {
  int? id;
  String? orderRef;
  String? orderAssignStatus;
  String? orderCustomerName;
  String? orderCustomerMobile;
  DateTime? orderServiceDate;
  String? orderTime;
  String? orderService;
  String? orderServicePriceFor;
  String? orderCustom;
  int? orderAmount;
  int? orderAdvance;
  int? orderComm;
  String? orderFlat;
  dynamic orderBuilding;
  String? orderLandmark;
  String? orderLocality;
  String? orderSubLocality;
  String? orderAddress;
  dynamic orderUrl;
  dynamic serviceImage;
  String? orderStatus;
  dynamic orderPaymentAmount;
  dynamic orderPaymentType;

  BookingJobData({
    this.id,
    this.orderRef,
    this.orderAssignStatus,
    this.orderCustomerName,
    this.orderCustomerMobile,
    this.orderServiceDate,
    this.orderTime,
    this.orderService,
    this.orderServicePriceFor,
    this.orderCustom,
    this.orderAmount,
    this.orderAdvance,
    this.orderComm,
    this.orderFlat,
    this.orderBuilding,
    this.orderLandmark,
    this.orderLocality,
    this.orderSubLocality,
    this.orderAddress,
    this.orderUrl,
    this.serviceImage,
    this.orderStatus,
    this.orderPaymentAmount,
    this.orderPaymentType,
  });

  BookingJobData copyWith({
    int? id,
    String? orderRef,
    String? orderAssignStatus,
    String? orderCustomerName,
    String? orderCustomerMobile,
    DateTime? orderServiceDate,
    String? orderTime,
    String? orderService,
    String? orderServicePriceFor,
    String? orderCustom,
    int? orderAmount,
    int? orderAdvance,
    int? orderComm,
    String? orderFlat,
    dynamic orderBuilding,
    String? orderLandmark,
    String? orderLocality,
    String? orderSubLocality,
    String? orderAddress,
    dynamic orderUrl,
    dynamic serviceImage,
    String? orderStatus,
    dynamic orderPaymentAmount,
    dynamic orderPaymentType,
  }) =>
      BookingJobData(
        id: id ?? this.id,
        orderRef: orderRef ?? this.orderRef,
        orderAssignStatus: orderAssignStatus ?? this.orderAssignStatus,
        orderCustomerName: orderCustomerName ?? this.orderCustomerName,
        orderCustomerMobile: orderCustomerMobile ?? this.orderCustomerMobile,
        orderServiceDate: orderServiceDate ?? this.orderServiceDate,
        orderTime: orderTime ?? this.orderTime,
        orderService: orderService ?? this.orderService,
        orderServicePriceFor: orderServicePriceFor ?? this.orderServicePriceFor,
        orderCustom: orderCustom ?? this.orderCustom,
        orderAmount: orderAmount ?? this.orderAmount,
        orderAdvance: orderAdvance ?? this.orderAdvance,
        orderComm: orderComm ?? this.orderComm,
        orderFlat: orderFlat ?? this.orderFlat,
        orderBuilding: orderBuilding ?? this.orderBuilding,
        orderLandmark: orderLandmark ?? this.orderLandmark,
        orderLocality: orderLocality ?? this.orderLocality,
        orderSubLocality: orderSubLocality ?? this.orderSubLocality,
        orderAddress: orderAddress ?? this.orderAddress,
        orderUrl: orderUrl ?? this.orderUrl,
        serviceImage: serviceImage ?? this.serviceImage,
        orderStatus: orderStatus ?? this.orderStatus,
        orderPaymentAmount: orderPaymentAmount ?? this.orderPaymentAmount,
        orderPaymentType: orderPaymentType ?? this.orderPaymentType,
      );

  factory BookingJobData.fromJson(Map<String, dynamic> json) => BookingJobData(
        id: json["id"],
        orderRef: json["order_ref"],
        orderAssignStatus: json["order_assign_status"],
        orderCustomerName: json["order_customer"],
        orderCustomerMobile: json["order_customer_mobile"],
        orderServiceDate: json["order_service_date"] == null
            ? null
            : DateTime.parse(json["order_service_date"]),
        orderTime: json["order_time"],
        orderService: json["order_service"],
        orderServicePriceFor: json["order_service_price_for"],
        orderCustom: json["order_custom"],
        orderAmount: json["order_amount"],
        orderAdvance: json["order_advance"],
        orderComm: json["order_comm"],
        orderFlat: json["order_flat"],
        orderBuilding: json["order_building"],
        orderLandmark: json["order_landmark"],
        orderLocality: json["order_locality"],
        orderSubLocality: json["order_sub_locality"],
        orderAddress: json["order_address"],
        orderUrl: json["order_url"],
        serviceImage: json["service_image"],
        orderStatus: json["order_status"],
        orderPaymentAmount: json["order_payment_amount"],
        orderPaymentType: json["order_payment_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_ref": orderRef,
        "order_assign_status": orderAssignStatus,
        "order_customer": orderCustomerName,
        "order_customer_mobile": orderCustomerMobile,
        "order_service_date":
            "${orderServiceDate!.year.toString().padLeft(4, '0')}"
                "-${orderServiceDate!.month.toString().padLeft(2, '0')}"
                "-${orderServiceDate!.day.toString().padLeft(2, '0')}",
        "order_time": orderTime,
        "order_service": orderService,
        "order_service_price_for": orderServicePriceFor,
        "order_custom": orderCustom,
        "order_amount": orderAmount,
        "order_advance": orderAdvance,
        "order_comm": orderComm,
        "order_flat": orderFlat,
        "order_building": orderBuilding,
        "order_landmark": orderLandmark,
        "order_locality": orderLocality,
        "order_sub_locality": orderSubLocality,
        "order_address": orderAddress,
        "order_url": orderUrl,
        "service_image": serviceImage,
        "order_status": orderStatus,
        "order_payment_amount": orderPaymentAmount,
        "order_payment_type": orderPaymentType,
      };
}
