import 'dart:async';
import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../controller/home_controller.dart';
import 'api.dart';

class ConstHelper {
  ConstHelper._();

  static ConstHelper constHelper = ConstHelper._();
  static final navigatorKey = GlobalKey<NavigatorState>();

  static TextStyle appBarTextStyle = TextStyle(
    color: ConstHelper.whiteColor,
    fontSize: Get.width * 0.045,
    fontWeight: FontWeight.bold,
  );
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color greyColor = Colors.grey;
  static Color orangeColor = const Color(0xffFB7705);
  static Color greyFigmaColor = const Color(0xFF898989);
  static Color lightBlackColor = const Color(0xFF393943);
  static Color darkBlueColor = const Color(0xFF30446E);
  static Color lightBlueColor = const Color(0xFF548ED1);
  static Color cementColor = const Color(0xFFA7AEB5);

  static String pleaseWaitMsg = "Please wait...";
  static String internetMsg = "Please check your internet";
  static String dataNotAvailableMsg = "Data not available.";
  static String noPendingRequestMsg = "No pending request.";
  static String noUpcomingClassMsg =
      "Sorry, \nwe couldn't find the job/service details";
  static String noNotificationsMsg = "No notifications.";
  static String somethingErrorMsg =
      "Sorry, Something has error\nPlease try again later...";
  static String unableToCreateRequestErrorMsg = "Unable to create requests";
  static String invalidPhoneNumberErrorMsg =
      "Sorry, Your phone number is invalid\nPlease enter the valid phone number...";
  static String invalidOTPErrorMsg =
      "Sorry, OTP is invalid\nPlease enter the valid otp...";
  static String manyRequestErrorMsg =
      "Sorry, You are many requested\nPlease Try again few hours later...";
  static String naMsg = "N/A";
  static String notAvailableMsg = "Not Available";
  static String yesMsg = "Yes";
  static String noMsg = "No";
  static String unauthorizedMsg = "Unauthorized...";
  static String dataUpdatedSuccessfullyMsg = 'Data Updated Successfully';
  static String dataSubmittedSuccessfullyMsg = 'Data Submitted Successfully';
  static String dataDeletedSuccessfullyMsg = 'Data Deleted Successfully';
  static String enquireCloseSuccessfullyMsg = 'Enquire Close Successfully';
  static String somethingWantWrongMsg =
      'We encountered an issue. Please try again later.';
  static String unknownErrorMsg =
      "Sorry, Internal error has occurred\nPlease try again later...";
  static String otpSentMsg =
      "Your OTP has been sent. Please check your messages.";

  static String notFoundImgPath =
      "https://agscare.site/crmapi/public/storage/no_image.jpg";

  /*  static String notFoundImgPath =
      "https://crm.aia.in.net/storage/app/public/no_image.jpg";*/

  static String userImagePath =
      "${API().imageBaseUrl}/storage/app/public/service/";
  static String noImage =
      "${API().imageBaseUrl}/storage/app/public/no_image.jpg";

  // static String userImagePath =
  //     "https://agsdraft.online/app/storage/app/public/service/";
  // static String noImage =
  //     "https://agsdraft.online/app/storage/app/public/no_image.jpg";
  static String termsConditionUrl = "${API().imageBaseUrl}/public/privacypolicy";

  /// Internet Connection Checking

