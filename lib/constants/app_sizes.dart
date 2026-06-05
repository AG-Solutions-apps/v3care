import 'package:flutter/material.dart';

/// Contains Default Values With SizedBox Static
class AppSizes {
  static const double defaultRadius = 10.00;
  static const double defaultPadding = 16.00;
  static const double defaultMargin = 16.00;
  /* <----------- Height Gap ------------> */
  static const hGap4 = SizedBox(height: 4);
  static const hGap6 = SizedBox(height: 6);
  static const hGap8 = SizedBox(height: 8);
  static const hGap9 = SizedBox(height: 9);
  static const hGap12 = SizedBox(height: 12);
  static const hGap16 = SizedBox(height: 16);
  static const hGap20 = SizedBox(height: 20);
  static const hGap24 = SizedBox(height: 24);
  static const hGap30 = SizedBox(height: 30);
  static const hGap250 = SizedBox(height: 250);
  static const hGap100 = SizedBox(height: 45);
  static const hGap70 = SizedBox(height: 70);
  static const hGap80 = SizedBox(height: 80);
/* <----------- Weight Gap ------------> */
  static const wGap4 = SizedBox(width: 4);
  static const wGap8 = SizedBox(width: 8);
  static const wGap12 = SizedBox(width: 12);
  static const wGap16 = SizedBox(width: 16);
  static const wGap200 = SizedBox(width: 205);
  static const wGa38 = SizedBox(width: 38);

  /// Used For Cover
  static const double defaultAspectRatio = 2 / 2;

  /// MediaQuery
  static double displayWidth(context){
    return MediaQuery.of(context).size.width;
  }

  static double displayHeight(context){
    return MediaQuery.of(context).size.height;
  }

  static double displayStatus(context){
    return MediaQuery.of(context).padding.top;
  }

  static double displayFontSize(context){
    return displayWidth(context)+displayWidth(context)+displayStatus(context);
  }

  static double horizontalPadding12(context){
    return MediaQuery.of(context).size.width * 12/360;
  }

  static double horizontalPadding6(context){
    return MediaQuery.of(context).size.width * 6/360;
  }

  static double horizontalPadding16(context){
    return MediaQuery.of(context).size.width * 16/360;
  }
  static double horizontalPadding24(context){
    return MediaQuery.of(context).size.width * 24/360;
  }
  static double verticalPadding12(context){
    return MediaQuery.of(context).size.height * 12/800;
  }
  static double verticalPadding16(context){
    return MediaQuery.of(context).size.height * 16/800;
  }
  static double verticalPadding24(context){
    return MediaQuery.of(context).size.height * 24/800;
  }

}