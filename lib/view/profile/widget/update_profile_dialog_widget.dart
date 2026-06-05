import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:v3care/Constants/app_colors.dart';

import '../../../Utils/api_helper.dart';
import '../../../Utils/const_helper.dart';
import '../../../controller/home_controller.dart';
import '../../../widget/common_button.dart';
import '../../../widget/custom_text_form_field.dart';

class CommonProfileDialogWidget extends StatelessWidget {
  final dynamic Function(Map val) onTap;

  const CommonProfileDialogWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());

    return SizedBox(
      width: Get.width * 0.8,
      child: Form(
        key: homeController.formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: Get.width * 0.04),
                    child: Text(
                      "Update Profile",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: Get.height / 35,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: SvgPicture.asset("assets/images/svg/close_icon.svg"))
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            CustomTextFormField(
              hintText: "Full name",
              controller: homeController.nameEditCon,
              keyboardType: TextInputType.name,
              counterText: "",
              textCapitalization: TextCapitalization.words,
              maxLength: 50,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              bgColor: AppColors.colorF5,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter full name";
                }
                return null;
              },
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            CustomTextFormField(
              hintText: "Email id",
              controller: homeController.emailEditCon,
              keyboardType: TextInputType.emailAddress,
              maxLength: 50,
              counterText: "",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              bgColor: AppColors.colorF5,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter email id";
                } else if (!ConstHelper.constHelper
                    .validateEmail(email: val.trim())) {
                  return "Please enter valid email id";
                }
                return null;
              },
            ),
            SizedBox(
              height: Get.height * 0.015,
            ),
            CustomTextFormField(
              hintText: "Mobile number",
              controller: homeController.mobileEditCon,
              maxLength: 10,
              keyboardType: TextInputType.number,
              counterText: "",
              readOnly: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              bgColor: AppColors.colorF5,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter mobile number";
                } else if (val.length < 10) {
                  return "Please enter valid mobile number";
                }
                return null;
              },
            ),
            SizedBox(
              height: Get.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  width: Get.width * 0.35,
                  heightFactor: Get.height * 0.02,
                  buttonText: "Update",
                  backgroundColor: AppColors.greenColor,
                  onTap: () async {
                    if (homeController.formKey.currentState!.validate()) {
                      try {
                        var val = await ApiHelper.apiHelper.updateProfileApi(
                            name: homeController.nameEditCon.text,
                            mobile: homeController.mobileEditCon.text,
                            email: homeController.emailEditCon.text,
                            loading: homeController.isProfileLoading);
                        if (kDebugMode) {
                          print(val);
                        }
                        EasyLoading.dismiss();
                        if (val["code"] == 200) {
                          Get.back();
                          ConstHelper.successDialog(
                            text: val["msg"],
                            seconds: 10,
                          );
                        } else {
                          Get.back();
                          ConstHelper.errorDialog(
                            text: ConstHelper.somethingWantWrongMsg,
                            seconds: 10,
                          );
                        }
                        onTap(val);
                      } catch (e) {
                        EasyLoading.dismiss();
                        ConstHelper.errorDialog(
                          text: ConstHelper.somethingWantWrongMsg,
                          seconds: 10,
                        );
                        Get.back();
                      }
                    }

                    /*if (homeController.nameEditCon.text.trim().isEmpty) {
                      ConstHelper.errorDialog(
                        text: "Please enter name",
                        seconds: 10,
                      );
                    } else if (homeController.emailEditCon.text.trim().isEmpty) {
                      ConstHelper.errorDialog(
                        text: 'Please enter email',
                        seconds: 10,
                      );
                    } else if (!ConstHelper.constHelper.validateEmail(
                        email: homeController.emailEditCon.text.trim())) {
                      ConstHelper.errorDialog(
                        text: 'Please enter valid email',
                        seconds: 10,
                      );
                    } else if (homeController.mobileEditCon.text.trim().isEmpty) {
                      ConstHelper.errorDialog(
                        text: 'Please enter mobile',
                        seconds: 10,
                      );
                    } else if (homeController.mobileEditCon.text.length < 10) {
                      ConstHelper.errorDialog(
                        text: 'Please enter valid mobile number',
                        seconds: 10,
                      );
                    } else {
                      EasyLoading.show(
                        status: ConstHelper.pleaseWaitMsg,
                      );
                      try {
                        var val = await ApiHelper.apiHelper.updateProfileApi(
                            name: homeController.nameEditCon.text,
                            mobile: homeController.mobileEditCon.text,
                            email: homeController.emailEditCon.text,
                            loading: homeController.isProfileLoading);
                        print(val);
                        EasyLoading.dismiss();
                        if (val["code"] == 200) {
                          Get.back();
                          ConstHelper.successDialog(
                            text: val["msg"],
                            seconds: 10,
                          );
                        } else {
                          Get.back();
                          ConstHelper.errorDialog(
                            text: ConstHelper.somethingWantWrongMsg,
                            seconds: 10,
                          );
                        }
                        onTap(val);
                      } catch (e) {
                        EasyLoading.dismiss();
                        ConstHelper.errorDialog(
                          text: ConstHelper.somethingWantWrongMsg,
                          seconds: 10,
                        );
                        Get.back();
                      }
                    }*/
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
