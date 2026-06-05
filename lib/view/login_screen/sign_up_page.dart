import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Constants/app_colors.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../controller/home_controller.dart';
import '../../widget/common_bg_widget.dart';
import '../../widget/common_button.dart';
import '../../widget/custom_text_form_field.dart';
import 'login_page.dart';
import 'otp_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  HomeController homeController = Get.put(HomeController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode usernameFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: CommonBgWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06, vertical: Get.height * 0.02),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.width / 5.8,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Sign ",
                          style: GoogleFonts.roboto(
                            fontSize: Get.height / 22,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "Up ",
                          style: GoogleFonts.roboto(
                            fontSize: Get.height / 22,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Create a new account!",
                    style: GoogleFonts.roboto(
                      fontSize: Get.height / 50,
                      color: AppColors.lightGrey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.width / 5,
                ),
                CustomTextFormField(
                  hintText: "Full Name",
                  controller: homeController.nameCon,
                  bgColor: const Color(0xFFFFFFFF),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Enter full name";
                    }
                    return null;
                  },
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: SvgPicture.asset("assets/images/svg/profile.svg"),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                CustomTextFormField(
                  hintText: "Email",
                  controller: homeController.emailCon,
                  bgColor: const Color(0xFFFFFFFF),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Enter Email";
                    } else if (!_isValidEmail(val)) {
                      return "Please Enter Valid Email";
                    }
                    return null;
                  },
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: SvgPicture.asset("assets/images/svg/email.svg"),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                CustomTextFormField(
                  hintText: "Mobile",
                  controller: homeController.mobileCon,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  bgColor: const Color(0xFFFFFFFF),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Enter Mobile";
                    } else if (val.length < 10) {
                      return "Please Enter Valid Mobile Number";
                    }
                    return null;
                  },
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: SvgPicture.asset("assets/images/svg/mobile.svg"),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                CustomTextFormField(
                  hintText: "Referral Code (if any)",
                  controller: homeController.referralCon,
                  bgColor: const Color(0xFFFFFFFF),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please Enter Referral Code";
                    }
                    return null;
                  },
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(Get.height * 0.02),
                    child: SvgPicture.asset("assets/images/svg/ticket.svg"),
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.08,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(
                      () => Checkbox(
                        overlayColor:
                            const WidgetStatePropertyAll(AppColors.lightGrey),
                        activeColor: AppColors.primaryColor,
                        value: homeController.check.value,
                        onChanged: (value) {
                          homeController.check.value =
                              !homeController.check.value;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        homeController.check.value =
                            !homeController.check.value;
                      },
                      child: Text(
                        "I agree with",
                        style: GoogleFonts.roboto(
                          fontSize: Get.height / 55,
                          color: AppColors.rockColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width / 60,
                    ),
                    GestureDetector(
                      onTap: () async {
                        /*Get.to(const TermsAndConditionPage(),
                            transition: Transition.fadeIn);*/
                        // Uri url = Uri.parse('https://aia.in.net/crm/app_t&c.html');
                        // if(await canLaunchUrl(url)) {
                        //   await launchUrl(url);
                        // } else {
                        //   ConstHelper.errorDialog(text: 'Url not found', seconds: 10,);
                        // }
                      },
                      child: Text(
                        "Terms & Condition",
                        style: GoogleFonts.roboto(
                          fontSize: Get.height / 55,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                CustomButton(
                  width: Get.width * 0.5,
                  buttonText: "Next",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      if (homeController.check.value) {
                        EasyLoading.show(status: ConstHelper.pleaseWaitMsg);

                        await Future.delayed(const Duration(milliseconds: 100));

                        if (!(await ConstHelper.checkInternet())) {
                          EasyLoading.dismiss();
                          Get.snackbar(
                            "No Internet",
                            'Please check your internet connection',
                            snackPosition:
                                SnackPosition.BOTTOM, // Position: TOP or BOTTOM
                          );
                          return;
                        }

                        try {
                          // Call your backend API to send OTP
                          var response = await ApiHelper.apiHelper.signUpUser(
                            name: homeController.nameCon.value.text,
                            email: homeController.emailCon.value.text,
                            mobile: homeController.mobileCon.value.text,
                            userType: homeController.userTypeCon.value.text,
                            area: homeController.areaCon.value.text,
                            referredCode: homeController.referralCon.value.text,
                          );
                          if (kDebugMode) {
                            print(response);
                          }
                          if (response.isNotEmpty) {
                            if (response['code'] == 200) {
                              homeController.mobileNo.value =
                                  homeController.mobileCon.text;
                              homeController.txtUsername.text =
                                  homeController.mobileCon.text;

                              // Navigate to OTP Page after successful response
                              Get.to(
                                () => const OTPPage(),
                                transition: Transition.fadeIn,
                              );
                              EasyLoading.dismiss();
                              ConstHelper.successDialog(
                                text: "Otp Sent Successfully",
                                seconds: 10,
                              );
                            } else {
                              EasyLoading.dismiss();
                              ConstHelper.errorDialog(
                                text: response['msg'] ??
                                    ConstHelper.unauthorizedMsg,
                                seconds: 10,
                              );
                            }
                          } else {
                            EasyLoading.dismiss();
                            ConstHelper.errorDialog(
                              text: ConstHelper.unauthorizedMsg,
                              seconds: 10,
                            );
                          }
                        } catch (error) {
                          EasyLoading.dismiss();
                          ConstHelper.errorDialog(
                            text: ConstHelper.somethingErrorMsg,
                            seconds: 10,
                          );
                        }
                      } else {
                        EasyLoading.dismiss();
                        ConstHelper.errorDialog(
                          text:
                              'Please read and accept the terms & conditions.',
                          seconds: 10,
                        );
                      }
                    }
                  },
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    Get.offAll(() => const LoginPage());
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Have an Account?",
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 65,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: " Sign In",
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 60,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

bool _isValidEmail(String email) {
  return ConstHelper.constHelper.validateEmail(email: email.trim());
}
