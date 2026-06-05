// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  int? code;
  String? msg;
  List<SliderData>? data;

  SliderModel({
    this.code,
    this.msg,
    this.data,
  });

  SliderModel copyWith({
    int? code,
    String? msg,
    List<SliderData>? data,
  }) =>
      SliderModel(
        code: code ?? this.code,
        msg: msg ?? this.msg,
        data: data ?? this.data,
      );

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        code: json["code"],
        msg: json["msg"],
        data: json["data"] == null
            ? []
            : List<SliderData>.from(
                json["data"]!.map((x) => SliderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SliderData {
  int? id;
  dynamic sliderHeading;
  dynamic sliderButtonText;
  String? sliderImage;
  dynamic sliderLink;

  SliderData({
    this.id,
    this.sliderHeading,
    this.sliderButtonText,
    this.sliderImage,
    this.sliderLink,
  });

  SliderData copyWith({
    int? id,
    dynamic sliderHeading,
    dynamic sliderButtonText,
    String? sliderImage,
    dynamic sliderLink,
  }) =>
      SliderData(
        id: id ?? this.id,
        sliderHeading: sliderHeading ?? this.sliderHeading,
        sliderButtonText: sliderButtonText ?? this.sliderButtonText,
        sliderImage: sliderImage ?? this.sliderImage,
        sliderLink: sliderLink ?? this.sliderLink,
      );

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        id: json["id"],
        sliderHeading: json["slider_heading"],
        sliderButtonText: json["slider_button_text"],
        sliderImage: json["slider_image"],
        sliderLink: json["slider_link"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slider_heading": sliderHeading,
        "slider_button_text": sliderButtonText,
        "slider_image": sliderImage,
        "slider_link": sliderLink,
      };
}
