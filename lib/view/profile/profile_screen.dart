import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v3care/view/profile/widget/update_profile_dialog_widget.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../Utils/shared_pref_helper.dart';
import '../../controller/home_controller.dart';
import '../../widget/common_button.dart';
import '../login_screen/login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  HomeController homeController = Get.put(HomeController());

  RxBool loader = true.obs;

  @override
  void initState() {
    // TODO: implement initState
    homeController.getUserData();
    getUserDetailData();
    super.initState();
  }

  Future<void> getUserDetailData() async {
    loader.value = true;
    try {
      await ApiHelper.apiHelper.getProfileData().then(
        (profileModel) {
          homeController.profileModel.value = profileModel;
          loader.value = false;
          setState(() {});
        },
      );
    } catch (error) {
      loader.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // getUpcomingClass();
    if (loader.value) {
      return Center(
        child: CircularProgressIndicator(
          color: ConstHelper.darkBlueColor,
        ),
      );
    } else if (homeController.profileModel.value.data == null) {
      return Center(
        child: notDataAvailableText(
          title: "No data Available",
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.bgColor,
        body: RefreshIndicator(
          onRefresh: () => getUserDetailData(),
          color: ConstHelper.darkBlueColor,
          backgroundColor: ConstHelper.whiteColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Container(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: Get.height * 0.05),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: ConstHelper.userImagePath + (""),
                                fit: BoxFit.cover,
                                height: Get.height * 0.22,
                                width: Get.height * 0.22,
                                placeholder: (context, url) => Container(
                                  color: ConstHelper.whiteColor,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(
                                    color: ConstHelper.darkBlueColor,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.network(ConstHelper.noImage,
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              height: Get.height * 0.025,
                              width: Get.height * 0.025,
                              decoration: const BoxDecoration(
                                  color: Color(0xff109138),
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              homeController.profileModel.value.data?.name ??
                                  "",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                fontSize: Get.height / 35,
                                color: AppColors.secondaryColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.015,
                ),
                Container(
                  color: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
                  child: Column(
                    children: [
                      commonRowProfile(
                          title: 'Employee ID',
                          subTitle: homeController.profileModel.value.data?.id
                                  ?.toString() ??
                              ""),
                      commonRowProfile(
                          title: 'Contact No',
                          subTitle:
                              homeController.profileModel.value.data?.mobile ??
                                  ""),
                      commonRowProfile(
                          title: 'Email ID',
                          subTitle:
                              homeController.profileModel.value.data?.email ??
                                  ""),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: Get.width * 0.45,
                      heightFactor: Get.height * 0.02,
                      buttonText: "Edit Profile",
                      onTap: () async {
                        homeController.nameEditCon.text =
                            homeController.profileModel.value.data?.name ?? "";
                        homeController.mobileEditCon.text =
                            homeController.profileModel.value.data?.mobile ??
                                "";
                        homeController.emailEditCon.text =
                            homeController.profileModel.value.data?.email ?? "";
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.zero,
                              backgroundColor: AppColors.white,
                              surfaceTintColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Get.height * 0.005),
                                ),
                              ),
                              title: CommonProfileDialogWidget(
                                onTap: (Map<dynamic, dynamic> val) {
                                  if (val.isNotEmpty && val["code"] == 200) {
                                    getUserDetailData();
                                  }
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    InkWell(
                      onTap: () async {
                        deleteDialog(
                          context,
                          Get.height,
                          Get.width,
                          () async {
                            await ApiHelper.apiHelper
                                .postDeleteProfileApi()
                                .then((value) async {
                              try {
                                if (value.isNotEmpty) {
                                  if (value['code'] == 200) {
                                    final responseData =
                                        json.decode(value.body);
                                    debugPrint(responseData);
                                    if (responseData['code'] == 200) {
                                      SharedPrefHelper.sharedPreferences
                                          .setBool(
                                        'login',
                                        false,
                                      );
                                      ConstHelper.successDialog(
                                        text: jsonDecode(value)['msg'] ??
                                            ConstHelper
                                                .dataDeletedSuccessfullyMsg,
                                        seconds: 10,
                                      );
                                      Future.delayed(
                                        const Duration(seconds: 1),
                                        () {
                                          return Get.offAll(
                                            const LoginPage(),
                                          );
                                        },
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
                        );
                      },
                      child: Text(
                        "Delete Account".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 60,
                          decoration: TextDecoration.underline,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget notDataAvailableText({required String title}) {
    return Text(
      title,
      style: TextStyle(
        color: ConstHelper.blackColor,
        fontWeight: FontWeight.w600,
        fontSize: Get.width * 0.045,
      ),
    );
  }
}

deleteDialog(context, double height, double width, void Function()? onPressed) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: height * 0.02),
              Text(
                "Delete Profile?".toUpperCase(),
                style: TextStyle(
                  fontSize: Get.width * 0.045,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                "Are you sure you want to delete your account? This will permanently erase your account.",
                style: TextStyle(
                  fontSize: Get.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black.withAlpha(204),
                  letterSpacing: 1,
                  height: 1.5,
                ),
              ),
              SizedBox(height: height * 0.03),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      child: Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Get.height / 60,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.04,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: Get.height / 60,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget commonRowProfile({required String title, required String subTitle}) {
  return Visibility(
    visible: subTitle.trim().isNotEmpty,
    child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: Get.height * 0.005, horizontal: Get.width * 0.04),
      child: Row(
        children: [
          Text(
            title,
            textAlign: TextAlign.start,
            style: GoogleFonts.inter(
              fontSize: Get.height / 55,
              color: AppColors.color70,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(" :  "),
          Expanded(
            flex: 3,
            child: Text(
              subTitle,
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                fontSize: Get.height / 55,
                color: AppColors.color80,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
