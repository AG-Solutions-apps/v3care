import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../Constants/app_colors.dart';
import '../../Constants/app_sizes.dart';
import '../../Utils/api_helper.dart';
import '../../Utils/const_helper.dart';
import '../../controller/home_controller.dart';
import '../../widget/common_bg_widget.dart';
import '../../widget/common_button.dart';
import 'otp_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  HomeController homeController = Get.put(HomeController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode usernameFocusNode = FocusNode();
  final controller = WebViewController();
  RxBool checkTermsCondition = false.obs;

  @override
  void initState() {
    homeController.check.value = false;
    homeController.txtUsername.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ConstHelper.whiteColor,
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
                SizedBox(
                  height: Get.width / 8,
                ),
                Image.asset(
                  "assets/images/v3_logo.png",
                  fit: BoxFit.cover,
                  height: Get.height / 5.5,
                ),
                SizedBox(
                  height: Get.width / 6,
                ),
                /* RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Sign ",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 25,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: "IN ",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 25,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),*/
                /*SizedBox(
                  height: Get.height * 0.01,
                ),
                Text(
                  "Hello, Welcome back to your account",
                  style: GoogleFonts.inter(
                    fontSize: Get.height / 55,
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),*/
                SizedBox(
                  height: Get.height * 0.02,
                ),
                Center(
                  child: SizedBox(
                    // width: Get.width/1.5,
                    child: TextFormField(
                      controller: homeController.txtUsername,
                      focusNode: usernameFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: (value) {
                        if (value.length == 10) {
                          FocusScope.of(context)
                              .unfocus(); // 👈 Hides the keyboard
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppSizes.displayHeight(context) * 0.06),
                          borderSide: const BorderSide(color: AppColors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppSizes.displayHeight(context) * 0.06),
                          borderSide: const BorderSide(color: AppColors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              AppSizes.displayHeight(context) * 0.06),
                          borderSide: const BorderSide(color: AppColors.grey),
                        ),
                        counterText: '',
                        fillColor: AppColors.lightGrey,
                        filled: true,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: Get.width / 30,
                            vertical: Get.width / 27),
                        hintStyle: GoogleFonts.inter(
                          fontSize: Get.height / 60,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                        hintText: "Enter your mobile number",
                        prefixIcon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "   +91 |  ",
                              style: GoogleFonts.inter(
                                fontSize: Get.height / 55,
                                color: AppColors.color54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return 'Mobile number is required';
                        } else if (value.length != 10) {
                          return "Enter valid mobile number";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.width / 15,
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
                        "I accept the",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 60,
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          // Add this line for underline
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width / 60,
                    ),
                    GestureDetector(
                      onTap: () async {
                        controller
                          ..setJavaScriptMode(JavaScriptMode.unrestricted)
                          ..loadRequest(Uri.parse(ConstHelper
                              .termsConditionUrl /* "https://agsdraft.online/privacypolicy.html"*/));
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.03),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Get.height * 0.01),
                                ),
                              ),
                              titlePadding: EdgeInsets.only(
                                  top: Get.height * 0.01,
                                  right: 10,
                                  bottom: Get.height * 0.01),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                          AppColors.grey.withAlpha(128)),
                                      child: const Icon(
                                        Icons.close,
                                        color: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.all(0),
                              content: SizedBox(
                                width: Get.width * 0.9,
                                height: Get.height * 0.85,
                                // Optional: control height
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Get.height * 0.01),
                                  ),
                                  child: WebViewWidget(controller: controller),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Terms & Conditions",
                        style: GoogleFonts.inter(
                          fontSize: Get.height / 60,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Get.width / 9,
                ),
                Obx(
                  () => CustomButton(
                    width: Get.width * 0.7,
                    buttonText: "Receive OTP",
                    isLoading: homeController.isLoading.value,
                    onTap: () async {
                      usernameFocusNode.unfocus();
                      if (formKey.currentState!.validate()) {
                        if (homeController.check.value) {
                          // await Future.delayed(const Duration(milliseconds: 100));

                          if (!(await ConstHelper.checkInternet())) {
                            EasyLoading.dismiss();
                            Get.snackbar(
                              "No Internet",
                              'Please check your internet connection',
                              snackPosition: SnackPosition
                                  .BOTTOM, // Position: TOP or BOTTOM
                            );
                            return;
                          }

                          try {
                            EasyLoading.show(
                              status: ConstHelper.pleaseWaitMsg,
                            );
                            homeController.isLoading.value = true;
                            /* await FirebaseAuth.instance.setSettings(
                              appVerificationDisabledForTesting:
                                  false, // Ensure this is false for production
                            );*/
                            // Call your backend API to send OTP
                            var response =
                                await ApiHelper.apiHelper.checkMobileNumber(
                              mobileNo: homeController.txtUsername.text,
                            );

                            if (response.isNotEmpty) {
                              if (response['code'] == 200) {
                                homeController.mobileNo.value =
                                    homeController.txtUsername.text;
                                homeController.password.value =
                                    response['data'] ?? '';
                                /* Get.to(
                                const OTPPage(),
                                transition: Transition.fadeIn,
                              );*/
                                //EasyLoading.dismiss();

                                if (kDebugMode) {
                                  // Navigate to OTP Page after successful response
                                  await FirebaseAuth.instance.setSettings(
                                    appVerificationDisabledForTesting:
                                    false, // Ensure this is false for production
                                  );
                                }

                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber:
                                      '+91 ${homeController.txtUsername.text}',
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) {
                                    homeController.isLoading.value = false;
                                    if (kDebugMode) {
                                      print('verificationId: ${credential.verificationId}~~${credential.smsCode}');
                                      print('smsCode: ${credential.smsCode}~~${credential.token}');
                                      print('accessToken: ${credential.accessToken}~~${credential.providerId}');
                                      print('signInMethod: ${credential.signInMethod}');
                                    }
                                    EasyLoading.dismiss();
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException e) async {
                                    homeController.isLoading.value = false;
                                    if (kDebugMode) {
                                      print('Error~~ : ${e.code}~${e.message}');
                                    }
                                    if (e.code == 'invalid-phone-number') {
                                      ConstHelper.errorDialog(
                                        text: ConstHelper
                                            .invalidPhoneNumberErrorMsg,
                                        seconds: 10,
                                      );
                                      EasyLoading.dismiss();
                                    } else if (e.code == 'too-many-requests') {
                                      homeController.isLoading.value = false;
                                      ConstHelper.errorDialog(
                                        text: ConstHelper.manyRequestErrorMsg,
                                        seconds: 10,
                                      );
                                      EasyLoading.dismiss();
                                    } else {
                                      if (e.code == 'unknown') {
                                        ConstHelper.errorDialog(
                                          text: e.message ??
                                              ConstHelper.unknownErrorMsg,
                                          seconds: 10,
                                        );
                                        EasyLoading.dismiss();
                                      }
                                      EasyLoading.dismiss();
                                    }
                                  },
                                  codeSent: (String verificationId,
                                      int? resendToken) {
                                    homeController.isLoading.value = false;
                                    EasyLoading.dismiss();
                                    if (kDebugMode) {
                                      print(
                                        'Success : $verificationId $resendToken');
                                    }
                                    homeController.mobileNo.value =
                                        homeController.txtUsername.value.text;
                                    homeController.password.value =
                                        response['data'] ?? '';
                                    homeController.otpResendCode.value =
                                        resendToken ?? 0;
                                    homeController.otpVerificationId.value =
                                        verificationId;
                                    homeController.isLoading.value = false;
                                    Get.to(
                                      () => const OTPPage(),
                                      transition: Transition.fadeIn,
                                    );
                                    Get.snackbar(
                                      "OTP Sent",
                                      response['msg'] ??
                                          "Otp Sent Successfully",
                                      snackPosition: SnackPosition
                                          .BOTTOM, // Position: TOP or BOTTOM
                                    );
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {
                                    homeController.isLoading.value = false;
                                    EasyLoading.dismiss();
                                    //EasyLoading.dismiss();
                                    //ConstHelper.errorDialog(
                                    //  text: "Time Out",
                                    //  seconds: 10,
                                    //);
                                    //print('TimeoutError : $verificationId');
                                  },
                                );

                              } else {
                                homeController.isLoading.value = false;
                                EasyLoading.dismiss();
                                ConstHelper.errorDialog(
                                  text: response['msg'] ??
                                      ConstHelper.unauthorizedMsg,
                                  seconds: 10,
                                );
                              }
                            } else {
                              homeController.isLoading.value = false;
                              EasyLoading.dismiss();
                              ConstHelper.errorDialog(
                                text: ConstHelper.unauthorizedMsg,
                                seconds: 10,
                              );
                            }
                          } catch (error) {
                            homeController.isLoading.value = false;
                            EasyLoading.dismiss();
                            ConstHelper.errorDialog(
                              text: error.toString(),
                              //   ConstHelper.somethingErrorMsg,
                              seconds: 10,
                            );
                          }
                        } else {
                          EasyLoading.dismiss();
                          Get.snackbar(
                            "Terms & Conditions",
                            'Accept Terms & Conditions to proceed',
                            snackPosition:
                                SnackPosition.BOTTOM, // Position: TOP or BOTTOM
                          );
                          //ConstHelper.errorDialog(
                          //  text: 'Agree to the Terms & Conditions to proceed',
                          //  seconds: 10,
                          //);
                        }
                      } else {
                        EasyLoading.dismiss();
                        if (homeController.txtUsername.text.trim().isEmpty) {
                          usernameFocusNode.requestFocus();
                        }
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.01,
                ),
                /* InkWell(
                  onTap: () {
                    Get.offAll(() => const SignUpPage());
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't have an account? ",
                            style: GoogleFonts.roboto(
                              fontSize: Get.height / 65,
                              color: AppColors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: " Sign Up",
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
                ),*/
              ],
            ),
          ),
        ),
      ),
    ));
  }

}