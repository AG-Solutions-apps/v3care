import 'package:flutter/material.dart';

import 'app_font.dart';
import 'app_sizes.dart';

class AppDefaults {
  /// Used For Border Radius
  static BorderRadius defaultBorderRadius =
      BorderRadius.circular(AppSizes.defaultRadius);

  /// Used For Bottom Sheet
  static BorderRadius defaultBottomSheetRadius = const BorderRadius.only(
    topLeft: Radius.circular(AppSizes.defaultRadius),
    topRight: Radius.circular(AppSizes.defaultRadius),
  );

  /// Used For Top Sheet
  static BorderRadius defaultTopSheetRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(AppSizes.defaultRadius),
    bottomRight: Radius.circular(AppSizes.defaultRadius),
  );

  /// Default Box Shadow used for containers
  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      blurRadius: 25,
      spreadRadius: 0,
      offset: const Offset(0, 2),
      color: Colors.black.withAlpha(20),
    ),
  ];

  /// Default Animation Duration used for the entire app
  static Duration defaultDuration = const Duration(milliseconds: 300);

  /// Default TextStyle
  static TextStyle textStyleSemiBold55({Color? fontColor}) => TextStyle(
      fontSize: 55,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleBold30({Color? fontColor}) => TextStyle(
      fontSize: 30,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleSemiBold36({Color? fontColor}) => TextStyle(
      fontSize: 26,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleSemiBold24({Color? fontColor}) => TextStyle(
      fontSize: 24,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleSemiBold18({Color? fontColor}) => TextStyle(
      fontSize: 18,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleRegular22({Color? fontColor}) => TextStyle(
      fontSize: 22,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w400,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleRegular16({Color? fontColor}) => TextStyle(
      fontSize: 16,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w400,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleRegular14({Color? fontColor}) => TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w400,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleRegular12({Color? fontColor}) => TextStyle(
      fontSize: 12,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w400,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleRegular36({Color? fontColor}) => TextStyle(
      fontSize: 36,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w400,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleRegular10({Color? fontColor}) => TextStyle(
      fontSize: 10.83,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w400,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleSemiBold12({Color? fontColor}) => TextStyle(
      fontSize: 12,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w500,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleSemiBold14({Color? fontColor}) => TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleMedium16({Color? fontColor}) => TextStyle(
      fontSize: 16,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w500,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleMedium12({Color? fontColor}) => TextStyle(
      fontSize: 12,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w500,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleMedium14({Color? fontColor}) => TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w500,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleMedium10({Color? fontColor}) => TextStyle(
      fontSize: 10,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w500,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleSemiBold16({Color? fontColor}) => TextStyle(
      fontSize: 16,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);

  static TextStyle textStyleBold14({Color? fontColor}) => TextStyle(
      fontSize: 14,
      fontFamily: AppFonts.poppins,
      fontWeight: FontWeight.w600,
      color: fontColor ?? Colors.black);
}
