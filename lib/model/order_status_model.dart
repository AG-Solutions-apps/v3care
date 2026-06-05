// To parse this JSON data, do
//
//     final orderStatusDataModel = orderStatusDataModelFromJson(jsonString);

import 'dart:convert';

List<OrderStatusDataModel> orderStatusDataModelFromJson(String str) => List<OrderStatusDataModel>.from(json.decode(str).map((x) => OrderStatusDataModel.fromJson(x)));

String orderStatusDataModelToJson(List<OrderStatusDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderStatusDataModel {
  String? orderStatus;

  OrderStatusDataModel({
    this.orderStatus,
  });

  OrderStatusDataModel copyWith({
    String? orderStatus,
  }) =>
      OrderStatusDataModel(
        orderStatus: orderStatus ?? this.orderStatus,
      );

  factory OrderStatusDataModel.fromJson(Map<String, dynamic> json) => OrderStatusDataModel(
    orderStatus: json["order_status"],
  );

  Map<String, dynamic> toJson() => {
    "order_status": orderStatus,
  };
}