  static Future<bool> checkInternet() async {
    try {
      var connectivityResultList = await Connectivity().checkConnectivity();
      return connectivityResultList
          .where((connectivityResult) =>
              (connectivityResult == ConnectivityResult.mobile ||
                  connectivityResult == ConnectivityResult.wifi))
          .toList()
          .isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  static Future<DateTime> getCurrentDateTime() async {
    try {
      bool internetAvailable = await checkInternet();
      return internetAvailable ? await NTP.now() : DateTime.now();
    } catch (error) {
      return DateTime.now();
    }
  }

  bool validateEmail({required String email}) {
    final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    );
    return emailRegex.hasMatch(email);
  }

  static FilteringTextInputFormatter spaceNotAllowFilter =
      FilteringTextInputFormatter.deny(RegExp(r'\s'));
  static ImageFilter filter = ImageFilter.blur(sigmaX: 3, sigmaY: 3);

  static void errorDialog({
    required String text,
    required int seconds,
  }) {
    AwesomeDialog(
      context: navigatorKey.currentContext!,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      headerAnimationLoop: false,
      desc: text,
      btnOkOnPress: () {},
      autoHide: Duration(
        seconds: seconds,
      ),
      btnOkText: 'Close',
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
      // customHeader: Container(
      //   width: Get.width/6,
      //   height: Get.width/6,
      //   decoration: const BoxDecoration(
      //     color: Colors.red,
      //     shape: BoxShape.circle,
      //   ),
      //   alignment: Alignment.center,
      //   child: Icon(Icons.cancel,color: whiteColor,),
      // )
    ).show();
  }

  static void successDialog({
    required String text,
    required int seconds,
  }) {
    AwesomeDialog(
      context: navigatorKey.currentContext!,
      dialogType: DialogType.success,
      animType: AnimType.leftSlide,
      headerAnimationLoop: false,
      desc: text,
      autoHide: Duration(
        seconds: seconds,
      ),
      btnOkOnPress: () {},
      btnOkText: 'Close',
      btnOkIcon: Icons.check_circle,
      btnOkColor: Colors.green,
    ).show();
  }

  String formatDate({
    required DateTime date,
  }) {
    String ordinalSuffix = getOrdinalSuffix(
      day: date.day,
    );
    return '${DateFormat('dd').format(date)}$ordinalSuffix ${DateFormat('MMMM yyyy').format(date)}';
  }

  String getOrdinalSuffix({
    required int day,
  }) {
    if (day >= 11 && day <= 13) {
      return 'th';
    } else if (day % 10 == 1) {
      return 'st';
    } else if (day % 10 == 2) {
      return 'nd';
    } else if (day % 10 == 3) {
      return 'rd';
    }
    return 'th';
  }

  Duration getTimeBetweenDuration({
    required String firstTime,
    required String secondTime,
  }) {
    DateTime firstDateTime = DateFormat('HH:mm').parse(firstTime);
    DateTime secondDateTime = DateFormat('HH:mm').parse(secondTime);
    return secondDateTime.difference(firstDateTime);
  }

  String getDurationInHourAndMin({
    required String firstTime,
    required String secondTime,
  }) {
    Duration duration = getTimeBetweenDuration(
      firstTime: firstTime,
      secondTime: secondTime,
    );
    int hour = duration.inHours;
    int minute = (duration.inMinutes % 60);
    return '${hour == 0 ? '' : '${hour.toString().padLeft(2, '0')} Hours'}${minute == 0 ? '' : ' ${minute.toString().padLeft(2, '0')} Min'}';
  }

  void areYouSureWantAlertDialog({
    required String title,
    required String description,
    required void Function() onPressed,
  }) {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: filter,
          child: AlertDialog(
            surfaceTintColor: AppColors.white,
            backgroundColor: AppColors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: Get.height / 50,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Text(
                  description,
                  style: TextStyle(
                      color: AppColors.black.withAlpha(204),
                      fontSize: Get.height / 55,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      height: 1.5),
                ),
              ],
            ),
            actions: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              letterSpacing: 1,
                              fontSize: Get.height / 60,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: Get.height / 60,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          "Delete My Account ?? ",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: ConstHelper.greyColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await ApiHelper.apiHelper
                              .postDeleteProfileApi()
                              .then((value) async {
                            try {
                              if (value.isNotEmpty) {
                                if (value['code'] == 200) {
                                  final responseData = json.decode(value.body);
                                  debugPrint(responseData);
                                  if (responseData['code'] == 200) {
                                    SharedPrefHelper.sharedPreferences.setBool(
                                      'login',
                                      false,
                                    );
                                    Get.offAll(
                                      const LoginPage(),
                                    );
                                    ConstHelper.successDialog(
                                      text: jsonDecode(value)['msg'] ??
                                          ConstHelper
                                              .dataDeletedSuccessfullyMsg,
                                      seconds: 10,
                                    );
                                  } else {
                                    ConstHelper.errorDialog(
                                      text: jsonDecode(value)['msg'] ??
                                          ConstHelper.somethingWantWrongMsg,
                                      seconds: 10,
                                    );
                                  }
                                } else {
                                  ConstHelper.errorDialog(
                                    text: jsonDecode(value)['msg'] ??
                                        ConstHelper.somethingWantWrongMsg,
                                    seconds: 10,
                                  );
                                }
                              }
                            } on TimeoutException catch (e) {
                              ConstHelper.errorDialog(
                                text: e.message.toString(),
                                seconds: 10,
                              );
                            }
                          });
                        },
                        child: Text(
                          "Click Here",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: ConstHelper.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),*/
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget topMenuAndProfilePhotoWidget({
    required String title,
    String? description,
  }) {
    HomeController homeController = Get.put(HomeController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: ConstHelper.blackColor,size: Get.width/15,),),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: ConstHelper.blackColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              description == null || description.trim().isEmpty
                  ? const SizedBox()
                  : Text(
                      description,
                      style: TextStyle(
                        color: ConstHelper.greyColor,
                        fontSize: 12,
                      ),
                    ),
            ],
          ),
        ),
        const SizedBox(),
        GestureDetector(
          onTap: () {
            homeController.bottomIndex.value = 3;
          },
          child: Container(
            height: Get.width / 7,
            width: Get.width / 7,
            decoration: BoxDecoration(
              color: ConstHelper.whiteColor,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl:
                    'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(6),
                    shape: BoxShape.circle,
                    color: ConstHelper.whiteColor,
                    border: Border.all(
                      color: ConstHelper.darkBlueColor,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: Get.width / 20,
                    width: Get.width / 20,
                    child: CircularProgressIndicator(
                      color: ConstHelper.darkBlueColor,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(6),
                    shape: BoxShape.circle,
                    color: ConstHelper.whiteColor,
                    border: Border.all(
                      color: ConstHelper.darkBlueColor,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/image/imageNotFound.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
